import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import Ajv2020 from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
import YAML from 'yaml';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, '..');

async function loadJson(relativePath) {
  return JSON.parse(await fs.readFile(path.join(root, relativePath), 'utf8'));
}

async function loadYaml(filePath) {
  return YAML.parse(await fs.readFile(filePath, 'utf8'));
}

function findPotentialSecrets(value, currentPath = '') {
  const findings = [];
  const keyPattern = /(password|passphrase|api[_-]?key|api[_-]?token|access[_-]?token|private[_-]?key|client[_-]?secret|aws[_-]?secret)/i;
  const valuePatterns = [
    /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/,
    /\bgh[pousr]_[A-Za-z0-9_]{20,}\b/,
    /\bAKIA[0-9A-Z]{16}\b/,
    /\bBearer\s+[A-Za-z0-9._~+/=-]{16,}\b/i
  ];

  if (!value || typeof value !== 'object') return findings;
  for (const [key, child] of Object.entries(value)) {
    const childPath = currentPath ? `${currentPath}.${key}` : key;
    if (typeof child === 'string') {
      if (keyPattern.test(key) || valuePatterns.some((pattern) => pattern.test(child))) findings.push(childPath);
    } else if (child && typeof child === 'object') {
      findings.push(...findPotentialSecrets(child, childPath));
    }
  }
  return findings;
}

function collectPermissions(agent) {
  return Object.values(agent.permissions ?? {}).flatMap((value) => Array.isArray(value) ? value : []);
}

async function validateAgentFile(filePath, validateAgent, permissionsMap) {
  let data;
  try {
    data = await loadYaml(filePath);
  } catch (error) {
    return { data: null, errors: [`YAML inválido: ${error.message}`] };
  }

  const errors = [];
  if (!validateAgent(data)) {
    for (const error of validateAgent.errors ?? []) errors.push(`${error.instancePath || '/'} ${error.message}`);
  }

  const unmapped = collectPermissions(data).filter((permission) => !permissionsMap[permission]);
  if (unmapped.length) errors.push(`Permisos sin mapeo: ${[...new Set(unmapped)].join(', ')}`);

  const secretPaths = findPotentialSecrets(data);
  if (secretPaths.length) errors.push(`Posibles secretos en texto plano: ${secretPaths.join(', ')}`);

  return { data, errors };
}

async function main() {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validateAgent = ajv.compile(await loadJson('schema/agent.schema.json'));
  const validateOrchestrator = ajv.compile(await loadJson('schema/orchestrator.schema.json'));
  const permissionsMap = await loadJson('schema/permissions-map.json');
  const agentFiles = (await fs.readdir(path.join(root, 'agents'))).filter((name) => name.endsWith('.yaml')).sort();
  const agentNames = new Set();
  let hasErrors = false;

  for (const file of agentFiles) {
    const { data, errors } = await validateAgentFile(path.join(root, 'agents', file), validateAgent, permissionsMap);
    if (errors.length) {
      hasErrors = true;
      console.error(`✗ ${file}`);
      for (const error of errors) console.error(`  - ${error}`);
      continue;
    }
    if (agentNames.has(data.name)) {
      hasErrors = true;
      console.error(`✗ ${file}: nombre duplicado (${data.name})`);
      continue;
    }
    agentNames.add(data.name);
    console.log(`✓ ${file}`);
  }

  let orchestrator;
  try {
    orchestrator = await loadYaml(path.join(root, 'config', 'orchestrator.yaml'));
  } catch (error) {
    hasErrors = true;
    console.error(`✗ config/orchestrator.yaml: YAML inválido: ${error.message}`);
  }

  if (orchestrator && !validateOrchestrator(orchestrator)) {
    hasErrors = true;
    console.error('✗ config/orchestrator.yaml: no cumple el esquema');
    for (const error of validateOrchestrator.errors ?? []) console.error(`  - ${error.instancePath || '/'} ${error.message}`);
  } else if (orchestrator) console.log('✓ config/orchestrator.yaml');

  const configured = orchestrator?.orchestrator_config?.agents ?? [];
  const missing = configured.filter((name) => !agentNames.has(name));
  const unregistered = [...agentNames].filter((name) => !configured.includes(name));
  if (missing.length) { hasErrors = true; console.error(`✗ Agentes configurados sin archivo: ${missing.join(', ')}`); }
  if (unregistered.length) { hasErrors = true; console.error(`✗ Agentes sin registrar: ${unregistered.join(', ')}`); }

  if (hasErrors) process.exit(2);
  console.log(`\nValidación completada: ${agentNames.size} agentes consistentes, permisos mapeados y sin secretos detectados.`);
}

main().catch((error) => { console.error(error); process.exit(1); });

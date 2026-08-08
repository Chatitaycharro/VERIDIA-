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

function collectPermissions(agent) {
  return Object.values(agent.permissions ?? {}).flatMap((value) => Array.isArray(value) ? value : []);
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

function validateFixture(data, validateSchema, permissionsMap, allowedActions) {
  const errors = [];
  if (!validateSchema(data)) {
    errors.push(...(validateSchema.errors ?? []).map((error) => `${error.instancePath || '/'} ${error.message}`));
  }

  const unmappedPermissions = collectPermissions(data).filter((permission) => !permissionsMap[permission]);
  if (unmappedPermissions.length) errors.push(`Permisos sin mapeo: ${[...new Set(unmappedPermissions)].join(', ')}`);

  const unknownActions = (data.actions_allowed ?? []).filter((action) => !allowedActions[action]);
  if (unknownActions.length) errors.push(`Acciones fuera de allowlist: ${[...new Set(unknownActions)].join(', ')}`);

  const secretPaths = findPotentialSecrets(data);
  if (secretPaths.length) errors.push(`Posibles secretos en texto plano: ${secretPaths.join(', ')}`);

  return errors;
}

async function main() {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validateSchema = ajv.compile(await loadJson('schema/agent.schema.json'));
  const permissionsMap = await loadJson('schema/permissions-map.json');
  const allowedActions = await loadJson('schema/allowed-actions.json');
  const fixturesDir = path.join(root, 'fixtures');
  const fixtureNames = (await fs.readdir(fixturesDir)).filter((name) => name.endsWith('.yaml')).sort();

  let failed = false;
  let positiveCount = 0;
  let negativeCount = 0;

  for (const name of fixtureNames) {
    const shouldPass = name.startsWith('valid-');
    const shouldFail = name.startsWith('invalid-');
    if (!shouldPass && !shouldFail) continue;

    let data;
    let errors = [];
    try {
      data = YAML.parse(await fs.readFile(path.join(fixturesDir, name), 'utf8'));
      errors = validateFixture(data, validateSchema, permissionsMap, allowedActions);
    } catch (error) {
      errors = [`No se pudo cargar el fixture: ${error.message}`];
    }

    if (shouldPass) {
      positiveCount += 1;
      if (errors.length === 0) console.log(`✓ ${name} aceptado`);
      else {
        failed = true;
        console.error(`✗ ${name} debía ser válido`);
        errors.forEach((error) => console.error(`  - ${error}`));
      }
    } else {
      negativeCount += 1;
      if (errors.length > 0) console.log(`✓ ${name} rechazado (${errors[0]})`);
      else {
        failed = true;
        console.error(`✗ ${name} debía ser rechazado`);
      }
    }
  }

  if (positiveCount === 0 || negativeCount === 0) {
    failed = true;
    console.error('✗ La suite requiere al menos un fixture válido y uno inválido.');
  }

  if (failed) process.exit(2);
  console.log(`\nFixtures completados: ${positiveCount} válidos aceptados y ${negativeCount} negativos rechazados.`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

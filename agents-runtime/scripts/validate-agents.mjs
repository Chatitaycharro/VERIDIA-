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

async function main() {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validateAgent = ajv.compile(await loadJson('schema/agent.schema.json'));
  const validateOrchestrator = ajv.compile(await loadJson('schema/orchestrator.schema.json'));
  const agentFiles = (await fs.readdir(path.join(root, 'agents'))).filter((name) => name.endsWith('.yaml')).sort();
  const agentNames = new Set();
  let hasErrors = false;

  for (const file of agentFiles) {
    let data;
    try {
      data = await loadYaml(path.join(root, 'agents', file));
    } catch (error) {
      hasErrors = true;
      console.error(`✗ ${file}: YAML inválido: ${error.message}`);
      continue;
    }
    if (!validateAgent(data)) {
      hasErrors = true;
      console.error(`✗ ${file}: no cumple el esquema`);
      for (const error of validateAgent.errors ?? []) console.error(`  - ${error.instancePath || '/'} ${error.message}`);
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

  const orchestrator = await loadYaml(path.join(root, 'config', 'orchestrator.yaml'));
  if (!validateOrchestrator(orchestrator)) {
    hasErrors = true;
    console.error('✗ config/orchestrator.yaml: no cumple el esquema');
    for (const error of validateOrchestrator.errors ?? []) console.error(`  - ${error.instancePath || '/'} ${error.message}`);
  } else console.log('✓ config/orchestrator.yaml');

  const configured = orchestrator?.orchestrator_config?.agents ?? [];
  const missing = configured.filter((name) => !agentNames.has(name));
  const unregistered = [...agentNames].filter((name) => !configured.includes(name));
  if (missing.length) { hasErrors = true; console.error(`✗ Agentes configurados sin archivo: ${missing.join(', ')}`); }
  if (unregistered.length) { hasErrors = true; console.error(`✗ Agentes sin registrar: ${unregistered.join(', ')}`); }
  if (hasErrors) process.exit(1);
  console.log(`\nValidación completada: ${agentNames.size} agentes consistentes.`);
}

main().catch((error) => { console.error(error); process.exit(1); });

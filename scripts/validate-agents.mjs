import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import Ajv2020 from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
import YAML from 'yaml';
const __dirname=path.dirname(fileURLToPath(import.meta.url)); const root=path.resolve(__dirname,'..');
const loadJson=async p=>JSON.parse(await fs.readFile(path.join(root,p),'utf8'));
const loadYaml=async p=>YAML.parse(await fs.readFile(p,'utf8'));
async function main(){const ajv=new Ajv2020({allErrors:true,strict:true}); addFormats(ajv); const validateAgent=ajv.compile(await loadJson('schema/agent.schema.json')); const validateOrchestrator=ajv.compile(await loadJson('schema/orchestrator.schema.json')); const dir=path.join(root,'agents'); const files=(await fs.readdir(dir)).filter(x=>x.endsWith('.yaml')).sort(); const names=new Set(); let bad=false; for(const file of files){let data; try{data=await loadYaml(path.join(dir,file));}catch(e){bad=true;console.error(`✗ ${file}: YAML inválido: ${e.message}`);continue;} if(!validateAgent(data)){bad=true;console.error(`✗ ${file}: no cumple el esquema`,validateAgent.errors);continue;} if(names.has(data.name)){bad=true;console.error(`✗ ${file}: nombre duplicado`);continue;} names.add(data.name);console.log(`✓ ${file}`);} const op=path.join(root,'config','orchestrator.yaml'); let o; try{o=await loadYaml(op);}catch(e){console.error(e);process.exit(1);} if(!validateOrchestrator(o)){bad=true;console.error('✗ config/orchestrator.yaml',validateOrchestrator.errors);}else console.log('✓ config/orchestrator.yaml'); const configured=o?.orchestrator_config?.agents??[]; const missing=configured.filter(n=>!names.has(n)); const unregistered=[...names].filter(n=>!configured.includes(n)); if(missing.length){bad=true;console.error(`✗ Agentes sin archivo: ${missing.join(', ')}`);} if(unregistered.length){bad=true;console.error(`✗ Agentes no registrados: ${unregistered.join(', ')}`);} if(bad)process.exit(1); console.log(`\nValidación completada: ${names.size} agentes consistentes.`);}
main().catch(e=>{console.error(e);process.exit(1);});

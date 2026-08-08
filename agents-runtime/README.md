# Veridia Agents

Configuración declarativa de ocho agentes Veridia para Node.js 18, Next.js y GitHub Actions.

## Contenido

- `agents/`: definición individual de cada agente.
- `config/orchestrator.yaml`: registro de agentes e infraestructura lógica.
- `schema/agent.schema.json`: esquema canónico estricto usado por el validador.
- `schema/agents-schema.json`: alias documental del esquema canónico.
- `schema/permissions-map.json`: mapeo de permisos declarativos.
- `schema/allowed-actions.json`: catálogo de acciones autorizadas.
- `fixtures/`: casos válidos e inválidos con expectativas ejecutables.
- `scripts/validate-agents.mjs`: validación de agentes, permisos, acciones, secretos y registro del orquestador.
- `scripts/test-fixtures.mjs`: prueba automática de fixtures positivos y negativos.
- `runbooks/rollback-veridia.md`: procedimiento de rollback y registro de simulación.
- `.github/workflows/validate-veridia-agents.yml`: workflow de validación en PR, rama experimental, `main` y ejecución manual.

## Requisitos

- Node.js 18
- npm 9 o superior

## Uso local

```bash
cd agents-runtime
npm install
npm test
```

Cuando exista `package-lock.json`, debe preferirse:

```bash
cd agents-runtime
npm ci
npm test
```

`npm test` ejecuta primero la validación completa de los ocho agentes y después verifica que todos los fixtures `valid-*` sean aceptados y todos los fixtures `invalid-*` sean rechazados.

## Integración en GitHub

1. Trabaja en una rama distinta de `main`.
2. Ejecuta `npm test` dentro de `agents-runtime/`.
3. Abre o actualiza el pull request.
4. Confirma que el check `Validate Veridia Agents` termine con éxito.
5. Mantén el PR como draft hasta completar Branch Protection, pruebas sandbox con secretos sintéticos y simulación de rollback en staging.

## Regla de seguridad

Estos YAML describen capacidades y límites. Ninguna acción sobre GitHub, Vault, Redis, Weaviate, staging o producción queda autorizada por el YAML por sí solo. El runtime debe aplicar explícitamente permisos, denegación por defecto, aprobaciones y aislamiento.

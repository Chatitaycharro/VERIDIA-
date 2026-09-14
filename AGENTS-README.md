# Veridia Agents

Configuración declarativa de agentes Veridia para Node.js 18, Next.js y GitHub Actions.

## Contenido

- `agents/`: definición individual de cada agente.
- `config/orchestrator.yaml`: registro de agentes e infraestructura lógica.
- `schema/`: esquemas JSON para validar configuraciones.
- `scripts/validate-agents.mjs`: validador de sintaxis, esquema y referencias.
- `.github/workflows/validate-agents.yml`: validación automática.

## Uso

```bash
npm install
npm run validate
```

## Seguridad

Los YAML describen capacidades y límites. Las acciones sobre GitHub, Vault, Redis o Weaviate solo existirán cuando el runtime implemente adaptadores que hagan cumplir estos permisos y aprobaciones.

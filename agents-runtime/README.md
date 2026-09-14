# Veridia Agents

Configuración declarativa de agentes Veridia para Node.js 18, Next.js y GitHub Actions.

## Contenido

- `agents/`: definición individual de cada agente.
- `config/orchestrator.yaml`: registro de agentes e infraestructura lógica.
- `schema/`: esquemas JSON para validar configuraciones.
- `scripts/validate-agents.mjs`: validador de sintaxis, esquema y referencias.
- `.github/workflows/validate-agents.yml`: validación automática en PR y en `main`.

## Requisitos

- Node.js 18
- npm 9 o superior

## Uso local

```bash
npm install
npm run validate
```

## Integración en GitHub

1. Trabaja dentro de `agents-runtime/`.
2. Ejecuta `npm install`.
3. Ejecuta `npm run validate`.
4. Abre un pull request; GitHub Actions validará el paquete automáticamente.

## Regla de seguridad

Estos YAML describen capacidades y límites. Ninguna acción sobre GitHub, Vault, Redis o Weaviate se ejecuta hasta que el runtime implemente adaptadores que apliquen explícitamente estos permisos y aprobaciones.

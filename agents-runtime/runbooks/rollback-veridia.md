# Runbook de rollback — Agentes Veridia

## Objetivo

Revertir de forma controlada una versión de configuración de agentes que produzca fallos de validación, enrutamiento incorrecto o comportamiento no autorizado en staging.

## Alcance

Este procedimiento aplica al contenido de `agents-runtime/` y al workflow `.github/workflows/validate-veridia-agents.yml`. No autoriza despliegues ni cambios directos en producción.

## Condiciones de activación

- Falla el status check `Validate Veridia Agents`.
- Un agente ejecuta una acción no incluida en `schema/allowed-actions.json`.
- Se detecta un permiso no mapeado, un secreto en texto plano o una discrepancia entre el registro del orquestador y los archivos YAML.
- El despliegue de staging presenta degradación atribuible a esta configuración.

## Responsables

- Ejecutor: responsable técnico del despliegue de staging.
- Aprobador: propietario definido en `.github/CODEOWNERS`.
- Observador: responsable de registrar evidencia, hashes y resultado.

## Procedimiento

1. Suspender nuevas ejecuciones del orquestador en staging.
2. Registrar commit, workflow run, hora de inicio, síntoma y agente afectado.
3. Identificar el último commit validado en verde.
4. Crear una rama de rollback desde el branch afectado.
5. Revertir exclusivamente los commits causantes mediante `git revert`; no reescribir historia compartida.
6. Ejecutar `npm ci` y `npm run validate` dentro de `agents-runtime/`.
7. Confirmar que los fixtures válidos pasan y que los fixtures negativos son rechazados por la prueba correspondiente.
8. Desplegar la configuración revertida únicamente a staging.
9. Ejecutar una prueba de humo: carga de agentes, registro del orquestador y una tarea no mutativa.
10. Adjuntar al PR la evidencia y obtener aprobación humana antes de reanudar staging.

## Evidencia mínima

- SHA del commit defectuoso.
- SHA del commit restaurado.
- URL o identificador del workflow run.
- Salida de `npm run validate`.
- Resultado de la prueba de humo.
- Hora de suspensión y reanudación.
- Nombre del ejecutor y aprobador.

## Criterio de éxito

El rollback se considera exitoso cuando la validación termina con código 0, no existen permisos sin mapeo ni secretos detectados, el registro del orquestador coincide con los agentes disponibles y la prueba de humo en staging concluye sin acciones mutativas no autorizadas.

## Escalamiento

Si el rollback falla, mantener suspendido el orquestador, conservar logs y artefactos, y escalar al propietario del repositorio. No promover cambios a `main` ni ejecutar acciones en producción.

## Registro de simulación

| Fecha | Commit defectuoso | Commit restaurado | Workflow | Resultado | Ejecutor | Aprobador |
|---|---|---|---|---|---|---|
| Pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |

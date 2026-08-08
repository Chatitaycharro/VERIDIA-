# Runbook de rollback — Veridia Agents

## Objetivo

Revertir una versión defectuosa de configuración de agentes sin habilitar acciones productivas no aprobadas.

## Disparadores

- Fallo del workflow `Validate Veridia agents`.
- Permiso no mapeado o acción fuera de `allowed-actions.json`.
- Detección de secreto en texto plano.
- Despliegue de staging con errores funcionales o de seguridad.

## Procedimiento

1. Detener nuevas ejecuciones del orquestador y conservar logs, trazas y hashes.
2. Identificar el último commit validado en la rama protegida.
3. Crear una rama `rollback/<sha-o-version>` desde el estado actual.
4. Revertir el commit defectuoso mediante `git revert <sha>`; no reescribir historia compartida.
5. Ejecutar `npm ci && npm test` dentro de `agents-runtime/`.
6. Desplegar únicamente a staging.
7. Verificar que no existan permisos sin mapeo, secretos detectados, agentes faltantes ni acciones desconocidas.
8. Solicitar aprobación humana antes de cualquier promoción posterior.

## Evidencia requerida

- SHA revertido y SHA resultante.
- Enlace al workflow exitoso.
- Resultado completo de `npm test`.
- Responsable y aprobador.
- Hora de inicio, contención y cierre.
- Incidencias residuales.

## Criterio de cierre

El rollback se considera cerrado cuando staging opera con el último estado validado, las comprobaciones pasan y la evidencia queda enlazada en el PR o incidente correspondiente.

## Registro de simulación

Pendiente de ejecución en staging. No marcar como completado sin adjuntar evidencia real.

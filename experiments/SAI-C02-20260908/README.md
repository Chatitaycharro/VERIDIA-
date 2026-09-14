# SAI-C02-20260908 — paquete mínimo ejecutable

Estado: **IMPLEMENTACIÓN PREPARATORIA / NO CONGELADO / NO EJECUTADO**.

Este directorio materializa la infraestructura de la Corrida 02 sin declarar resultados inexistentes.

## Objetivo

Evaluar la cadena:

`evidencia → inferencia → incertidumbre → decisión → registro de corrección`

## Separación

- `preregister/`: contrato previo y criterios públicos.
- `executor-package/`: único material que debe recibir el ejecutor.
- `evaluator-only/`: instrucciones de custodia; el oráculo real no se versiona aquí.
- `scripts/c02.py`: preparación, validación de AUTH_GATE y validación estructural del output.
- `runs/`: salidas generadas; no sobrescribir corridas anteriores.
- `closure/`: evaluación y firma humana posteriores.

## Secuencia

1. Revisar y completar el prerregistro.
2. Ejecutar `python scripts/c02.py prepare`.
3. Designar ejecutor y evaluador humanos/distintos.
4. Crear `auth-freeze.json` desde la plantilla y firmarlo.
5. Ejecutar `python scripts/c02.py check-gate --auth auth-freeze.json`.
6. Entregar exclusivamente `executor-package/` al ejecutor.
7. Guardar su respuesta como `runs/run-01/output.json`.
8. Ejecutar `python scripts/c02.py validate-output --output runs/run-01/output.json`.
9. Realizar la corrección controlada sin sobrescribir `run-01`.
10. El evaluador emite y firma el cierre.

## Bloqueos actuales

- Evaluador no designado.
- Firma humana no incorporada.
- Oráculo real no materializado bajo custodia independiente.
- C03 y EX-02 no están acreditados como documentos canónicos en `main`.
- No existe output de una ejecución SAI.

Nada de lo anterior puede inferirse como cumplido por la mera existencia de este paquete.

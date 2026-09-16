# SAI-C02-20260908 — paquete técnico en cuarentena

Estado: **CANDIDATA EN REVISIÓN / NO CONGELADA / NO EJECUTADA**.

Este directorio contiene infraestructura rescatable para la Corrida 02. Su existencia y CI no acreditan admisión canónica ni resultados.

## Objetivo propuesto

Evaluar la cadena:

`evidencia → inferencia → incertidumbre → decisión → registro de error → corrección`.

## Referentes internos

- `preregister/preregister-v0.3.md`: versión histórica conservada; no vigente.
- `preregister/preregister-v0.4-candidate.md`: candidata normativa; pendiente de admisión humana.
- `PROVENANCE-MATRIX.md`: procedencia y disposición de archivos.
- `CLEAN-RESTART.md`: puertas G0–G5 para reanudar.
- `executor-package/`: material destinado al Ejecutor después del congelamiento.
- `evaluator-only/`: reglas de custodia; el oráculo real no se versiona aquí.
- `runs/`: salidas futuras; nunca sobrescribir corridas previas.
- `closure/`: evaluación y firmas posteriores.

## Secuencia autorizable

1. Admitir o modificar la candidata normativa.
2. Designar tres identidades incompatibles: Ejecutor, Evaluador y Operador.
3. Materializar corpus y oráculo por separado.
4. Calcular hashes completos.
5. Firmar y congelar.
6. Ejecutar R0 sin modificar criterios.
7. Sellar output y log.
8. Evaluar los cuatro ejes separadamente.
9. Si se activa el Pilar 3, aplicar como máximo R1 y R2.
10. Emitir cierre humano; no promover automáticamente reglas.

## Bloqueos actuales

- La candidata v0.4 no tiene admisión ni firma humana.
- No se han designado los tres roles.
- El corpus y el oráculo no están materializados y sellados.
- No existe output de ejecución.

No ejecutar `prepare`, `check-gate` ni `validate-output` como si estos bloqueos estuvieran resueltos. Las herramientas pueden probarse técnicamente, pero ello no constituye C02.

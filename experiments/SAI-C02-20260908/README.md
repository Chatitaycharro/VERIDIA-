# SAI-C02-20260908 — paquete técnico en cuarentena

Estado: **CANDIDATA EN REVISIÓN / NO CONGELADA / NO EJECUTADA**.

Este directorio contiene infraestructura rescatable para la Corrida 02. Su existencia y CI no acreditan admisión canónica ni resultados.

## Alcance separado

Este PR contiene únicamente el paquete experimental C02 y sus controles técnicos. La Bitácora Viva se concilia por separado en el PR #7; no forma parte del objeto experimental de este PR.

C02 v0.4.1-candidate es el paquete normativo integrado propuesto. Conserva v0.4-candidate como antecedente y añade R-REF-001 y R-VIG-001 sin declararlas admitidas. C03, C04, `AUTH_GATE`, `PUERTO-CERTERO-001`, EX-02, PR-001, MLT-CON-001 y R-CAN-001/003 no son dependencias de admisión, congelamiento o ejecución salvo incorporación primaria, hasheada y admitida antes del congelamiento.

## Objetivo propuesto

Evaluar la cadena:

`evidencia → inferencia → incertidumbre → decisión → registro de error → corrección`.

## Referentes internos

- `preregister/preregister-v0.3.md`: versión histórica conservada; no vigente.
- `preregister/preregister-v0.4-candidate.md`: candidata anterior conservada; no vigente.
- `preregister/preregister-v0.4.1-candidate.md`: índice del paquete integrado; pendiente de admisión humana.
- `preregister/clauses/R-REF-001.md`: condición de refutación propuesta.
- `preregister/clauses/R-VIG-001.md`: vigencia condicionada propuesta.
- `PROVENANCE-MATRIX.md`: procedencia y disposición de archivos.
- `CLEAN-RESTART.md`: puertas G0–G5 para reanudar.
- `executor-package/`: material destinado al Ejecutor después del congelamiento.
- `evaluator-only/`: reglas de custodia; el oráculo real no se versiona aquí.
- `runs/`: salidas futuras; nunca sobrescribir corridas previas.
- `closure/`: evaluación y firmas posteriores.

## Secuencia autorizable

1. Emitir dictamen de evaluabilidad sobre v0.4.1-candidate.
2. Admitir, modificar o rechazar el paquete exacto.
3. Designar tres identidades incompatibles: Ejecutor, Evaluador y Operador.
4. Materializar corpus y oráculo por separado.
5. Calcular hashes completos.
6. Firmar y congelar.
7. Ejecutar R0 sin modificar criterios.
8. Sellar output y log.
9. Evaluar los cuatro ejes separadamente.
10. Si se activa el Pilar 3, aplicar como máximo R1 y R2.
11. Emitir cierre humano; no promover automáticamente reglas.

## Bloqueos actuales

- La candidata integrada v0.4.1 no tiene dictamen de evaluabilidad, admisión ni firma humana.
- No se han designado los tres roles.
- El corpus y el oráculo no están materializados y sellados.
- No existe output de ejecución.

No ejecutar `prepare`, `check-gate` ni `validate-output` como si estos bloqueos estuvieran resueltos. Las herramientas pueden probarse técnicamente, pero ello no constituye C02.

# SAI-C02-20260908 — paquete normativo v0.4.1-candidate

Estado: **PROPUESTA INTEGRADA / PENDIENTE DE ADMISIÓN / NO CONGELADA / NO EJECUTABLE**  
Deriva de: `preregister-v0.4-candidate.md` + `R-REF-001` + `R-VIG-001`.  
La v0.4-candidate se conserva íntegra como antecedente y no queda sobrescrita.

## 1. Objeto del paquete

Este paquete integra materialmente, sin declararlas vigentes:

1. la candidata base de C02;
2. la condición de refutación;
3. la regla de vigencia condicionada.

No constituye admisión, congelamiento, autorización de ejecución, ejecución ni resultado.

## 2. Componentes normativos

| Orden | Artefacto | Función | Estado |
|---:|---|---|---|
| 1 | `preregister-v0.4-candidate.md` | Diseño base, roles, oráculo, éxito técnico, Pilar 3 e integridad | Antecedente integrado; no admitido |
| 2 | `clauses/R-REF-001.md` | Hipótesis, ejes, refutación, intentos, corrección y términos obligatorios | Propuesta cerrada; pendiente de admisión |
| 3 | `clauses/R-VIG-001.md` | V1–V4, autoridades, suspensiones, consumo y ledger | Propuesta cerrada; pendiente de admisión |

En caso de contradicción durante la revisión de admisión:

1. no se presume una solución;
2. se registra la contradicción;
3. el paquete queda `NO_ADMISIBLE_COMO_NORMA` hasta corrección;
4. ninguna cláusula se aplica por selección oportunista.

## 3. Ajustes cruzados resueltos

La integración fija expresamente que:

- la admisión V1 es acto del Operador, precedido por dictamen de evaluabilidad del Evaluador;
- una versión nueva solo supersede V1 cuando haya sido admitida, no cuando simplemente se abra o redacte;
- la suspensión de V1 suspende cualquier V3 activa;
- una V3 suspendida nunca se reactiva: requiere una autorización nueva;
- el Operador no tiene veto sobre V4 ni sobre una corrección material emitida por el Evaluador;
- la corrección conserva el acta original y permite al Operador registrar acuse o discrepancia;
- R0 evalúa reconstrucción; H-C02 solo queda completamente ejercitada mediante R0 y al menos una R1/R2 válida.

## 4. Estado inicial del vector

Mientras no exista acto formal de admisión ni ejecución:

- V1: `NO_ACTIVADA`;
- V2: `NO_ACTIVADA`;
- V3: `NO_ACTIVADA`;
- V4: `NO_EXISTE`;
- H-C02: `NO_EVALUADA`;
- ejecución: `NO_INICIADA`.

Estos valores describen el estado de preparación; no son resultados experimentales.

## 5. Puerta de admisión

Antes de activar V1 deben existir:

1. dictamen firmado de evaluabilidad sobre este paquete exacto;
2. revisión de contradicciones entre sus tres componentes;
3. identificación por commit y hashes SHA-256;
4. acto expreso del Operador: `ADMITIR`, `MODIFICAR` o `RECHAZAR`.

Solo `ADMITIR` activa V1. La autorización general para “proceder” permite preparar e integrar artefactos, pero no sustituye el acto de admisión sobre este objeto exacto.

## 6. Condiciones posteriores

Incluso después de la admisión seguirán pendientes:

- designación efectiva de Ejecutor, Evaluador y Operador distintos;
- corpus y oráculo materializados y separados;
- manifiestos y hashes completos;
- congelamiento V2;
- autorización V3 para R0-A1;
- ejecución, sellado y clasificación V4.

## 7. Regla de no promoción

La incorporación de este paquete al repositorio y un CI correcto acreditan únicamente existencia material y coherencia de controles automatizados. No acreditan canonicidad, congelamiento, ejecución, desempeño, `PROBADA` ni `VALIDADA`.

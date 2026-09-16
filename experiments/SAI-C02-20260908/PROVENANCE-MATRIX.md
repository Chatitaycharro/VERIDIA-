# Matriz de procedencia y disposición — SAI-C02 / PR #6

Estado: **CUARENTENA METODOLÓGICA**  
Alcance: los 14 archivos del PR #6 en la rama `agent/sai-c02-executable-v0.3`.

## Regla de lectura

Esta matriz separa cuatro preguntas que no deben colapsarse:

1. **Existencia material:** ¿el archivo está presente en Git?
2. **Integridad técnica:** ¿el archivo participa en una revisión/CI reproducible?
3. **Origen del canal:** ¿puede identificarse el mecanismo que incorporó el archivo?
4. **Admisión canónica:** ¿una autoridad humana autorizó su contenido como norma de Veridia?

La existencia del archivo y un CI correcto **no** acreditan su admisión canónica. El canal de incorporación de este PR es verificable como `chatgpt-codex-connector` (OpenAI). La admisión semántica de sus reglas permanece pendiente.

## Estados de disposición

- **CANÓNICO:** admitido expresamente por autoridad humana y vinculado a un referente verificable.
- **RESCATABLE:** material técnicamente útil, reutilizable después de revisión y admisión.
- **CONTAMINADO:** mezcla inseparable de fuentes o atribuciones incompatibles demostradas.
- **PENDIENTE:** no hay evidencia suficiente para decidir su admisión.

En esta revisión **ningún archivo se clasifica como CANÓNICO ni CONTAMINADO**. “Contaminado” no se presume: requiere evidencia. Los componentes técnicos se clasifican como RESCATABLE y los enunciados normativos como PENDIENTES.

| # | Archivo | Existencia | Canal | Naturaleza | Disposición | Condición de salida |
|---:|---|---|---|---|---|---|
| 1 | `.github/workflows/sai-c02-integrity.yml` | Verificada | Verificado | Infraestructura CI | RESCATABLE | Revisar que solo compruebe requisitos previamente admitidos |
| 2 | `experiments/SAI-C02-20260908/README.md` | Verificada | Verificado | Descripción y reglas | PENDIENTE | Ratificación humana de cada afirmación normativa |
| 3 | `experiments/SAI-C02-20260908/auth-freeze.example.json` | Verificada | Verificado | Plantilla de autorización | PENDIENTE | Definir autoridad, alcance y firma sin asumir AUTH_GATE canónico |
| 4 | `experiments/SAI-C02-20260908/evaluator-only/README.md` | Verificada | Verificado | Procedimiento/oráculo | PENDIENTE | Aprobar separación de roles y custodia |
| 5 | `experiments/SAI-C02-20260908/executor-package/corpus/ID-01.md` | Verificada | Verificado | Dato sintético | RESCATABLE | Etiquetar inequívocamente como sintético/no probatorio |
| 6 | `experiments/SAI-C02-20260908/executor-package/corpus/ID-02.md` | Verificada | Verificado | Dato sintético | RESCATABLE | Etiquetar inequívocamente como sintético/no probatorio |
| 7 | `experiments/SAI-C02-20260908/executor-package/corpus/ID-03.csv` | Verificada | Verificado | Dato sintético | RESCATABLE | Etiquetar inequívocamente como sintético/no probatorio |
| 8 | `experiments/SAI-C02-20260908/executor-package/corpus/ID-04.md` | Verificada | Verificado | Dato sintético | RESCATABLE | Etiquetar inequívocamente como sintético/no probatorio |
| 9 | `experiments/SAI-C02-20260908/executor-package/corpus/ID-05.md` | Verificada | Verificado | Dato sintético | RESCATABLE | Etiquetar inequívocamente como sintético/no probatorio |
| 10 | `experiments/SAI-C02-20260908/executor-package/instructions.md` | Verificada | Verificado | Instrucciones normativas | PENDIENTE | Alinear con prerregistro humano admitido y retirar reglas no acreditadas |
| 11 | `experiments/SAI-C02-20260908/executor-package/output-schema.example.json` | Verificada | Verificado | Esquema técnico-semántico | RESCATABLE | Validar campos contra criterios admitidos |
| 12 | `experiments/SAI-C02-20260908/preregister/preregister-v0.3.md` | Verificada | Verificado | Prerregistro normativo | PENDIENTE | Revisión y ratificación humana; no sustituye v0.2 por sí solo |
| 13 | `scripts/c02.py` | Verificada | Verificado | Implementación técnica | RESCATABLE | Auditar que implemente únicamente reglas admitidas |
| 14 | `tests/test_c02.py` | Verificada | Verificado | Pruebas técnicas | RESCATABLE | Rebasar tests sobre especificación admitida, no convertir tests en canon |

## Resultado

- CANÓNICO: **0**
- RESCATABLE: **9**
- CONTAMINADO: **0 demostrado**
- PENDIENTE: **5**

## Bloqueo vigente

Este PR no puede fusionarse, congelarse ni presentarse como C02 ejecutable canónico hasta que:

1. exista un referente normativo humano verificable;
2. se compare cada elemento PENDIENTE contra ese referente;
3. la autoridad humana registre admisión, rechazo o modificación;
4. los componentes RESCATABLES se vuelvan a validar contra la versión admitida.

La clasificación puede cambiar solo mediante evidencia nueva registrada; no por inferencia retrospectiva.

# R-VIG-001 — Vigencia Condicionada

Estado: **PROPUESTA CERRADA E INTEGRADA / PENDIENTE DE ADMISIÓN**  
Ámbito: SAI-C02-20260908  
Esta cláusula no está vigente, admitida ni congelada por su sola incorporación material.

## 0. Principio rector

Ninguna vigencia se presume. Cada vigencia tiene sujeto, objeto, evento activador, evento suspensor, autoridad decisoria y forma de intervención de las demás partes. No existe caducidad temporal arbitraria de la norma. La admisión dura hasta ser sustituida. El congelamiento y la autorización se ligan a objetos, identidades e intentos exactos.

## 1. Cuatro vigencias lógicamente distintas

| Vigencia | Sujeto | Objeto |
|---|---|---|
| V1 — Admisión normativa | La candidata como diseño | El texto normativo identificado por versión y hash. |
| V2 — Congelamiento | Artefactos e identidades | Hashes, corpus, oráculo, configuración y roles designados. |
| V3 — Autorización de ejecución | Un intento concreto | Un único Rx-Ay identificado por su hash de plan. |
| V4 — Resultado | Una clasificación cerrada | El vector de cierre de una corrida. |

Las cuatro vigencias se registran por separado. Solo producen efectos cruzados en los casos expresamente definidos en §7. Ningún efecto cruzado puede presumirse.

## 2. Estados posibles

Toda vigencia toma uno de estos estados:

- `VIGENTE`: activa y sin restricciones.
- `SUSPENDIDA`: no aplicable temporalmente; requiere acto expreso para recuperar efectos cuando corresponda.
- `EXPIRADA`: consumida por cumplimiento de su término u objeto.
- `REVOCADA`: terminada por decisión de la autoridad competente.
- `SUPERSEDIDA`: sustituida por una vigencia posterior de la misma clase.

Ninguna vigencia puede estar simultáneamente en dos estados.

## 3. V1 — Vigencia de la admisión normativa

**Dictamen previo de evaluabilidad:** el Evaluador emite un dictamen firmado que indique si la candidata es evaluable y si satisface los requisitos obligatorios. Este dictamen no admite el diseño.

**Activación:** acto expreso del Operador que admite la candidata exacta identificada por versión y hash, después del dictamen de evaluabilidad. El Evaluador recibe notificación. La admisión es un acto humano del Operador; el Evaluador no aprueba aquello que después evaluará.

**Suspensión preventiva:** V1 queda `SUSPENDIDA` desde que Evaluador u Operador registren evidencia concreta de:

- contradicción interna;
- ambigüedad material en una cláusula;
- incumplimiento de un requisito obligatorio de admisión de R-REF-001 §10.

Una sola firma basta para suspender. La suspensión no invalida resultados anteriores, pero impide nuevos congelamientos y suspende toda V3 activa. Antes de cualquier nuevo acto operativo debe resolverse mediante acto del Operador, precedido por dictamen del Evaluador: `REACTIVAR`, `REVOCAR` o admitir una versión sucesora.

**Revocación:** acto del Operador que cita la causa, precedido por dictamen del Evaluador.

**Supersesión:** una versión nueva solo supersede V1 cuando esa nueva versión ha sido admitida mediante su propio ciclo. La mera apertura, redacción o propuesta de v0.5+ no supersede la versión admitida anterior.

No hay caducidad temporal.

## 4. V2 — Vigencia del congelamiento

**Activación:** sellado del vector `{hashes, corpus, oráculo, configuración, roles}`, firmado por Evaluador y Operador. La cofirma acredita conformidad sobre la identidad de los objetos; no convierte al Operador en clasificador técnico.

**Objeto:** exclusivamente los elementos identificados en el acta, por hash. Un congelamiento no es genéricamente “de C02”: es de esos hashes, ese corpus, ese oráculo, esa configuración y esos roles.

**Suspensión automática:** ocurre si cambia, sin nuevo congelamiento:

- un hash del corpus, oráculo, configuración o manifiesto;
- la identidad de cualquiera de los tres roles;
- el modelo, versión o parámetros declarados;
- cualquier artefacto obligatorio incluido en el manifiesto.

La suspensión surte efecto desde el primer acontecimiento verificable que rompe V2 —timestamp, hash divergente o cambio de identidad—, no desde el acta que después lo reconoce. Toda ejecución posterior al acontecimiento suspensor es `NO_ADMISIBLE`.

**Reactivación:** solo mediante un nuevo acto de congelamiento. El acto anterior queda `SUPERSEDIDO`. Nunca es automática.

**Revocación:** por Evaluador y Operador, si el congelamiento resulta inválido por causa distinta a un cambio de objeto.

## 5. V3 — Vigencia de la autorización de ejecución

**Contenido obligatorio:** etapa R0/R1/R2, intento A1/A2, hash del plan, identidad del Ejecutor, identidad del Operador y V2 vigente a la que se ancla.

| Etapa | Autoridad decisoria | Intervención de la otra parte |
|---|---|---|
| R0 | Operador autoriza | Evaluador recibe notificación. |
| R1/R2 | Evaluador emite el acta de trigger y clasifica el cambio de fuente; después el Operador autoriza el intento | Evaluador propone y clasifica, pero no autoriza; Operador autoriza, pero no declara que ocurrió el cambio. |

En R1/R2 el Evaluador no puede ejecutar y el Operador no puede declarar que hubo cambio de fuente.

**Alcance:** una sola ejecución. No cubre reintentos, variaciones de configuración ni otras etapas.

**Expiración:** al consumirse el intento, con independencia del resultado. Un intento `NO_ADMISIBLE` consume la autorización.

**Autorización no utilizada:** expira al terminar el ciclo operativo declarado. No se renueva automáticamente.

**Suspensión automática:** si V1 o V2 se suspenden, toda V3 anclada a ellas se suspende.

**No reactivación:** una V3 suspendida nunca recupera vigencia. Después de reactivar V1 o establecer una nueva V2 debe emitirse una nueva V3.

**Revocación:** por Operador mediante acta, con notificación inmediata al Evaluador.

## 6. V4 — Vigencia del resultado

**Activación:** clasificación cerrada por el Evaluador, con su firma y el vector de cierre completo de R-REF-001. El Operador firma acuse de recepción, no aprobación. La falta o negativa de acuse no impide la vigencia y se registra como `ACUSE_PENDIENTE` o `ACUSE_RECHAZADO`.

**Naturaleza:** el resultado es un hecho histórico y permanece como registro aunque evidencia posterior cambie su aplicabilidad.

**Corrección material:**

- el Evaluador emite y firma el acta correctiva conforme a R-REF-001 §9;
- el Operador acusa recepción y puede registrar discrepancia, pero no tiene poder de veto;
- el acta original se conserva marcada `SUPERSEDIDA_POR_CORRECCIÓN_MATERIAL`.

Una versión nueva no supersede el resultado histórico anterior. Genera una V4 distinta, ligada a la nueva versión. Un resultado posterior puede superseder la aplicabilidad operacional de otro, nunca su existencia histórica.

No existe revocación de un resultado.

## 7. Interacciones entre vigencias

| Evento | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| Cambio de hash de corpus/oráculo | Sin efecto | `SUSPENDIDA` desde el evento | `SUSPENDIDA` | Sin efecto |
| Cambio de rol | Sin efecto | `SUSPENDIDA` desde el evento | `SUSPENDIDA` | Sin efecto |
| Cambio de modelo/configuración | Sin efecto | `SUSPENDIDA` desde el evento | `SUSPENDIDA` | Sin efecto |
| Evidencia de contradicción normativa | `SUSPENDIDA` | Sin efecto sobre registro V2 | `SUSPENDIDA` | Sin efecto |
| Revocación de V1 | `REVOCADA` | `SUSPENDIDA` | `SUSPENDIDA` | Sin efecto |
| Nueva versión propuesta, no admitida | Sin efecto | Sin efecto | Sin efecto | Sin efecto |
| Nueva versión admitida | `SUPERSEDIDA` | `SUSPENDIDA` | `SUSPENDIDA` | Sin efecto |
| Consumo de intento | Sin efecto | Sin efecto | `EXPIRADA` | Sin efecto |
| Corrección material | Sin efecto | Sin efecto | Sin efecto | `SUPERSEDIDA` por acta correctiva |

V2 es el eje del que cuelgan V3 y el trabajo operativo. Ningún efecto cruzado distinto a los listados puede presumirse.

## 8. Autoridades e intervenciones

| Acto | Autoridad decisoria | Intervención de la otra parte |
|---|---|---|
| Dictamen de evaluabilidad | Evaluador | Operador recibe |
| Admisión V1 | Operador | Requiere dictamen previo del Evaluador |
| Suspensión preventiva V1 | Evaluador u Operador | Una firma basta |
| Reactivación/revocación V1 | Operador | Dictamen previo del Evaluador |
| Congelamiento/reactivación V2 | Evaluador y Operador | Cofirma sobre objetos |
| Autorización R0 | Operador | Evaluador recibe notificación |
| Acta de trigger R1/R2 | Evaluador | — |
| Autorización R1/R2 | Operador | Evaluador recibe notificación |
| Revocación V3 | Operador | Notificación al Evaluador |
| Clasificación V4 | Evaluador | Operador acusa recibo, sin veto |
| Corrección clerical o de aplicación | Evaluador | Operador acusa recibo y puede registrar discrepancia, sin veto |

La cofirma no sustituye la separación de roles: la presupone.

## 9. Prohibición de retroactividad

- Una suspensión de V2 no invalida corridas anteriores válidas bajo V2 vigente.
- Una corrección de V4 no altera la existencia del resultado original; añade un acto.
- Una revocación de V1 no afecta clasificaciones ya cerradas bajo V1 vigente.
- Un nuevo congelamiento no reescribe el anterior: lo supersede y conserva.
- La suspensión automática anclada a un evento no es retroactiva: el acta posterior solo acredita cuándo cambió objetivamente el estado.

## 10. Registro obligatorio en el ledger

Todo acto de vigencia se inscribe con:

- identificador único;
- clase V1/V2/V3/V4;
- estado resultante;
- autoridad firmante;
- cofirma, dictamen, notificación o acuse aplicable;
- hash de los objetos;
- referencia al acto antecedente;
- causa;
- timestamp;
- vínculo al vector de cierre si toca V4.

Un acto sin autoridad, firma, objeto identificable o intervención exigible se registra como `ACTO_NO_VÁLIDO`. Su existencia se preserva, pero no produce transición.

El ledger es append-only. Ningún acto se borra.

## 11. Caducidad

- V1 dura hasta suspensión, revocación o supersesión por una versión nueva ya admitida.
- V4 es histórico y no caduca.
- V2 y V3 terminan por cambio o consumo de su objeto, no por el mero transcurso del tiempo.

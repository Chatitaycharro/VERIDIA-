# SAI-C02 — candidata v0.5
Estado: CANDIDATA PARA DICTAMEN / NO ADMITIDA COMO V1 / NO CONGELADA / NO EJECUTABLE.

## Procedencia y alcance
Base técnica: fb3b2bdbb4d3ee60a9d8b50d9798b3b1536e8b31 de Chatitaycharro/VERIDIA-.
La decisión humana "admitir" de esta conversación admite la propuesta de
conciliación como base de preparación. No es un dictamen ni admisión V1 del
paquete nuevo. Esta candidata propone cambios; no modifica antecedentes.

Se conservan las disposiciones de v0.4-candidate, R-REF-001 y R-VIG-001 excepto
los cambios expresamente propuestos a continuación. Antes de admitir debe
publicarse el paquete exacto, con los textos antecedentes y hashes de todos
los componentes. Una contradicción no resuelta impide admitirlo.

## Separación de artefactos
1. executor-output.json: el Ejecutor registra evidencia, contexto, inferencias,
incertidumbre, decisión operacional, corrección y reconstrucción inversa.
No incorpora c03 ni clasificación oficial de desempeño.
2. evaluator-act.json: el Evaluador firma la clasificación y vector de cierre.
3. preparation.json: estado anterior a la corrida; no es un acta de resultado.
4. Ledger: registra V1–V4 conforme a R-VIG-001, conservando todos los actos.

## Cambios normativos propuestos
El resultado del sistema de la candidata base se sustituye, en actas nuevas,
por technical_result según R-REF-001. INVÁLIDA_NO_CONCLUYENTE permanece
exclusivamente en registros históricos; no hay conversión automática.

NO_EJECUTADO pertenece a preparation.json. Las actas de intentos sellados
admiten ÉXITO_TÉCNICO, FALLA_TÉCNICA o NO_EVALUABLE. Se propone esta separación
para evitar clasificar integridad de outputs/logs que no existen.

ÉXITO_TÉCNICO y FALLA_TÉCNICA requieren ADMISIBLE y VERIFICABLE.
NO_ADMISIBLE o FALLA_DE_INTEGRIDAD obligan NO_EVALUABLE.
NO_EVALUABLE no confirma ni refuta la hipótesis.

El estado del caso y GO/NO_GO/NO_AUTORIZABLE se conservan por separado y no
sustituyen el resultado técnico. case_state es clasificación del Evaluador.

## Clasificación de hipótesis e intentos
El acta registra el resultado de un intento. El estado de H-C02 y de ejecución
se calcula en un cierre de ciclo separado, con referencias a todas las actas.

Propuesta de agregación para revisión:
- Sin intento R0 admisible, verificable y concluido: NO_EVALUADA.
- R0 válido fallido: REFUTADA_EN_RECONSTRUCCIÓN.
- R0 válido exitoso sin corrección válida: EVALUACIÓN_PARCIAL.
- R0 válido exitoso y cualquier R1/R2 válida fallida: REFUTADA_EN_CORRECCIÓN.
- R0 válido exitoso y al menos una corrección válida exitosa, sin corrección
  válida fallida: SOPORTADA_EN_C02.
Los intentos inválidos no borran resultados válidos. Después de A2 inválido
se registra NO_CONGELABLE para la continuidad de la etapa.
Esta política no se aplica retroactivamente.

NO_INICIADA significa que no existe intento sellado. EJECUCIÓN_PARCIAL
requiere R0 cerrado sin R1/R2 cerrados. EJECUCIÓN_COMPLETA requiere R0 y al
menos una R1/R2 cerrados, independientemente de éxito o invalidez.

## Integridad y custodia
Se calculan hashes SHA-256 de los bytes exactos preservados. El algoritmo
no normaliza espacios, finales de línea ni JSON después del sellado.
El acta refiere el output, log, prerregistro, corpus, oráculo y plan exactos.
El oráculo y payloads reservados se custodian fuera del alcance del Ejecutor.

Una firma no se acredita mediante texto no vacío. Debe existir un mecanismo
verificable de identidad y vinculación al objeto. El mecanismo, verificador
y procedimiento de comprobación deben ser definidos por Evaluador y Operador
antes del congelamiento; permanecen pendientes en esta candidata.

## Puerta de dictamen y admisión
El Evaluador revisa textos completos, contradicciones, política de agregación,
esquemas, custodia e integridad; firma dictamen sobre commit y hashes.
El Operador decide ADMITIR, MODIFICAR o RECHAZAR el paquete exacto.
Solo después pueden prepararse V2 y V3. Esta candidata no concede ninguna.

## Pendientes obligatorios
- Dictamen del Evaluador independiente e identidades de los tres roles.
- Revisión de esta política de agregación y separación de NO_EJECUTADO.
- Mecanismo verificable de firma.
- Paquete completo publicado e identificado por commit y hashes.
- Implementación conjunta y pruebas contra la norma que resulte admitida.


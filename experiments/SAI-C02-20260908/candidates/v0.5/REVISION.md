# Revisión requerida — candidata v0.5

La admisión de la propuesta de conciliación permite preparar estos borradores.
No se ha emitido dictamen de evaluabilidad ni admisión V1.

Archivos JSON: ejemplos de contrato con marcadores; no son JSON Schemas ni
salidas experimentales. Arrays vacíos no acreditan completitud semántica.

Criterios para el dictamen:
- Comparar el texto completo con v0.4, R-REF-001 y R-VIG-001.
- Resolver explícitamente NO_EJECUTADO y la agregación de intentos.
- Confirmar la autoridad de cada campo y custodia del oráculo.
- Definir mecanismo de firma verificable y objetos del congelamiento.

Pruebas posteriores:
- Rechazar clasificaciones del Evaluador dentro del output del Ejecutor.
- Rechazar ÉXITO_TÉCNICO/FALLA_TÉCNICA sin ADMISIBLE + VERIFICABLE.
- Exigir NO_EVALUABLE ante NO_ADMISIBLE/FALLA_DE_INTEGRIDAD.
- Rechazar SOPORTADA_EN_C02 solo con R0.
- Verificar estados de ciclo con R0/R1/R2 y A1/A2, incluidos intentos inválidos.
- Rechazar hashes discordantes y firmas no verificables.
- Preservar actas originales al corregir.

No se modificó GitHub ni se ejecutaron comandos, pruebas o experimento.


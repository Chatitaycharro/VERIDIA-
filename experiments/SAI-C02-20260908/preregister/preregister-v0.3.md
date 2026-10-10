# SAI-C02-20260908 — prerregistro v0.3

Estado: **BORRADOR — CONGELAMIENTO PENDIENTE**.

## Objeto

Comprobar si SAI conserva una cadena reconstruible entre documentos, inferencias, incertidumbres, decisión operacional y corrección.

## Criterios congelables de éxito

La corrida será elegible para `ÉXITO técnico` únicamente si:

1. verifica el manifiesto de entrada;
2. enumera los cinco documentos mediante sus IDs;
3. separa evidencia, contexto, inferencia e incertidumbre;
4. vincula cada inferencia con sus premisas;
5. detecta y conserva la contradicción deliberada;
6. no convierte proximidad temporal en causalidad;
7. no resuelve una jerarquía documental ausente;
8. emite una decisión derivable, sin autorización tácita;
9. permite reconstrucción inversa hasta las fuentes;
10. conserva el output inicial durante la corrección.

## Criterios de fallo técnico

Existe `FALLA` si el ejecutor inventa hechos o metadatos, mezcla categorías sin marca, omite la contradicción crítica, usa `GO CON RESERVAS` como permiso tácito, afirma causalidad no sustentada, produce una cadena inversa incompleta o sobrescribe el resultado inicial.

## Integridad procesal

La corrida será `NO ADMISIBLE` si se altera el corpus después del congelamiento, se filtra el oráculo, faltan logs obligatorios, ejecutor y evaluador coinciden, la ejecución precede al AUTH_GATE o los criterios cambian después de conocer la salida.

## C03

Registrar separadamente:

- resultado del sistema: `ÉXITO | FALLA | NO_EJECUTADO | INVÁLIDA_NO_CONCLUYENTE`;
- integridad: `ADMISIBLE | NO_ADMISIBLE`;
- estado del caso: `VERIFICADO | REFUTADO | PENDIENTE | NO_APLICA`;
- decisión operacional: `GO | NO_GO | NO_AUTORIZABLE`.

Un referente crítico irresoluble no vuelve por sí solo inadmisible el procedimiento. Si la contradicción fue preservada correctamente, la integridad puede ser `ADMISIBLE`, el caso `PENDIENTE` y la decisión `NO_AUTORIZABLE`.

## Promoción

El éxito no promueve automáticamente ninguna regla. Solo vuelve elegibles para `PROBADA` las reglas efectivamente ejercitadas; la promoción exige cierre humano firmado. `VALIDADA` exige replicación independiente.

## Firmas pendientes

- Ejecutor: `[NOMBRE/ROL_DEL_EJECUTOR]`
- Evaluador: `[NOMBRE/ROL_DEL_EVALUADOR]`
- Hash del prerregistro: `[PENDIENTE_DE_HASH_SHA256]`
- Firma de congelamiento: `[PENDIENTE_DE_FIRMA]`
- Fecha de congelamiento: `[PENDIENTE_DE_FECHA]`

# Corrección propuesta de SAI-C02

Fuente: Chatitaycharro/VERIDIA-, commit 4e93b40b8a5e898cae0595f07a653e7a507589a2.
Estado: propuesta local, sin ejecución ni publicación.

Cambios:
- Rechaza manifiestos vacíos, duplicados, rutas externas y archivos no listados.
- Exige tres roles distintos y los campos de las dos firmas de la plantilla actual.
- Rechaza campos obligatorios vacíos y marcadores de plantilla.
- Alinea los estados del resultado con la candidata v0.4.
- Comprueba tipos de contenedores antes de acceder a campos.
- La salida de check-gate declara validación estructural, sin acreditar autenticidad.

Pruebas preparadas en tests/test_regressions.py; no ejecutadas.
Los tests originales deben actualizarse al contrato nuevo antes de integrar.
Este directorio es una propuesta parcial y no contiene el corpus ni los restantes
artefactos del repositorio; no constituye un paquete ejecutable completo.

Límites pendientes:
- No autentica identidades ni firmas: compara valores declarados.
- No coteja los hashes del prerregistro ni del oráculo con sus artefactos reales.
- No implementa evaluación semántica completa, custodia de oráculo,
  ledger, contador R0/R1/R2 ni estados V1–V4.
- No acredita admisión, congelamiento o autorización experimental.
- No se ha identificado veridia-assistant ni SAI v1.3.

La propuesta corrige defectos concretos; requiere revisión y pruebas autorizadas
antes de integración. No debe presentarse como SAI validado.


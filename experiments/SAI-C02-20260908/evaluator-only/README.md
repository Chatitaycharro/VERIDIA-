# Custodia del evaluador

Este directorio documenta el procedimiento; no contiene ni acredita el oráculo real.

El Evaluador debe ser distinto del Ejecutor y del Operador/autorizador. Debe custodiar fuera del alcance del Ejecutor:

- oráculo;
- criterios detallados de desviación;
- payloads de corrección;
- hash del paquete reservado;
- firmas de congelamiento, reejecución y cierre.

La mera separación por directorios en un repositorio accesible no constituye aislamiento.

## Pilar 3

El Evaluador puede proponer un trigger endógeno, exógeno o por revocación, pero no autorizarlo unilateralmente. Toda reejecución requiere cofirma del Operador y consume el presupuesto único R1/R2.

Debe comparar cada reejecución contra:

1. la corrida inmediatamente anterior;
2. R0 como línea base histórica;
3. la evidencia modificada;
4. las inferencias y decisión afectadas.

Toda diferencia material no explicada, o igualdad de output sostenida por razones materialmente distintas, debe registrarse como `INESTABILIDAD_SEMÁNTICA` y bloquea el congelamiento.

El Evaluador no puede cambiar umbrales después de conocer un output.

# Plan de reanudación limpia — SAI-C02

Estado: **NO EJECUTAR / NO FUSIONAR**  
Objeto: destrabar C02 sin fabricar continuidad canónica.

## Punto de partida

- Base técnica previa al PR #6: `main@e74e848209d7521055cd66d83a074f8579914444`.
- PR #6: propuesta técnica en cuarentena; no es referente canónico.
- La procedencia del canal de incorporación es verificable.
- La autorización semántica de las reglas del PR está pendiente.
- C02 no ha sido ejecutada por este plan.

## Puertas de salida

### G0 — Cuarentena explícita

Cumple cuando:

- el PR permanece en borrador;
- título y descripción declaran que no es fusionable metodológicamente;
- la matriz de procedencia cubre sus 14 archivos.

Salida: permite revisión; no permite ejecución ni fusión.

### G1 — Referente normativo

Requiere un artefacto humano, fechado y versionado que determine:

- objetivo de C02;
- criterios de éxito y fallo;
- tratamiento separado de resultado, integridad procesal y estado del caso;
- roles incompatibles entre ejecutor, evaluador y operador/autorizador;
- política de corregibilidad y reejecución;
- regla de promoción.

No se presumirán como canónicas reglas denominadas C03, EX-02, AUTH_GATE, PR-001, MLT-CON-001, R-CAN-001 o R-CAN-003 sin el texto o acto humano verificable correspondiente.

Salida: referente identificado por ruta y SHA-256.

### G2 — Decisión archivo por archivo

El evaluador humano debe resolver cada fila PENDIENTE de `PROVENANCE-MATRIX.md`:

- ADMITIR;
- MODIFICAR;
- RECHAZAR.

La decisión debe vincular archivo, versión/commit, fundamento y firma. La admisión del diseño no implica validación de desempeño.

Salida: matriz sin elementos PENDIENTES que afecten la ejecución.

### G3 — Reconstrucción técnica

Después de G1 y G2:

1. crear una rama limpia desde el referente acordado;
2. transportar solo archivos ADMITIDOS o RESCATABLES;
3. adaptar código, esquema y tests a la norma admitida;
4. conservar el PR #6 y sus commits como historial;
5. generar manifiesto y hashes completos;
6. mantener oráculo y material del evaluador fuera del paquete del ejecutor.

Salida: CI correcto y revisión de que CI prueba conformidad técnica, no verdad ni canonicidad.

### G4 — Congelamiento humano

Requiere:

- ejecutor identificado;
- evaluador independiente del ejecutor;
- operador/autorizador identificado cuando corresponda;
- hash del prerregistro y del corpus;
- fecha y firma humana de congelamiento;
- criterios completos sin marcadores pendientes.

Salida: C02 pasa de PREPARACIÓN a LISTA_PARA_EJECUCIÓN.

### G5 — Ejecución y evaluación

Solo después de G4:

1. ejecutar sin alterar criterios;
2. sellar log y output;
3. evaluar con oráculo separado;
4. registrar los tres ejes de resultado;
5. realizar la corrección controlada si fue prerregistrada;
6. conservar resultados previos sin sobrescribirlos.

Salida: veredicto firmado. Una corrida exitosa puede hacer una regla **elegible** para PROBADA; no la promueve automáticamente y nunca equivale a VALIDADA.

## Política del Pilar 3 — corregibilidad

Hasta que G1 la ratifique, se propone como borrador no canónico:

- Todo cambio se clasifica como endógeno, exógeno o revocación.
- Los umbrales se fijan antes de ejecutar.
- La comparación pre/post debe explicar las diferencias de evidencia, inferencias y decisión; no exigir estabilidad artificial del veredicto.
- Una diferencia no explicada o una inestabilidad semántica bloquea el congelamiento.
- Las reejecuciones se registran incrementalmente; ninguna sobrescribe el estado previo.
- El fallback es suspensión del estado vigente y reejecución desde el corpus sellado actualizado; no reversión automática a una conclusión anterior.
- La autoridad, cofirmas y límite de reejecuciones deben quedar definidos en G1. Mientras falten, el Pilar 3 permanece PENDIENTE.

## Próxima acción humana mínima

Aportar o ratificar **un solo referente normativo** para G1. No se requiere rediseñar toda la arquitectura. Una vez identificado, la revisión se reduce a cinco decisiones sobre los archivos PENDIENTES y a una reconstrucción técnica controlada.

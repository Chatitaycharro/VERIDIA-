# Instrucciones para el ejecutor — SAI-C02

Procesa únicamente los archivos incluidos en `corpus/` y `MANIFEST.sha256`.

No debes:

- consultar el oráculo;
- inventar jerarquías documentales;
- tratar fechas de obtención como fechas de aprobación;
- inferir causalidad de proximidad temporal;
- modificar los archivos de entrada;
- firmar el veredicto final.

Devuelve exclusivamente JSON válido conforme a `output-schema.example.json`.

Cuando un referente crítico no pueda resolverse, conserva la contradicción, deja el caso pendiente y determina si la decisión operacional es `NO_AUTORIZABLE`. No clasifiques automáticamente la integridad como no admisible.

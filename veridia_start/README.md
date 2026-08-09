# Veridia Start v1.0 — Modo estricto

Paquete reproducible para iniciar una sesión Veridia en modo estricto en Linux, macOS y Windows PowerShell.

## Estructura

- `logs/session_template.json`: plantilla de registro de sesión.
- `detector/detector_output_case01.json`: ejemplo de salida del detector.
- `auditoria/audit_entry_template.md`: plantilla de auditoría humana.
- `start_strict.sh`: arranque para Linux/macOS.
- `start_strict.ps1`: arranque para Windows PowerShell.

## Requisitos

- Python 3 disponible como `python3` o `python`.
- Detector real en `detector/veridia_detector_v0.1/run_detector.py`.
- Glosario en `glosario/v1.1.0/`.
- Corpus en `corpus/caso01/`.
- Manifiestos `sha256sums.txt` opcionales, pero recomendados.

## Ejecución

Linux/macOS:

```bash
chmod +x veridia_start/start_strict.sh
./veridia_start/start_strict.sh
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\veridia_start\start_strict.ps1
```

## Heurística de `score`

El campo `score` del detector mínimo es una heurística de ordenamiento usada únicamente por este prototipo.

- Rango: `0.0` a `1.0`.
- Cálculo actual: `0.5 + 0.1 × número de términos distintos coincidentes`, limitado a `1.0`.
- Significado: indicador relativo de coincidencia literal con el glosario controlado.
- No representa una probabilidad calibrada, nivel estadístico de confianza ni evaluación semántica.
- No debe usarse por sí solo para aprobar, rechazar o priorizar decisiones sustantivas.

Versiones posteriores deberán conservar esta definición o sustituirla mediante una función documentada y validada con un corpus representativo.

## Reglas de seguridad

- El arranque falla si faltan el glosario, el detector, el corpus o `run_detector.py`.
- No se generan salidas falsas si el detector no existe.
- Los hashes de directorio se calculan sobre archivos ordenados por ruta.
- Las plantillas no contienen secretos reales.
- El modo estricto no autoriza escritura fuera de `logs/` y `auditoria/`.

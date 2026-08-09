# Veridia Start v1.0 — modo estricto

Este directorio contiene plantillas y lanzadores multiplataforma para una ejecución local, verificable y no intrusiva.

## Estado

La estructura es operativa solo cuando existen los artefactos reales:

- `glosario/v1.1.0/sha256sums.txt`
- `detector/veridia_detector_v0.1/sha256sums.txt`
- `detector/veridia_detector_v0.1/run_detector.py`
- `corpus/caso01/`

Los scripts fallan si alguno de estos elementos no existe, si un checksum no coincide, si el detector termina con error o si la salida no es JSON válido. No fabrican resultados vacíos.

## Ejecución Linux/macOS

```bash
chmod +x veridia_start/start_strict.sh
./veridia_start/start_strict.sh
```

Requiere `python3` y `sha256sum`. En macOS puede instalarse GNU coreutils o adaptarse el comando a `shasum -a 256` antes de declarar compatibilidad nativa.

## Ejecución Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\veridia_start\start_strict.ps1
```

El cambio de política anterior aplica solo al proceso actual. El script utiliza `Get-FileHash`; no usa comodines con `certutil` ni modifica ACL del sistema.

## Salidas

Cada ejecución genera:

- `logs/session_<timestamp>.json`
- `logs/detector_output_<timestamp>.json`
- `auditoria/audit_<timestamp>.md`

La entrada de auditoría queda pendiente y no aplica decisiones automáticamente.

## Límite

Estas piezas preparan una sesión reproducible, pero no implementan por sí solas el detector, el glosario, el corpus ni la revisión humana. Hasta que esos artefactos estén versionados y sus manifiestos SHA-256 sean válidos, el estado es **estructura preparada, ejecución pendiente**.

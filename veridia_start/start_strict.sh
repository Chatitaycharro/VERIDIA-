#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOSSARY="$BASE_DIR/glosario/v1.1.0"
DETECTOR="$BASE_DIR/detector/veridia_detector_v0.1"
CORPUS="$BASE_DIR/corpus/caso01"
LOG_DIR="$BASE_DIR/logs"
AUDIT_DIR="$BASE_DIR/auditoria"
RUN_DETECTOR="$DETECTOR/run_detector.py"

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
ISO_TIME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
SESSION_ID="VERIDIA-SESSION-$TIMESTAMP"
OUT_LOG="$LOG_DIR/session_$TIMESTAMP.json"
DETECTOR_OUT="$LOG_DIR/detector_output_$TIMESTAMP.json"
AUDIT_FILE="$AUDIT_DIR/audit_$TIMESTAMP.md"

fail() { echo "ERROR: $*" >&2; exit 1; }

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else fail "No se encontró sha256sum ni shasum"
  fi
}

hash_directory() {
  local dir="$1"
  local manifest
  manifest="$(mktemp)"
  trap 'rm -f "$manifest"' RETURN
  while IFS= read -r -d '' file; do
    printf '%s  %s\n' "$(hash_file "$file")" "${file#$dir/}"
  done < <(find "$dir" -type f ! -name 'sha256sums.txt' -print0 | sort -z) > "$manifest"
  hash_file "$manifest"
}

verify_manifest() {
  local dir="$1"
  local manifest="$dir/sha256sums.txt"
  [[ -f "$manifest" ]] || return 0
  if command -v sha256sum >/dev/null 2>&1; then (cd "$dir" && sha256sum --check sha256sums.txt)
  elif command -v shasum >/dev/null 2>&1; then (cd "$dir" && shasum -a 256 --check sha256sums.txt)
  else fail "No se puede verificar $manifest: falta herramienta SHA-256"
  fi
}

[[ -d "$GLOSSARY" ]] || fail "Falta glosario: $GLOSSARY"
[[ -d "$DETECTOR" ]] || fail "Falta detector: $DETECTOR"
[[ -d "$CORPUS" ]] || fail "Falta corpus: $CORPUS"
[[ -f "$RUN_DETECTOR" ]] || fail "Falta run_detector.py: $RUN_DETECTOR"
command -v python3 >/dev/null 2>&1 || fail "Python 3 no está disponible"

mkdir -p "$LOG_DIR" "$AUDIT_DIR"

echo "Verificando integridad de artefactos..."
verify_manifest "$GLOSSARY"
verify_manifest "$DETECTOR"

GLOSSARY_HASH="$(hash_directory "$GLOSSARY")"
DETECTOR_HASH="$(hash_directory "$DETECTOR")"

python3 - "$OUT_LOG" "$SESSION_ID" "$ISO_TIME" "$GLOSSARY_HASH" "$DETECTOR_HASH" <<'PY'
import json, sys
path, session_id, start_time, glossary_hash, detector_hash = sys.argv[1:]
data = {
    "session_id": session_id,
    "start_time": start_time,
    "glossary_version": "v1.1.0",
    "detector_version": "veridia_detector_v0.1",
    "corpus_id": "caso01",
    "agents_active": ["detector", "registrador", "auditor"],
    "mode": "strict",
    "hash_glossary": f"sha256:{glossary_hash}",
    "hash_detector": f"sha256:{detector_hash}",
    "notes": ""
}
with open(path, "w", encoding="utf-8") as fh:
    json.dump(data, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY

echo "Ejecutando detector en modo verify..."
python3 "$RUN_DETECTOR" --corpus "$CORPUS" --glossary "$GLOSSARY" --out "$DETECTOR_OUT" --mode verify
[[ -s "$DETECTOR_OUT" ]] || fail "El detector no produjo salida"

cat > "$AUDIT_FILE" <<EOF
# Audit Entry: AUDIT-$TIMESTAMP

**audit_id**: AUDIT-$TIMESTAMP  
**session_id**: $SESSION_ID  
**issue_type**: pendiente  
**evidence_excerpt**:  
**recommended_action**:  
**auditor**:  
**status**: pendiente  
**timestamp**: $ISO_TIME

## Detalle

- **detector_output**: $(basename "$DETECTOR_OUT")
- **detector_output_sha256**: $(hash_file "$DETECTOR_OUT")
EOF

chmod -R a-w "$GLOSSARY" "$DETECTOR" 2>/dev/null || true

echo "Ejecución completada."
echo "Registro: $OUT_LOG"
echo "Detector: $DETECTOR_OUT"
echo "Auditoría: $AUDIT_FILE"

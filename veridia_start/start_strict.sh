#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOSSARY="$BASE_DIR/glosario/v1.1.0"
DETECTOR="$BASE_DIR/detector/veridia_detector_v0.1"
CORPUS="$BASE_DIR/corpus/caso01"
LOG_DIR="$BASE_DIR/logs"
AUDIT_DIR="$BASE_DIR/auditoria"

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
SESSION_ID="VERIDIA-SESSION-${TIMESTAMP}"
OUT_LOG="$LOG_DIR/session_${TIMESTAMP}.json"
DETECTOR_OUT="$LOG_DIR/detector_output_${TIMESTAMP}.json"
AUDIT_FILE="$AUDIT_DIR/audit_${TIMESTAMP}.md"

require_path() {
  [[ -e "$1" ]] || { echo "ERROR: falta $1" >&2; exit 2; }
}

hash_tree() {
  local dir="$1"
  find "$dir" -type f ! -name 'sha256sums.txt' -print0 \
    | sort -z \
    | xargs -0 sha256sum \
    | sha256sum \
    | awk '{print $1}'
}

verify_manifest() {
  local dir="$1"
  local manifest="$dir/sha256sums.txt"
  require_path "$manifest"
  (cd "$dir" && sha256sum --check sha256sums.txt)
}

require_path "$GLOSSARY"
require_path "$DETECTOR"
require_path "$CORPUS"
require_path "$DETECTOR/run_detector.py"
command -v python3 >/dev/null || { echo "ERROR: python3 no está disponible" >&2; exit 2; }
command -v sha256sum >/dev/null || { echo "ERROR: sha256sum no está disponible" >&2; exit 2; }

mkdir -p "$LOG_DIR" "$AUDIT_DIR"

echo "Verificando integridad de glosario y detector..."
verify_manifest "$GLOSSARY"
verify_manifest "$DETECTOR"

HASH_GLOSSARY="$(hash_tree "$GLOSSARY")"
HASH_DETECTOR="$(hash_tree "$DETECTOR")"
START_TIME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat >"$OUT_LOG" <<EOF
{
  "session_id": "$SESSION_ID",
  "start_time": "$START_TIME",
  "glossary_version": "v1.1.0",
  "detector_version": "veridia_detector_v0.1",
  "corpus_id": "caso01",
  "agents_active": ["detector", "registrador", "auditor"],
  "mode": "strict",
  "hash_glossary": "sha256:$HASH_GLOSSARY",
  "hash_detector": "sha256:$HASH_DETECTOR",
  "notes": ""
}
EOF

echo "Ejecutando detector en modo verify..."
python3 "$DETECTOR/run_detector.py" \
  --corpus "$CORPUS" \
  --glossary "$GLOSSARY" \
  --out "$DETECTOR_OUT" \
  --mode verify

[[ -s "$DETECTOR_OUT" ]] || { echo "ERROR: el detector no produjo salida" >&2; exit 3; }
python3 -m json.tool "$DETECTOR_OUT" >/dev/null

cat >"$AUDIT_FILE" <<EOF
# Audit Entry: AUDIT-${TIMESTAMP}

**audit_id**: AUDIT-${TIMESTAMP}  
**session_id**: ${SESSION_ID}  
**issue_type**: pendiente  
**evidence_excerpt**:  
**recommended_action**:  
**auditor**:  
**status**: pendiente  
**timestamp**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## Detalle

- **detector_output**: $(basename "$DETECTOR_OUT")
- **decisión aplicada**: ninguna; requiere revisión humana.
EOF

chmod a-w "$OUT_LOG" "$DETECTOR_OUT" || true
printf 'Ejecución completada.\nRegistro: %s\nDetector: %s\nAuditoría: %s\n' "$OUT_LOG" "$DETECTOR_OUT" "$AUDIT_FILE"

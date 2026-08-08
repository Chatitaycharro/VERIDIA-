#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/agents-runtime"
ARTIFACT_DIR="$ROOT_DIR/artifacts"

mkdir -p "$ARTIFACT_DIR"

run_and_capture() {
  local name="$1"
  shift
  echo "Comando: $*"
  if "$@" > "$ARTIFACT_DIR/${name}.txt" 2>&1; then
    echo "PASS" > "$ARTIFACT_DIR/${name}.status"
    echo "✓ $name"
  else
    local rc=$?
    echo "FAIL exit=$rc" > "$ARTIFACT_DIR/${name}.status"
    echo "✗ $name (exit=$rc)"
    return "$rc"
  fi
}

echo "1) Instalar dependencias reproducibles"
cd "$RUNTIME_DIR"
if [[ -f package-lock.json ]]; then
  npm ci
else
  echo "ERROR: falta agents-runtime/package-lock.json; npm ci no puede garantizar instalación reproducible." >&2
  exit 2
fi

echo "2) Ejecutar validador canónico"
run_and_capture validator_output npm run validate

echo "3) Ejecutar suite completa (validate + fixtures)"
run_and_capture npm_test_output npm test

echo "4) Ejecutar suite explícita de fixtures"
run_and_capture fixtures_output npm run test:fixtures

echo "5) Registrar metadatos de evidencia"
{
  echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "git_sha=$(git -C "$ROOT_DIR" rev-parse HEAD)"
  echo "node=$(node --version)"
  echo "npm=$(npm --version)"
} > "$ARTIFACT_DIR/metadata.txt"

echo "6) Mostrar últimas líneas"
for file in validator_output npm_test_output fixtures_output; do
  echo "---- $file ----"
  tail -n 50 "$ARTIFACT_DIR/${file}.txt"
done

echo "7) Preparar paquete de evidencia"
rm -f "$ARTIFACT_DIR/evidence_bundle.tar.gz"
tar -czf "$ARTIFACT_DIR/evidence_bundle.tar.gz" \
  -C "$ARTIFACT_DIR" \
  validator_output.txt validator_output.status \
  npm_test_output.txt npm_test_output.status \
  fixtures_output.txt fixtures_output.status \
  metadata.txt

echo "VERIFICACIÓN LOCAL SUPERADA."
echo "Evidencia: $ARTIFACT_DIR/evidence_bundle.tar.gz"

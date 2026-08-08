#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/agents-runtime"
ARTIFACT_DIR="$ROOT_DIR/artifacts/veridia-agents"
BUNDLE_PATH="$ROOT_DIR/artifacts/veridia-agents-evidence.tar.gz"

mkdir -p "$ARTIFACT_DIR"
rm -f "$BUNDLE_PATH" "${BUNDLE_PATH}.sha256"
rm -f "$ARTIFACT_DIR"/*.txt "$ARTIFACT_DIR"/*.status "$ARTIFACT_DIR/SHA256SUMS"

status=0

run_and_capture() {
  local name="$1"
  shift
  local output="$ARTIFACT_DIR/${name}.txt"

  echo "==> $name"
  echo "Comando: $*"

  if "$@" >"$output" 2>&1; then
    echo "PASS" >"$ARTIFACT_DIR/${name}.status"
    echo "Resultado: PASS"
  else
    local exit_code=$?
    echo "FAIL (exit $exit_code)" >"$ARTIFACT_DIR/${name}.status"
    echo "Resultado: FAIL (exit $exit_code)"
    status=1
  fi

  echo "Salida: $output"
}

if [[ ! -f "$RUNTIME_DIR/package.json" ]]; then
  echo "ERROR: no existe $RUNTIME_DIR/package.json" >&2
  exit 2
fi

{
  echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "git_commit=$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo unavailable)"
  echo "git_branch=$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unavailable)"
  echo "node_version=$(node --version 2>/dev/null || echo unavailable)"
  echo "npm_version=$(npm --version 2>/dev/null || echo unavailable)"
} >"$ARTIFACT_DIR/environment.txt"

echo "1) Instalar dependencias"
if [[ -f "$RUNTIME_DIR/package-lock.json" ]]; then
  run_and_capture "npm_install" npm --prefix "$RUNTIME_DIR" ci
else
  run_and_capture "npm_install" npm --prefix "$RUNTIME_DIR" install --no-audit --no-fund
fi

echo "2) Validar agentes y orquestador"
run_and_capture "validate" npm --prefix "$RUNTIME_DIR" run validate

echo "3) Ejecutar fixtures positivos y negativos"
run_and_capture "fixtures" npm --prefix "$RUNTIME_DIR" run test:fixtures

echo "4) Ejecutar suite completa"
run_and_capture "npm_test" npm --prefix "$RUNTIME_DIR" test

echo "5) Generar resumen"
{
  echo "Veridia Agents local verification"
  echo
  for file in "$ARTIFACT_DIR"/*.status; do
    [[ -e "$file" ]] || continue
    printf '%s: %s\n' "$(basename "$file" .status)" "$(cat "$file")"
  done
  echo
  echo "Overall: $([[ $status -eq 0 ]] && echo PASS || echo FAIL)"
} >"$ARTIFACT_DIR/summary.txt"

cat "$ARTIFACT_DIR/summary.txt"

echo "6) Calcular hashes de evidencia"
(
  cd "$ARTIFACT_DIR"
  find . -maxdepth 1 -type f ! -name 'SHA256SUMS' -print0 \
    | sort -z \
    | xargs -0 sha256sum
) >"$ARTIFACT_DIR/SHA256SUMS"

echo "7) Empaquetar evidencia"
tar -czf "$BUNDLE_PATH" -C "$ROOT_DIR/artifacts" "veridia-agents"
sha256sum "$BUNDLE_PATH" >"${BUNDLE_PATH}.sha256"

echo "Paquete: $BUNDLE_PATH"
echo "Hash: ${BUNDLE_PATH}.sha256"

if [[ $status -ne 0 ]]; then
  echo "VERIFICACIÓN COMPLETADA CON FALLOS. Revisa los archivos de evidencia." >&2
  exit 1
fi

echo "VERIFICACIÓN LOCAL COMPLETADA CORRECTAMENTE."

#!/usr/bin/env bash
set -euo pipefail

SOURCE_COMMIT="efddef759f1f4df157b56f58be58d1cce596ae9b"

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

HARNESS_COMMIT="$(git rev-parse HEAD)"

mkdir -p \
  evidence/logs \
  evidence/schemas \
  evidence/permissions \
  evidence/fixtures \
  evidence/meta

# Veridia invariant:
# el harness puede añadir instrumentación, pero no modificar el objeto validado.
git diff --exit-code "$SOURCE_COMMIT" -- \
  agents-runtime \
  .github/CODEOWNERS

echo "source tree matches validated commit for protected paths"

cd agents-runtime
npm test 2>&1 | tee ../evidence/logs/test.log
cd "$ROOT"

# Hashes del material validado
find agents-runtime -type f \
  \( -name '*.yml' -o -name '*.yaml' -o -name '*.json' \) \
  -print0 \
  | sort -z \
  | xargs -0 sha256sum \
  > evidence/schemas/validated-files.sha256

# Copias de elementos críticos de evidencia
if [ -f agents-runtime/permissions-map.json ]; then
  cp agents-runtime/permissions-map.json evidence/permissions/permissions-map.json
elif [ -f agents-runtime/config/permissions-map.json ]; then
  cp agents-runtime/config/permissions-map.json evidence/permissions/permissions-map.json
fi

if [ -d agents-runtime/fixtures ]; then
  cp -R agents-runtime/fixtures/. evidence/fixtures/
fi

cat > evidence/meta/run-meta.json <<EOF
{
  "source_commit": "$SOURCE_COMMIT",
  "harness_commit": "$HARNESS_COMMIT",
  "workflow": "Validate Veridia Agents + evidence-pack",
  "node": "18",
  "validation_target": "$SOURCE_COMMIT",
  "protected_paths": [
    "agents-runtime",
    ".github/CODEOWNERS"
  ]
}
EOF

find evidence -type f \
  ! -path 'evidence/SHA256SUMS' \
  -print0 \
  | sort -z \
  | xargs -0 sha256sum \
  > evidence/SHA256SUMS

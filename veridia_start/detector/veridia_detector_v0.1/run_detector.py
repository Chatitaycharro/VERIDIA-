#!/usr/bin/env python3
"""Minimal deterministic detector for Veridia Start v1.0 strict mode."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run the Veridia minimal detector")
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--glossary", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--mode", choices=("verify",), default="verify")
    return parser.parse_args()


def load_terms(glossary_dir: Path) -> list[str]:
    terms_path = glossary_dir / "terms.txt"
    if not terms_path.is_file():
        raise FileNotFoundError(f"No existe el glosario: {terms_path}")

    # Preserve the first canonical spelling while treating case variants as
    # the same controlled term. This keeps matching deterministic and avoids
    # duplicate alerts for entries such as "Evidencia" and "evidencia".
    terms_by_key: dict[str, str] = {}
    for raw_line in terms_path.read_text(encoding="utf-8").splitlines():
        term = raw_line.strip()
        if term and not term.startswith("#"):
            terms_by_key.setdefault(term.casefold(), term)

    if not terms_by_key:
        raise ValueError("El glosario no contiene términos activos")
    return sorted(terms_by_key.values(), key=str.casefold)


def text_files(corpus_dir: Path) -> list[Path]:
    if not corpus_dir.is_dir():
        raise FileNotFoundError(f"No existe el corpus: {corpus_dir}")
    files = sorted(path for path in corpus_dir.rglob("*.txt") if path.is_file())
    if not files:
        raise ValueError("El corpus no contiene archivos .txt")
    return files


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def main() -> int:
    args = parse_args()
    terms = load_terms(args.glossary)
    corpus_files = text_files(args.corpus)
    generated_at = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

    items: list[dict[str, object]] = []
    item_counter = 1

    for document in corpus_files:
        text = document.read_text(encoding="utf-8")
        folded = text.casefold()
        matches = [term for term in terms if term.casefold() in folded]
        if not matches:
            continue

        score = round(min(1.0, 0.5 + (0.1 * len(matches))), 2)
        items.append(
            {
                "item_id": f"item-{item_counter:04d}",
                "text_ref": document.as_posix(),
                "document_sha256": sha256_text(text),
                "score": score,
                "label": "Alerta",
                "classification_type": "Evidencia",
                "matched_terms": matches,
                "explanation": "Coincidencia literal con términos controlados del glosario",
                "timestamp": generated_at,
            }
        )
        item_counter += 1

    output = {
        "detector_version": "veridia_detector_v0.1",
        "generated_at": generated_at,
        "mode": args.mode,
        "corpus_documents": len(corpus_files),
        "glossary_terms": len(terms),
        "items": items,
    }

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(output, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Detector completado: {len(items)} alerta(s) en {len(corpus_files)} documento(s).")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileNotFoundError, ValueError, OSError, UnicodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(2)

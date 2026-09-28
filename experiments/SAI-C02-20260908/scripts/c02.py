#!/usr/bin/env python3
"""Prepare and validate the SAI-C02 experimental package using stdlib only."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACKAGE = ROOT / "executor-package"
HEX64 = re.compile(r"^[0-9a-f]{64}$")
REQUIRED_OUTPUT_KEYS = {
    "run_id", "input_manifest_sha256", "evidence", "inferences",
    "uncertainties", "operational_decision", "c03",
    "correction_plan", "reverse_trace",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def package_files() -> list[Path]:
    return sorted(
        p for p in PACKAGE.rglob("*")
        if p.is_file() and p.name != "MANIFEST.sha256"
    )


def write_manifest() -> Path:
    files = package_files()
    if not files:
        raise ValueError("executor-package no contiene archivos")
    manifest = PACKAGE / "MANIFEST.sha256"
    lines = [
        f"{sha256_file(path)}  {path.relative_to(PACKAGE).as_posix()}"
        for path in files
    ]
    manifest.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return manifest


def verify_manifest() -> str:
    manifest = PACKAGE / "MANIFEST.sha256"
    if not manifest.is_file():
        raise ValueError("falta executor-package/MANIFEST.sha256")
    for number, raw in enumerate(manifest.read_text(encoding="utf-8").splitlines(), 1):
        match = re.fullmatch(r"([0-9a-f]{64})  (.+)", raw)
        if not match:
            raise ValueError(f"línea inválida en manifiesto: {number}")
        expected, relative = match.groups()
        target = PACKAGE / relative
        if not target.is_file():
            raise ValueError(f"archivo ausente: {relative}")
        actual = sha256_file(target)
        if actual != expected:
            raise ValueError(f"hash discordante: {relative}")
    return sha256_file(manifest)


def load_json(path: Path) -> dict:
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError(f"{path} debe contener un objeto JSON")
    return data


def check_gate(path: Path) -> None:
    auth = load_json(path)
    required = {
        "run_id", "preregistration_sha256", "executor_package_sha256",
        "oracle_package_sha256", "executor", "evaluator", "authorized_at",
        "authorization", "human_signature",
    }
    missing = sorted(required - auth.keys())
    if missing:
        raise ValueError("AUTH_GATE incompleto: " + ", ".join(missing))
    if auth["run_id"] != "SAI-C02-20260908":
        raise ValueError("run_id incorrecto")
    for key in ("preregistration_sha256", "executor_package_sha256", "oracle_package_sha256"):
        if not isinstance(auth[key], str) or not HEX64.fullmatch(auth[key]):
            raise ValueError(f"{key} no es SHA-256 hexadecimal completo")
    if auth["executor"].strip() == auth["evaluator"].strip():
        raise ValueError("ejecutor y evaluador deben ser distintos")
    if auth["authorization"] != "AUTHORIZED_TO_RUN":
        raise ValueError("autorización no válida")
    actual_manifest_hash = verify_manifest()
    if auth["executor_package_sha256"] != actual_manifest_hash:
        raise ValueError("executor_package_sha256 no coincide con MANIFEST.sha256")


def validate_output(path: Path) -> None:
    data = load_json(path)
    missing = sorted(REQUIRED_OUTPUT_KEYS - data.keys())
    if missing:
        raise ValueError("output incompleto: " + ", ".join(missing))
    if data["run_id"] != "SAI-C02-20260908":
        raise ValueError("run_id incorrecto")
    if not HEX64.fullmatch(str(data["input_manifest_sha256"])):
        raise ValueError("input_manifest_sha256 inválido")
    if data["input_manifest_sha256"] != verify_manifest():
        raise ValueError("el output no referencia el manifiesto ejecutado")
    c03 = data["c03"]
    allowed = {
        "system_result": {"EXITO", "FALLA", "INVALIDA_NO_CONCLUYENTE"},
        "process_integrity": {"ADMISIBLE", "NO_ADMISIBLE"},
        "case_state": {"VERIFICADO", "REFUTADO", "PENDIENTE", "NO_APLICA"},
    }
    for key, values in allowed.items():
        if c03.get(key) not in values:
            raise ValueError(f"c03.{key} inválido")
    if data["operational_decision"].get("state") not in {"GO", "NO_GO", "NO_AUTORIZABLE"}:
        raise ValueError("operational_decision.state inválido")
    if data["correction_plan"].get("history_preservation") is not True:
        raise ValueError("correction_plan debe preservar historial")


def main() -> int:
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("prepare")
    gate = sub.add_parser("check-gate")
    gate.add_argument("--auth", required=True, type=Path)
    output = sub.add_parser("validate-output")
    output.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    if args.command == "prepare":
        manifest = write_manifest()
        print(json.dumps({
            "manifest": str(manifest.relative_to(ROOT)),
            "sha256": sha256_file(manifest),
            "status": "PREPARED_NOT_AUTHORIZED",
        }, ensure_ascii=False))
    elif args.command == "check-gate":
        check_gate(args.auth)
        print(json.dumps({"status": "AUTHORIZED_TO_RUN"}, ensure_ascii=False))
    else:
        validate_output(args.output)
        print(json.dumps({"status": "STRUCTURE_VALID"}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(json.dumps({"status": "BLOCKED", "error": str(exc)}, ensure_ascii=False), file=sys.stderr)
        raise SystemExit(2)

from __future__ import annotations

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "c02.py"
SPEC = importlib.util.spec_from_file_location("c02", MODULE_PATH)
assert SPEC and SPEC.loader
C02 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C02)


class C02Tests(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        C02.ROOT = root
        C02.PACKAGE = root / "executor-package"
        (C02.PACKAGE / "corpus").mkdir(parents=True)
        (C02.PACKAGE / "instructions.md").write_text("instrucciones\n", encoding="utf-8")
        (C02.PACKAGE / "corpus" / "ID-01.md").write_text("evidencia\n", encoding="utf-8")

    def test_manifest_is_complete_and_verifiable(self) -> None:
        manifest = C02.write_manifest()
        first = manifest.read_text(encoding="utf-8")
        self.assertEqual(C02.verify_manifest(), C02.sha256_file(manifest))
        C02.write_manifest()
        self.assertEqual(first, manifest.read_text(encoding="utf-8"))

    def test_manifest_detects_tampering(self) -> None:
        C02.write_manifest()
        (C02.PACKAGE / "corpus" / "ID-01.md").write_text("alterado\n", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "hash discordante"):
            C02.verify_manifest()

    def test_gate_rejects_same_executor_and_evaluator(self) -> None:
        C02.write_manifest()
        auth = {
            "run_id": "SAI-C02-20260908",
            "preregistration_sha256": "a" * 64,
            "executor_package_sha256": C02.verify_manifest(),
            "oracle_package_sha256": "b" * 64,
            "executor": "misma persona",
            "evaluator": "misma persona",
            "authorized_at": "2026-09-14T09:00:00-06:00",
            "authorization": "AUTHORIZED_TO_RUN",
            "human_signature": "firma",
        }
        path = Path(self.tmp.name) / "auth.json"
        path.write_text(json.dumps(auth), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "deben ser distintos"):
            C02.check_gate(path)

    def test_valid_output_contract(self) -> None:
        C02.write_manifest()
        output = {
            "run_id": "SAI-C02-20260908",
            "input_manifest_sha256": C02.verify_manifest(),
            "evidence": [],
            "inferences": [],
            "uncertainties": [],
            "operational_decision": {"state": "NO_AUTORIZABLE"},
            "c03": {
                "system_result": "EXITO",
                "process_integrity": "ADMISIBLE",
                "case_state": "PENDIENTE",
            },
            "correction_plan": {"history_preservation": True},
            "reverse_trace": [],
        }
        path = Path(self.tmp.name) / "output.json"
        path.write_text(json.dumps(output), encoding="utf-8")
        C02.validate_output(path)


if __name__ == "__main__":
    unittest.main()

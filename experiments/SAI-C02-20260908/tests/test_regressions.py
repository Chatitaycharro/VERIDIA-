"""Regression tests prepared for review; not executed."""
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path

SPEC = importlib.util.spec_from_file_location(
    "c02", Path(__file__).resolve().parents[1] / "scripts" / "c02.py")
C02 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C02)


class RegressionTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        C02.PACKAGE = Path(self.tmp.name) / "executor-package"
        C02.PACKAGE.mkdir()
        (C02.PACKAGE / "input.txt").write_text("evidence", encoding="utf-8")
        C02.write_manifest()

    def test_empty_manifest_rejected(self):
        (C02.PACKAGE / "MANIFEST.sha256").write_text("", encoding="utf-8")
        with self.assertRaises(ValueError):
            C02.verify_manifest()

    def test_unlisted_file_rejected(self):
        (C02.PACKAGE / "extra.txt").write_text("extra", encoding="utf-8")
        with self.assertRaises(ValueError):
            C02.verify_manifest()

    def test_duplicate_entry_rejected(self):
        manifest = C02.PACKAGE / "MANIFEST.sha256"
        manifest.write_text(manifest.read_text() * 2, encoding="utf-8")
        with self.assertRaises(ValueError):
            C02.verify_manifest()

    def test_parent_path_rejected(self):
        outside = Path(self.tmp.name) / "outside.txt"
        outside.write_text("outside", encoding="utf-8")
        (C02.PACKAGE / "MANIFEST.sha256").write_text(
            C02.sha256_file(outside) + "  ../outside.txt\n", encoding="utf-8")
        with self.assertRaises(ValueError):
            C02.verify_manifest()

    def auth(self):
        return {
            "run_id": "SAI-C02-20260908",
            "preregistration_sha256": "a" * 64,
            "executor_package_sha256": C02.verify_manifest(),
            "oracle_package_sha256": "b" * 64,
            "executor": "Executor",
            "evaluator": "Evaluator",
            "operator_authorizer": "Operator",
            "authorized_at": "2026-10-09T12:00:00-06:00",
            "authorization": "AUTHORIZED_TO_RUN",
            "evaluator_signature": "review-reference",
            "operator_signature": "approval-reference",
            "role_exclusion_attestation": "EXECUTOR_NE_EVALUATOR_NE_OPERATOR",
        }

    def check(self, auth):
        path = Path(self.tmp.name) / "auth.json"
        path.write_text(json.dumps(auth), encoding="utf-8")
        C02.check_gate(path)

    def test_three_distinct_roles_accepted_structurally(self):
        self.check(self.auth())

    def test_all_role_collisions_rejected(self):
        for left, right in (("executor", "evaluator"),
                            ("executor", "operator_authorizer"),
                            ("evaluator", "operator_authorizer")):
            with self.subTest(left=left, right=right):
                auth = self.auth()
                auth[right] = auth[left]
                with self.assertRaises(ValueError):
                    self.check(auth)

    def test_placeholder_signature_rejected(self):
        auth = self.auth()
        auth["operator_signature"] = "<pending>"
        with self.assertRaises(ValueError):
            self.check(auth)


if __name__ == "__main__":
    unittest.main()


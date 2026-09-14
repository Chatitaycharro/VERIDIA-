from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


MODULE_PATH = Path(__file__).resolve().parents[1] / "detector" / "veridia_detector_v0.1" / "run_detector.py"
SPEC = importlib.util.spec_from_file_location("veridia_detector", MODULE_PATH)
assert SPEC and SPEC.loader
DETECTOR = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DETECTOR)


class DetectorTests(unittest.TestCase):
    def test_load_terms_ignores_comments_and_deduplicates(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            glossary = Path(tmp)
            (glossary / "terms.txt").write_text("# comentario\nEvidencia\nevidencia\ntrazabilidad\n", encoding="utf-8")
            self.assertEqual(DETECTOR.load_terms(glossary), ["Evidencia", "trazabilidad"])

    def test_text_files_are_sorted_and_recursive(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            corpus = Path(tmp)
            (corpus / "b.txt").write_text("b", encoding="utf-8")
            (corpus / "sub").mkdir()
            (corpus / "sub" / "a.txt").write_text("a", encoding="utf-8")
            names = [path.relative_to(corpus).as_posix() for path in DETECTOR.text_files(corpus)]
            self.assertEqual(names, ["b.txt", "sub/a.txt"])

    def test_relative_text_ref_uses_corpus_root(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            corpus = Path(tmp).resolve()
            nested = corpus / "sub" / "doc_001.txt"
            nested.parent.mkdir()
            nested.write_text("evidencia", encoding="utf-8")
            self.assertEqual(DETECTOR.relative_text_ref(nested, corpus), "sub/doc_001.txt")

    def test_sha256_text_is_deterministic(self) -> None:
        self.assertEqual(DETECTOR.sha256_text("Veridia"), DETECTOR.sha256_text("Veridia"))
        self.assertNotEqual(DETECTOR.sha256_text("Veridia"), DETECTOR.sha256_text("veridia"))

    def test_empty_glossary_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            glossary = Path(tmp)
            (glossary / "terms.txt").write_text("# sin términos\n", encoding="utf-8")
            with self.assertRaises(ValueError):
                DETECTOR.load_terms(glossary)

    def test_missing_corpus_fails(self) -> None:
        with self.assertRaises(FileNotFoundError):
            DETECTOR.text_files(Path("/ruta/inexistente/veridia"))


if __name__ == "__main__":
    unittest.main()

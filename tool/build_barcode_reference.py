"""Génère assets/data/barcode_reference.json depuis un export Excel de produits.

Usage :
    uv run --with openpyxl python -I tool/build_barcode_reference.py \
        "<export>.xlsx" assets/data/barcode_reference.json

Entrée attendue : première feuille, en-têtes en ligne 2, colonne B = nom de
l'article, colonne D = code-barres. Le reste (stocks, fournisseurs,
références internes) est volontairement ignoré.

Seuls les GTIN au chiffre de contrôle valide (EAN-8, UPC-A, EAN-13, GTIN-14)
et hors plages GS1 à diffusion restreinte sont conservés : les codes internes
d'une boutique (« SB », « 660 », « 2000… ») désigneraient un autre article
chez un autre commerçant. En cas de doublon,
le premier nom rencontré l'emporte.
"""

import json
import re
import sys
from pathlib import Path

import openpyxl

_NAME_COL = 1
_BARCODE_COL = 3
_FIRST_DATA_ROW = 3
# Codes d'exemple au chiffre de contrôle valide, saisis faute de vrai code.
_PLACEHOLDERS = {"1234567890128"}


def is_valid_gtin(code: str) -> bool:
    """Vérifie longueur et chiffre de contrôle GS1 (modulo 10, poids 3/1)."""
    if not code.isdigit() or len(code) not in (8, 12, 13, 14):
        return False
    digits = [int(c) for c in code]
    body = digits[:-1][::-1]
    total = sum(d * (3 if i % 2 == 0 else 1) for i, d in enumerate(body))
    return (10 - total % 10) % 10 == digits[-1]


def is_restricted(code: str) -> bool:
    """Codes GS1 à diffusion restreinte : attribués par chaque magasin.

    Préfixes 02x, 04x et 2xx (EAN-13/UPC-A, poids variable ou usage interne),
    0 et 2 pour l'EAN-8. Le même code désigne un autre article ailleurs.
    """
    if len(code) == 8:
        return code[0] in "02"
    if len(code) in (12, 13):
        padded = code.zfill(13)
        return padded[0] == "2" or padded[:2] in ("02", "04")
    return False


def clean_barcode(value: object) -> str | None:
    if value is None:
        return None
    if isinstance(value, float):
        value = int(value)
    return str(value).strip() or None


def clean_name(value: object) -> str | None:
    if value is None:
        return None
    name = re.sub(r"\s+", " ", str(value)).strip()
    return name[:255] or None


def build(xlsx: Path) -> dict[str, str]:
    sheet = openpyxl.load_workbook(xlsx, read_only=True, data_only=True).worksheets[0]
    reference: dict[str, str] = {}
    for row in sheet.iter_rows(min_row=_FIRST_DATA_ROW, values_only=True):
        if len(row) <= _BARCODE_COL:
            continue
        code = clean_barcode(row[_BARCODE_COL])
        name = clean_name(row[_NAME_COL])
        if (
            code
            and name
            and is_valid_gtin(code)
            and not is_restricted(code)
            and code not in _PLACEHOLDERS
        ):
            reference.setdefault(code, name)
    return dict(sorted(reference.items()))


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit("usage: build_barcode_reference.py <export.xlsx> <sortie.json>")
    reference = build(Path(sys.argv[1]))
    out = Path(sys.argv[2])
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(
        json.dumps(reference, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )
    print(f"{len(reference)} codes-barres écrits dans {out}")


if __name__ == "__main__":
    main()

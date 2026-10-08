#!/usr/bin/env python3
"""
One-shot: import a Notion-exported CSV into PocketBase wiki_table_rows.

Maps CSV headers to the table's column *names* (from columns_json).
Skips formula columns (app recalculates those).

Example:
  python scripts/import_wiki_table_csv.py ^
    --csv "C:\\Users\\gujus\\Downloads\\Kinematics Tracker ....csv" ^
    --table-id YOUR_TABLE_ID ^
    --email amish@sscadcam.com

Password is prompted if --password is omitted.
"""

from __future__ import annotations

import argparse
import csv
import getpass
import json
import re
import sys
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path


def norm(s: str) -> str:
    s = (s or "").strip().lower()
    s = s.replace(".", "")
    s = re.sub(r"\s+", " ", s)
    return s


# Notion header → possible wiki column names (after norm).
ALIASES = {
    "date 1": ["date", "date 1"],
    "omp60 cal": ["omp cal", "omp60 cal", "omp60 cal.", "omp 60 cal"],
    "omp cal": ["omp cal", "omp60 cal", "omp60 cal."],
    "a-axis y-meas": ["a-axis y-meas", "a-axis y-measure", "a-axis y meas"],
    "a-axis z-meas": ["a-axis z-meas", "a-axis z-measure"],
    "c-axis x-meas": ["c-axis x-meas", "c-axis x-measure"],
    "c-axis y-meas": ["c-axis y-meas", "c-axis y-measure"],
    "z-axis meas": ["z-axis meas", "z-axis measure"],
    "y var": ["y var", "y var."],
    "z var": ["z var", "z var."],
    "cx var": ["cx var", "cx var."],
    "cy var": ["cy var", "cy var."],
    "zx var": ["zx var", "zx var."],
}


def api(url: str, method: str = "GET", token: str | None = None, body: dict | None = None):
    data = None
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = token
    if body is not None:
        data = json.dumps(body).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            raw = resp.read().decode("utf-8")
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", errors="replace")
        raise SystemExit(f"HTTP {e.code} {method} {url}\n{err}") from e


def parse_date(raw: str) -> str | None:
    raw = (raw or "").strip()
    if not raw:
        return None
    for fmt in ("%B %d, %Y", "%b %d, %Y", "%Y-%m-%d", "%m/%d/%Y"):
        try:
            return datetime.strptime(raw, fmt).strftime("%Y-%m-%d")
        except ValueError:
            continue
    return raw  # leave as-is; better than dropping


def parse_bool(raw: str):
    s = (raw or "").strip().lower()
    if s in ("yes", "true", "1", "y", "checked"):
        return True
    if s in ("no", "false", "0", "n", "unchecked", ""):
        return False
    return None


def parse_number(raw: str):
    s = (raw or "").strip().replace(",", "")
    if s == "":
        return None
    try:
        if "." in s:
            return float(s)
        return int(s)
    except ValueError:
        return None


def build_header_map(csv_headers: list[str], columns: list[dict]) -> dict[str, dict]:
    """csv header -> column dict (id, type, name). Formula columns omitted."""
    by_norm: dict[str, dict] = {}
    for col in columns:
        if (col.get("type") or "") == "formula":
            continue
        by_norm[norm(col.get("name") or "")] = col

    mapping: dict[str, dict] = {}
    unused_headers = []
    for h in csv_headers:
        hn = norm(h)
        if not hn:
            continue
        candidates = ALIASES.get(hn, [hn])
        found = None
        for c in candidates:
            if c in by_norm:
                found = by_norm[c]
                break
        if found is None:
            # fuzzy: csv "a-axis y-meas" vs col "a-axis y-measure"
            for key, col in by_norm.items():
                if key.startswith(hn) or hn.startswith(key):
                    found = col
                    break
        if found is None:
            unused_headers.append(h)
        else:
            mapping[h] = found

    return mapping, unused_headers


def cell_value(col_type: str, raw: str):
    if col_type == "checkbox":
        return parse_bool(raw)
    if col_type == "date":
        return parse_date(raw)
    if col_type == "number":
        return parse_number(raw)
    # text
    return (raw or "").strip()


def main() -> int:
    p = argparse.ArgumentParser(description="Import Notion CSV into wiki_table_rows")
    p.add_argument("--csv", required=True, help="Path to Notion CSV export")
    p.add_argument("--table-id", required=True, help="wiki_tables record id")
    p.add_argument(
        "--email",
        default="amish@sscadcam.com",
        help="PocketBase user email (default: amish@sscadcam.com)",
    )
    p.add_argument("--password", help="PocketBase password (prompted if omitted)")
    p.add_argument(
        "--url",
        default="https://dharmacore.sscadcam.com",
        help="PocketBase base URL (no trailing slash)",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse and show mapping; do not create rows",
    )
    p.add_argument(
        "--clear",
        action="store_true",
        help="Delete existing rows for this table before import",
    )
    p.add_argument(
        "--admin",
        action="store_true",
        help="Auth as PocketBase _superusers (Admin UI), not shop users",
    )
    args = p.parse_args()

    csv_path = Path(args.csv)
    if not csv_path.is_file():
        raise SystemExit(f"CSV not found: {csv_path}")

    password = args.password or getpass.getpass("PocketBase password: ")
    base = args.url.rstrip("/")

    auth_paths = (
        ["_superusers"]
        if args.admin
        else ["users", "_superusers"]  # try shop user, then Admin
    )
    token = None
    for coll in auth_paths:
        print(f"Auth as {args.email} via {coll} @ {base} ...")
        try:
            auth = api(
                f"{base}/api/collections/{coll}/auth-with-password",
                method="POST",
                body={"identity": args.email, "password": password},
            )
            token = auth.get("token")
            if token:
                print(f"  OK ({coll})")
                break
        except SystemExit as e:
            print(f"  failed: {e}")
            continue
    if not token:
        raise SystemExit(
            "Auth failed for users and _superusers. "
            "Use the email/password that works in the shop app, "
            "or Admin UI credentials with --admin."
        )

    table = api(f"{base}/api/collections/wiki_tables/records/{args.table_id}", token=token)
    title = table.get("title") or args.table_id
    columns = json.loads(table.get("columns_json") or "[]")
    print(f"Table: {title!r} ({args.table_id}) — {len(columns)} columns")

    with csv_path.open(newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        if not reader.fieldnames:
            raise SystemExit("CSV has no headers")
        headers = list(reader.fieldnames)
        rows = list(reader)

    mapping, unused = build_header_map(headers, columns)
    print("\nHeader -> column map:")
    for h, col in mapping.items():
        print(f"  {h!r:30} -> {col['id']} ({col.get('name')}, {col.get('type')})")
    if unused:
        print("\nSkipped CSV headers (no matching non-formula column):")
        for h in unused:
            print(f"  - {h}")

    formula_cols = [c for c in columns if c.get("type") == "formula"]
    if formula_cols:
        print("\nFormula columns (not imported; computed in app):")
        for c in formula_cols:
            print(f"  - {c.get('id')} {c.get('name')}")

    payloads = []
    for i, row in enumerate(rows):
        values: dict = {}
        for h, col in mapping.items():
            raw = row.get(h, "")
            if raw is None:
                raw = ""
            # DictReader may leave multiline; normalize newlines in notes
            if isinstance(raw, str):
                raw = raw.strip()
            v = cell_value(col.get("type") or "text", raw)
            if v is None and (col.get("type") or "") != "text":
                continue
            if (col.get("type") or "") == "text" and v == "":
                continue
            values[col["id"]] = v
        if not values:
            print(f"  skip empty row {i}")
            continue
        payloads.append(
            {
                "wiki_table": args.table_id,
                "values_json": json.dumps(values, ensure_ascii=False),
                "sort_order": i,
            }
        )

    print(f"\n{len(payloads)} rows ready to import.")
    if args.dry_run:
        if payloads:
            print("Sample values_json:")
            print(payloads[0]["values_json"][:500])
        print("Dry run — nothing written.")
        return 0

    if args.clear:
        existing = api(
            f"{base}/api/collections/wiki_table_rows/records"
            f'?filter=wiki_table%3D"{args.table_id}"&perPage=500',
            token=token,
        )
        items = existing.get("items") or []
        print(f"Clearing {len(items)} existing rows...")
        for item in items:
            api(
                f"{base}/api/collections/wiki_table_rows/records/{item['id']}",
                method="DELETE",
                token=token,
            )

    for i, body in enumerate(payloads):
        api(
            f"{base}/api/collections/wiki_table_rows/records",
            method="POST",
            token=token,
            body=body,
        )
        if (i + 1) % 10 == 0 or i + 1 == len(payloads):
            print(f"  created {i + 1}/{len(payloads)}")

    print("Done. Hard-refresh the wiki page.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

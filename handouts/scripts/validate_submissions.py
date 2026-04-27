#!/usr/bin/env python3
"""Validate OpenPGP key-signing party Google Forms exports."""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import re
import shutil
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid
from pathlib import Path


def norm_header(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", value.lower())


def norm_fpr(value: str) -> str:
    return re.sub(r"[^A-Fa-f0-9]+", "", value).upper()


def truthy(value: str) -> bool:
    cleaned = value.strip().lower()
    if not cleaned:
        return False
    return cleaned not in {"no", "false", "unchecked", "declined", "0"}


def find_field(headers: list[str], candidates: list[str]) -> str | None:
    normalized = {norm_header(header): header for header in headers}
    for candidate in candidates:
        wanted = norm_header(candidate)
        if wanted in normalized:
            return normalized[wanted]
    for header in headers:
        haystack = norm_header(header)
        if any(norm_header(candidate) in haystack for candidate in candidates):
            return header
    return None


def field(row: dict[str, str], name: str | None) -> str:
    return (row.get(name or "", "") or "").strip()


def require_fields(found: dict[str, str | None]) -> bool:
    missing = [label for label, header in found.items() if not header]
    if not missing:
        return True
    print("Required CSV column(s) not found:", file=sys.stderr)
    for label in missing:
        print(f"  - {label}", file=sys.stderr)
    return False


def parse_time(value: str) -> dt.datetime:
    value = value.strip()
    if not value:
        return dt.datetime.min
    for fmt in ("%m/%d/%Y %H:%M:%S", "%m/%d/%Y %H:%M", "%Y-%m-%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S"):
        try:
            return dt.datetime.strptime(value.replace("Z", ""), fmt)
        except ValueError:
            pass
    try:
        return dt.datetime.fromisoformat(value.replace("Z", "+00:00")).replace(tzinfo=None)
    except ValueError:
        return dt.datetime.min


def run_gpg(args: list[str], homedir: Path, stdin: bytes | None = None) -> subprocess.CompletedProcess[bytes]:
    return subprocess.run(
        ["gpg", "--homedir", str(homedir), "--batch", "--no-tty", *args],
        input=stdin,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def clean_gpg_stderr(stderr: bytes) -> str:
    ignored = (
        "keybox ",
        "trustdb.gpg: trustdb created",
        "directory ",
    )
    lines = []
    for line in stderr.decode("utf-8", "replace").splitlines():
        text = line.strip()
        if not text:
            continue
        if any(marker in text for marker in ignored) and "created" in text:
            continue
        lines.append(text)
    return "\n".join(lines)


def inspect_key(public_key: str, temp_root: Path) -> tuple[dict[str, str | list[str]], str | None]:
    temp_root.mkdir(parents=True, exist_ok=True)
    homedir = temp_root / f"ksp-gpg-{uuid.uuid4().hex}"
    try:
        homedir.mkdir()
        key_path = homedir / "key.asc"
        key_path.write_text(public_key, encoding="utf-8")
        imported = run_gpg(["--import", str(key_path)], homedir)
        if imported.returncode != 0:
            return {}, clean_gpg_stderr(imported.stderr)
        listed = run_gpg(["--with-colons", "--fingerprint", "--list-keys"], homedir)
        if listed.returncode != 0:
            return {}, clean_gpg_stderr(listed.stderr)
    finally:
        shutil.rmtree(homedir, ignore_errors=True)

    primary_fprs: list[str] = []
    key_type = ""
    expires = ""
    revoked = False
    expired = False
    uids: list[str] = []
    primary_index = -1

    for line in listed.stdout.decode("utf-8", "replace").splitlines():
        parts = line.split(":")
        if parts[0] == "pub":
            primary_index += 1
            validity = parts[1]
            if primary_index == 0:
                key_type = f"algo-{parts[3]}" if len(parts) > 3 else ""
                expires = parts[6] if len(parts) > 6 else ""
                revoked = validity == "r"
                expired = validity == "e"
        elif parts[0] == "fpr" and primary_index >= 0 and len(primary_fprs) == primary_index:
            primary_fprs.append(parts[9])
        elif parts[0] == "uid" and primary_index == 0 and len(parts) > 9:
            uids.append(parts[9])

    if len(primary_fprs) != 1:
        return {}, f"Expected exactly one primary public key, found {len(primary_fprs)}."

    if not primary_fprs[0]:
        return {}, "No primary fingerprint found after import."

    return {
        "fingerprint": primary_fprs[0],
        "key_type": key_type,
        "expires": expires,
        "revoked": str(revoked),
        "expired": str(expired),
        "uids": uids,
    }, None


def lookup_keyserver(email: str, temp_root: Path) -> tuple[str | None, str | None]:
    url = "https://keys.openpgp.org/vks/v1/by-email/" + urllib.parse.quote(email)
    try:
        with urllib.request.urlopen(url, timeout=20) as response:
            public_key = response.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return None, "keys.openpgp.org has no verified key for this email."
        return None, f"keys.openpgp.org lookup failed: HTTP {exc.code}."
    except Exception as exc:
        return None, f"keys.openpgp.org lookup failed: {exc}."

    info, error = inspect_key(public_key, temp_root)
    if error:
        return None, "keys.openpgp.org returned a key that could not be parsed."
    return str(info["fingerprint"]), None


def name_matches(name: str, uids: list[str]) -> bool:
    legal = re.sub(r"\([^)]*\)", "", name).strip().lower()
    tokens = [token for token in re.findall(r"[a-z0-9]+", legal) if len(token) > 1]
    uid_text = " ".join(uids).lower()
    return bool(tokens) and all(token in uid_text for token in tokens)


def format_expiry(value: str) -> str:
    if not value:
        return ""
    try:
        return dt.datetime.fromtimestamp(int(value), tz=dt.timezone.utc).date().isoformat()
    except ValueError:
        return value


def typst_text(value: str) -> str:
    return (
        value.replace("\\", "\\\\")
        .replace("[", "\\[")
        .replace("]", "\\]")
        .replace("#", "\\#")
        .replace("*", "\\*")
        .replace("_", "\\_")
        .replace("`", "\\`")
        .replace("@", "\\@")
    )


def typst_raw(value: str) -> str:
    return value.replace("\\", "\\\\").replace("`", "\\`")


def write_csv(path: Path, rows: list[dict[str, str]], columns: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=columns)
        writer.writeheader()
        for row in rows:
            writer.writerow({column: row.get(column, "") for column in columns})


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", default="handouts/data/form_submissions.csv", help="Google Forms CSV export")
    parser.add_argument("--output-dir", default="handouts/build", help="Directory for generated outputs")
    parser.add_argument("--skip-keyserver-lookup", action="store_true", help="Do not query keys.openpgp.org")
    args = parser.parse_args()

    if not shutil.which("gpg"):
        print("gpg is required on PATH.", file=sys.stderr)
        return 2

    input_path = Path(args.input)
    output_dir = Path(args.output_dir)
    if not input_path.exists():
        print(f"Input CSV not found: {input_path}", file=sys.stderr)
        return 2

    output_dir.mkdir(parents=True, exist_ok=True)
    with input_path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        rows = list(reader)
        headers = reader.fieldnames or []

    name_col = find_field(headers, ["full legal name", "legal name", "full name", "name"])
    email_col = find_field(headers, ["email address", "email"])
    key_col = find_field(headers, ["ascii armored public key", "public key block", "openpgp public key", "public key"])
    fpr_col = find_field(headers, ["primary key fingerprint", "full fingerprint", "fingerprint"])
    time_col = find_field(headers, ["timestamp", "submission time"])
    privacy_col = find_field(headers, ["privacy sharing consent", "privacy consent", "sharing consent"])
    accuracy_col = find_field(headers, ["submission accuracy", "accuracy acknowledgment", "accuracy"])
    liability_col = find_field(headers, ["risk liability acknowledgment", "liability acknowledgment", "risk acknowledgment"])

    required = {
        "Timestamp": time_col,
        "Full name": name_col,
        "Email address": email_col,
        "ASCII-armored public key block": key_col,
        "Full primary fingerprint": fpr_col,
        "Privacy / Sharing Consent": privacy_col,
        "Submission Accuracy": accuracy_col,
        "Risk / Liability Acknowledgment": liability_col,
    }
    if not require_fields(required):
        return 2
    ack_cols = [privacy_col, accuracy_col, liability_col]

    latest: dict[str, tuple[dt.datetime, int, dict[str, str]]] = {}
    for index, row in enumerate(rows):
        email_key = field(row, email_col).lower()
        name_key = re.sub(r"\s+", " ", field(row, name_col).lower()).strip()
        key = f"{email_key}|{name_key}" if email_key or name_key else str(index)
        stamp = parse_time(field(row, time_col))
        if key not in latest or (stamp, index) > (latest[key][0], latest[key][1]):
            latest[key] = (stamp, index, row)

    validated: list[dict[str, str]] = []
    correction: list[dict[str, str]] = []
    rejected: list[dict[str, str]] = []
    report: list[str] = []
    all_keys: list[str] = []

    for _, _, row in latest.values():
        name = field(row, name_col)
        email = field(row, email_col)
        public_key = field(row, key_col)
        submitted_fpr = norm_fpr(field(row, fpr_col))
        reasons: list[str] = []
        fatal: list[str] = []

        if not name:
            reasons.append("Missing full legal name.")
        if not email:
            reasons.append("Missing email address.")
        if not submitted_fpr:
            reasons.append("Missing primary fingerprint.")
        if "-----BEGIN PGP PRIVATE KEY BLOCK-----" in public_key:
            fatal.append("Submission contains private key material.")
        if "-----BEGIN PGP PUBLIC KEY BLOCK-----" not in public_key:
            reasons.append("Missing ASCII-armored public key block.")
        for ack_col in ack_cols:
            if not truthy(field(row, ack_col)):
                reasons.append(f"Required acknowledgment not checked: {ack_col}.")

        info: dict[str, str | list[str]] = {}
        if not fatal and public_key and "-----BEGIN PGP PUBLIC KEY BLOCK-----" in public_key:
            info, error = inspect_key(public_key, output_dir)
            if error:
                fatal.append(f"Public key does not parse: {error}")
            else:
                actual_fpr = norm_fpr(str(info["fingerprint"]))
                if submitted_fpr and submitted_fpr != actual_fpr:
                    fatal.append("Submitted fingerprint does not match public key primary fingerprint.")
                uids = list(info["uids"])  # type: ignore[arg-type]
                if email and email.lower() not in " ".join(uids).lower():
                    reasons.append("Submitted email does not appear in a key User ID.")
                if name and not name_matches(name, uids):
                    reasons.append("Submitted name is not closely represented in a key User ID.")
                if info["revoked"] == "True":
                    fatal.append("Primary key is revoked.")
                if info["expired"] == "True":
                    fatal.append("Primary key is expired.")

                if email and not args.skip_keyserver_lookup:
                    ks_fpr, ks_error = lookup_keyserver(email, output_dir)
                    if ks_error:
                        reasons.append(ks_error)
                    elif norm_fpr(ks_fpr or "") != actual_fpr:
                        reasons.append("keys.openpgp.org verified key for this email has a different fingerprint.")

        out = {
            "name": name,
            "email": email,
            "submitted_fingerprint": submitted_fpr,
            "calculated_fingerprint": norm_fpr(str(info.get("fingerprint", ""))),
            "key_type": str(info.get("key_type", "")),
            "expiration_date": format_expiry(str(info.get("expires", ""))),
            "reasons": " ".join(fatal + reasons),
        }

        if fatal:
            rejected.append(out)
            report.append(f"REJECTED: {name or email or '<unknown>'}: {out['reasons']}")
        elif reasons:
            correction.append(out)
            report.append(f"NEEDS CORRECTION: {name or email or '<unknown>'}: {out['reasons']}")
        else:
            validated.append(out)
            all_keys.append(public_key.rstrip() + "\n")
            report.append(f"VALIDATED: {name} <{email}> {out['calculated_fingerprint']}")

    columns = ["name", "email", "submitted_fingerprint", "calculated_fingerprint", "key_type", "expiration_date", "reasons"]
    write_csv(output_dir / "validated_participants.csv", validated, columns)
    write_csv(output_dir / "needs_correction.csv", correction, columns)
    write_csv(output_dir / "rejected_submissions.csv", rejected, columns)
    (output_dir / "validation_report.txt").write_text("\n".join(report) + "\n", encoding="utf-8")
    (output_dir / "all-keys.asc").write_text("\n".join(all_keys), encoding="utf-8")

    printable = [
        '#import "../typst/bcc-keysigning-style.typ": *',
        '#bcc-doc(title: "Key Signing Party", subtitle: "Printable Key List", audience: "Validated Participants")[',
        '= Participants',
    ]
    for row in validated:
        printable.append(f"== {typst_text(row['name'])}")
        printable.append(f"- Email: `{typst_raw(row['email'])}`")
        printable.append(f"- Fingerprint: `{typst_raw(row['calculated_fingerprint'])}`")
        printable.append(f"- Key: `{typst_raw(row['key_type'])}` Expires: `{typst_raw(row['expiration_date'] or 'none listed')}`")
        printable.append("- Verified: [ ]")
    printable.append("]")
    (output_dir / "printable_key_list.typ").write_text("\n".join(printable) + "\n", encoding="utf-8")

    print(f"Validated: {len(validated)}")
    print(f"Needs correction: {len(correction)}")
    print(f"Rejected: {len(rejected)}")
    print(f"Outputs written to: {output_dir}")
    return 1 if correction or rejected else 0


if __name__ == "__main__":
    raise SystemExit(main())

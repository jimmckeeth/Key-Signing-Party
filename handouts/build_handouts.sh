#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v typst >/dev/null 2>&1; then
  echo "Typst is not installed or is not on PATH. Run ./handouts/install_prerequisites.sh first." >&2
  exit 1
fi

typst compile "$script_dir/attendee_pre_event_guide.typ" "$script_dir/attendee_pre_event_guide.pdf"
typst compile "$script_dir/organizer_pre_event_guide.typ" "$script_dir/organizer_pre_event_guide.pdf"
typst compile "$script_dir/attendee_keylist_topper.typ" "$script_dir/attendee_keylist_topper.pdf"
typst compile "$script_dir/organizer_day_of_checklist.typ" "$script_dir/organizer_day_of_checklist.pdf"

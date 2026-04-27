#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/../.." && pwd)"

input_path="$repo_root/handouts/data/form_submissions.csv"
output_dir="$repo_root/handouts/build"
extra_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      if [[ $# -lt 2 ]]; then
        echo "--input requires a path." >&2
        exit 2
      fi
      input_path="$2"
      shift 2
      ;;
    --output-dir)
      if [[ $# -lt 2 ]]; then
        echo "--output-dir requires a path." >&2
        exit 2
      fi
      output_dir="$2"
      shift 2
      ;;
    --skip-keyserver-lookup)
      extra_args+=("--skip-keyserver-lookup")
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is required to run validation." >&2
  exit 2
fi

exec python3 "$script_dir/validate_submissions.py" \
  --input "$input_path" \
  --output-dir "$output_dir" \
  "${extra_args[@]}"

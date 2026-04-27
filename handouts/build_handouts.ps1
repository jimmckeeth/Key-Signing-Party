$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Get-Command typst -ErrorAction SilentlyContinue)) {
    throw "Typst is not installed or is not on PATH. Run handouts\install_prerequisites.ps1 first."
}

typst --version | Out-Null

typst compile (Join-Path $root "attendee_pre_event_guide.typ") (Join-Path $root "attendee_pre_event_guide.pdf")
typst compile (Join-Path $root "organizer_pre_event_guide.typ") (Join-Path $root "organizer_pre_event_guide.pdf")
typst compile (Join-Path $root "attendee_keylist_topper.typ") (Join-Path $root "attendee_keylist_topper.pdf")
typst compile (Join-Path $root "organizer_day_of_checklist.typ") (Join-Path $root "organizer_day_of_checklist.pdf")

# Boise Code Camp OpenPGP Key Signing Party

Guides, handouts, and build scripts for running an OpenPGP key signing party at Boise Code Camp.

The event model is intentionally conservative:

- Attendees submit public key material before the event.
- The organizer validates submissions and prints a key list.
- At the event, participants verify government-issued photo ID and full OpenPGP fingerprints.
- Nobody signs keys at the event.
- After the event, attendees import the final key bundle, re-check fingerprints against their marked sheets, and sign only keys they personally verified.

## Current Event

- Event: Boise Code Camp key signing party
- Date: Saturday, May 2, 2026
- Official submission form: <https://forms.gle/61H58E9gjswN366KA>
- Submission deadline: Wednesday, April 29, 2026 at 11:59 PM Mountain Time
- Print freeze: Friday, May 1, 2026 at 12:00 PM Mountain Time
- Follow-up package deadline: Monday, May 4, 2026 at 11:59 PM Mountain Time

## Handouts

Typst source files live in `handouts/`:

- `attendee_pre_event_guide.typ`: attendee preparation, submission, event expectations, and post-event signing guidance
- `organizer_pre_event_guide.typ`: organizer operating procedure and validation policy
- `attendee_keylist_topper.typ`: compact at-event rules block for the top of the printed key list
- `organizer_day_of_checklist.typ`: one-page day-of organizer checklist
- `typst/bcc-keysigning-style.typ`: shared visual style

Generated PDFs are written next to the Typst sources:

- `attendee_pre_event_guide.pdf`
- `organizer_pre_event_guide.pdf`
- `attendee_keylist_topper.pdf`
- `organizer_day_of_checklist.pdf`

## Build Prerequisites

The handouts are built with [Typst](https://typst.app/).

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File handouts\install_prerequisites.ps1
```

Debian Linux or macOS:

```bash
bash handouts/install_prerequisites.sh
```

The Linux/macOS installer uses `apt-get` on Debian-like systems, Homebrew on macOS, or Cargo as a fallback.

## Build PDFs

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File handouts\build_handouts.ps1
```

Debian Linux or macOS:

```bash
bash handouts/build_handouts.sh
```

## Security and Privacy Posture

This repository treats the organizer as a coordinator, not a trust authority.

- The printed list is for identity and fingerprint verification only.
- The key bundle is a convenience file, not a trust source.
- Full fingerprints are checked in person and checked again after import.
- Public keys may be distributed to event participants.
- Private keys must never be submitted, emailed, uploaded, pasted, or shared.
- The attendee list is not intended for public posting.

## Validation Workflow

The organizer guide assumes a validation workflow under:

- `handouts/data/`
- `handouts/scripts/`
- `handouts/build/`

The intended policy is:

- Export form responses to `handouts/data/form_submissions.csv`.
- Run validation scripts from `handouts/scripts/`.
- Generate final artifacts under `handouts/build/`.
- Do not manually edit generated final artifacts.

Validation scripts are planned as event tooling. The handouts already document the validation policy so the event can be operated consistently once those scripts exist.

## References

- [keys.openpgp.org GnuPG usage guide](https://keys.openpgp.org/about/usage-gnupg/)
- [keys.openpgp.org FAQ](https://keys.openpgp.org/about/faq/)
- [GnuPG OpenPGP key management](https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html)
- [GnuPG HOWTO index](https://www.gnupg.org/documentation/howtos.html)
- [Attending a PGP/GnuPG signing party](https://danielpecos.com/2024/01/23/attending-a-pgp-gnupg-signing-party/)

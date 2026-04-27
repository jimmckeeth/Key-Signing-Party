#import "typst/bcc-keysigning-style.typ": *

#bcc-doc(
  title: "Key Signing Party",
  subtitle: "Organizer Pre-Event Guide",
  audience: "Apr 26-May 4, 2026",
)[
#callout(
  [Operating rule],
  [Use the Google Form as the official source, validate every submission with the script, print only validated entries, and distribute the key bundle only after the in-person verification event.],
)

= Fixed Decisions

#table(
  columns: (30%, 70%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  [Submission form], [#link("https://forms.gle/61H58E9gjswN366KA")[https://forms.gle/61H58E9gjswN366KA]],
  [Fallback email], [`openpgp@mckeeth.org` only if the form does not work or an organizer requests a correction.],
  [Submission deadline], [Wednesday, April 29, 2026 at 11:59 PM Mountain Time. Close the form then.],
  [Print freeze], [Friday, May 1, 2026 at 12:00 PM Mountain Time. After this, remove invalid entries only; do not add or hand-correct entries.],
  [Identity policy], [Current state or federal government-issued photo ID required. School IDs, badges, and personal recognition are not enough.],
  [Keyserver policy], [keys.openpgp.org upload and email verification required. keyserver.ubuntu.com is recommended backup only.],
  [Post-event package], [Send by Monday, May 4, 2026 at 11:59 PM Mountain Time.],
)

= Timeline

#table(
  columns: (30%, 70%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  [Now], [Send the attendee guide and form link. Confirm `openpgp@mckeeth.org` works as fallback/questions address.],
  [Wed, Apr 29], [At 11:59 PM Mountain Time, turn off Google Form responses. Late new submissions are not included.],
  [Thu, Apr 30], [Export responses to `handouts/data/form_submissions.csv`. Run validation. Co-organizers chase script-reported corrections.],
  [Fri, May 1 AM], [Run validation again after corrections. Prepare packets from generated outputs only.],
  [Fri, May 1 noon], [Freeze printed list. Do not add or hand-correct entries after this point.],
  [Sat, May 2], [Run the event. If a printed entry is wrong, issue a corrected printed addendum or mark the entry do-not-verify.],
  [Mon, May 4], [Send post-event package by 11:59 PM Mountain Time.],
)
#pagebreak()
= Intake Rules

The Google Form must collect:

#enum(
  [Full legal name as shown on the government-issued photo ID. Preferred name may appear in parentheses, for example `James McKeeth (Jim)`.],
  [Email address listed on the submitted public key.],
  [Full ASCII-armored public key block.],
  [Full primary key fingerprint.],
  [Privacy/sharing consent.],
  [Risk/liability acknowledgment.],
  [Submission accuracy acknowledgment.],
)

Reject any submission that appears to contain private key material, including:

#command[`-----BEGIN PGP PRIVATE KEY BLOCK-----`]

If a person submits more than once before the deadline, use the latest timestamped submission.

After the form closes, accept only organizer-requested corrections for already-submitted entries. Corrections must pass validation before the Friday noon print freeze.

= Validation Workflow

Run validation on a machine with GnuPG and Python 3 installed.

Export the Google Form responses to:

#command[`handouts\data\form_submissions.csv`]

Run validation:

#command[`powershell -ExecutionPolicy Bypass -File handouts\scripts\validate_submissions.ps1`]

or on Linux/macOS:

#command[`bash handouts/scripts/validate_submissions.sh`]

The validation script is the source of truth for final artifacts. Do not manually assemble or edit final output files. Fix source submissions and rerun validation.

Expected generated files:

#compact-table(
  [`handouts\build\validated_participants.csv`], [Entries approved for printing and bundle generation.],
  [`handouts\build\needs_correction.csv`], [Entries organizers should chase before the print freeze.],
  [`handouts\build\rejected_submissions.csv`], [Entries excluded unless corrected and revalidated before the print freeze.],
  [`handouts\build\validation_report.txt`], [Summary of validation results and reasons.],
  [`handouts\build\all-keys.asc`], [Post-event key bundle. Do not distribute before or during the event.],
  [`handouts\build\printable_key_list.typ`], [Generated attendee key list source for printing.],
)

Validation must confirm:
- Public key block parses as an OpenPGP public key.
- Submission does not contain private key material.
- Submitted fingerprint matches the calculated primary fingerprint.
- Submitted email exists on the key.
- Submitted name is represented in a key User ID closely enough for printing.
- Key is not expired or revoked.
- Required consent and acknowledgment fields are checked.
- keys.openpgp.org lookup by email returns the same fingerprint, or the entry is flagged for correction.

#callout(
  [No validation pass, no printed inclusion],
  [Include only entries that pass validation. If a corrected submission is not validated before the Friday noon print freeze, exclude it from the printed key list and event bundle.],
  kind: "warning",
)

= Printed Materials

Each attendee packet includes:
- Attendee keylist topper.
- Generated participant key list.
- Space to mark each verified participant.

The printed key list includes:
- Name.
- Email address.
- Full primary fingerprint, grouped for readability.
- Key type.
- Expiration date.
- Verification marking area.

Do not print ASCII-armored public key blocks. The printed list is for identity and fingerprint verification only.

Organizer packet includes:
- Organizer day-of checklist.
- Master roster.
- Co-organizer roster.
- Correction log.
- Spare blank correction/addendum sheets.

#table(
  columns: (45%, 55%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  table.header([#strong[Co-organizer]], [#strong[Role]]),
  [ ], [ ],
  [ ], [ ],
  [ ], [ ],
)

= Event-Day Correction Rule

When attendees receive the printed list, they check their own entry first.

If a printed name, email, or fingerprint is wrong:
1. Mark the entry do-not-verify on the organizer roster.
2. Do not hand-correct fingerprints on attendee sheets.
3. Either issue a corrected printed addendum or exclude that key from verification for this event.
4. The attendee may still verify other participants.

= Event Briefing

Ask attendees to sign or initial their sheet as soon as they receive it. This lets each person confirm after the event that their marked sheet is the one they personally held during in-person verification.

Read this:

#command[`Sign or initial your sheet now before we begin. Today we verify identity and full OpenPGP fingerprints. Check a current state or federal government-issued photo ID, compare the complete fingerprint against the participant's own trusted copy, and mark your own sheet only if both match. School IDs, badges, social profiles, and personal recognition are not enough for this event. Do not sign keys here. If anyone pressures you to accept a mismatch or skip checks, stop and tell an organizer. After the event, import the final bundle, verify fingerprints again, then sign only keys you personally verified.`]

= Post-Event Package

Send by Monday, May 4, 2026 at 11:59 PM Mountain Time.

Include:
- `handouts\build\all-keys.asc`
- participant list (`validated_participants.csv` or exported text version)
- final PDF key list
- short signing instructions

Do not distribute `all-keys.asc` before or during the event.

Follow-up wording:

#command[`Import the attached key bundle, compare each fingerprint against your printed sheet and event marks, and sign only keys you personally verified. If anything does not match, do not sign. Certification level 2 is the normal choice after checking government-issued photo ID and the full fingerprint in person. Use level 3 only if you also know the person or independently verified email control; choose level 0 or do not sign if you are unsure. Export signed keys and send them directly to the key owners.`]

= Data Handling

Google Form responses and validation exports may be shared only with named event co-organizers who need access for validation, printing, or event operations.

Public key User IDs and fingerprints are not secrets: they are published on key directories, distributed to participants, and may remain in local OpenPGP keyrings after signing. Still, the event roster, raw form export, correction log, and attendance markings reveal a specific group association and should be treated as private event operations data.

Keep final public event artifacts needed for continuity and trust management, such as the key bundle and final key list. Delete or restrict raw Google Form exports, correction logs, and working validation files after follow-up is complete unless there is a concrete operational reason to retain them. Do not sell this information, post the attendee list publicly, or intentionally share it outside registered participants and event organizers.

= Source Notes

*Key signing party organization*
- #link("https://www.first.org/pgp/PGP-GnuPG_Key_Signing_Party_v1.0.pdf")[FIRST PGP/GnuPG Key Signing Party guide (PDF) — organizer procedures and protocols]
- #link("https://techwolf12.nl/blog/hosting-successful-gpg-keysigning-party/")[Hosting a successful GPG Keysigning Party — event flow and organizer checklist]
- #link("https://logological.org/keysigning")[Tristan Miller's key signing party guide — hash verification protocol]
- #link("https://danielpecos.com/2024/01/23/attending-a-pgp-gnupg-signing-party/")[Attending a PGP/GnuPG signing party — attendee perspective]

*Post-event signing tools*
- #link("https://salsa.debian.org/signing-party-team/signing-party")[signing-party package (caff) — encrypts signatures to recipient before emailing]
- #link("https://www.phildev.net/pius/")[pius — PGP Individual UID Signer]

*Keyservers*
- #link("https://keys.openpgp.org/about/usage-gnupg/")[keys.openpgp.org GnuPG usage guide]
- #link("https://keys.openpgp.org/about/faq/")[keys.openpgp.org FAQ]

*GnuPG reference*
- #link("https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html")[GnuPG OpenPGP key management]
- #link("https://www.gnupg.org/gph/en/manual.html")[GNU Privacy Handbook]
]

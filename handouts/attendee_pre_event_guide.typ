#import "typst/bcc-keysigning-style.typ": *

#bcc-doc(
  title: "Key Signing Party",
  subtitle: "Attendee Pre-Event Guide",
  audience: "Before May 2, 2026",
)[
#callout(
  [Purpose],
  [Arrive prepared for the Boise Code Camp key signing party on Saturday, May 2, 2026. Before the event, create or confirm your OpenPGP key, publish it to keys.openpgp.org, submit it through the official form, and bring your government-issued photo ID plus your own printed fingerprint.],
)

= Official Submission

Submit your key by Wednesday, *April 29, 2026 at 11:59 PM* Mountain Time: https://forms.gle/61H58E9gjswN366KA

If the Google Form does not work, email the same information to `openpgp@mckeeth.org` before the deadline.

#callout(
  [Double-check before submitting],
  [Your name, email address, public key, and full fingerprint must be correct. If your submission is incomplete, incorrect, or cannot be validated before printing, you may not be included in the final key list for this event.],
  kind: "warning",
)

= Schedule

#table(
  columns: (25%, 75%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  [Now], [Install GnuPG. Create a new key or inspect your existing strong key.],
  [Before submitting], [Upload to keys.openpgp.org and complete its email verification.],
  [Wed, Apr 29], [Submit the form by 11:59 PM Mountain Time.],
  [Thu, Apr 30], [Watch for organizer correction requests. Respond quickly.],
  [Fri, May 1], [Print your own fingerprint and put it with your government-issued photo ID.],
  [Sat, May 2], [Bring your ID and printed fingerprint. Verify in person; sign later.],
)

= 1. Install GnuPG

Use GnuPG 2.4 or newer if possible.

#table(
  columns: (25%, 75%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  table.header(
    [#strong[Platform]],
    [#strong[Command]],
  ),
  [Windows 10/11], [`winget install GnuPG`],
  [macOS], [`brew install gnupg`],
  [Debian/Ubuntu], [`sudo apt install gnupg`],
  [Fedora], [`sudo dnf install gnupg`],
)
#linebreak()
= 2. Create or Confirm Your Key

If you do not already have a strong active OpenPGP key, create one with the recommended simple command:

#command[`gpg --quick-generate-key "Full Legal Name <you@example.com>" future-default default 2y`]

Replace `Full Legal Name` with the name on the government-issued photo ID you will bring. If you commonly use a preferred name, include it after your legal name in parentheses, for example:

#command[`gpg --quick-generate-key "James McKeeth (Jim) <jim@example.com>" future-default default 2y`]

If you already have a strong key, use it instead of creating a second identity casually. If you want an advanced setup with an offline primary key, subkeys, or hardware-backed storage, read more before generating:

- #link("https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html")[GnuPG OpenPGP key management]
- #link("https://www.gnupg.org/documentation/manuals/gnupg26/gpg.1.html")[GnuPG command reference]

= 3. Protect Your Private Key

Never submit, email, upload, paste, copy, or share your private key or GnuPG home directory. The organizer only needs your public key.

If you see text beginning with this, stop:

#command[`-----BEGIN PGP PRIVATE KEY BLOCK-----`]

Do not submit it.

= 4. Export Your Public Key

To save your public key to a file:

#command[`gpg --armor --export you@example.com > public-key.asc`]

To print it to the terminal so you can copy it into the form:

#command[`gpg --armor --export you@example.com`]

The public key block must begin with:

#command[`-----BEGIN PGP PUBLIC KEY BLOCK-----`]

#linebreak()
= 5. Publish Your Public Key

Required: upload your public key to keys.openpgp.org and complete the email verification message it sends.

#link("https://keys.openpgp.org/")[https://keys.openpgp.org/]

You can also upload from the command line:

#command[`gpg --export you@example.com | curl -T - https://keys.openpgp.org`]

Recommended backup:

#command[`gpg --keyserver hkps://keyserver.ubuntu.com --send-keys YOUR-FINGERPRINT`]

The backup server is for availability only. It is not a source of trust.

= 6. Find Your Fingerprint

Display your full primary key fingerprint:

#command[`gpg --fingerprint you@example.com`]

Submit the full fingerprint in the form. It must match the public key you paste.

= 7. Bring to the Event

#checklist((
  [A current photo ID issued by a state or federal government, such as a state driver's license, state ID card, government passport, military ID, or similar government-issued photo identification.],
  [A printed copy of your own full fingerprint.],
  [Your marked attendee sheet after the event; you will need it before signing.],
))

School IDs, workplace badges, conference badges, social media profiles, and personal recognition are not enough for this event's key verification process.

= At the Event

When you receive the printed key list, check your own entry first. Confirm your name, email, and full fingerprint are correct. If anything is wrong, tell an organizer immediately and do not ask others to verify your key until the organizer resolves it.

For each person you verify:
1. Check their government-issued photo ID.
2. Confirm the name reasonably matches the printed key list.
3. Compare the complete fingerprint.
4. Mark your sheet only if both identity and fingerprint match.

You are not expected to be a counterfeit-document expert. Look for whether the ID is issued by a state or federal government, the photo reasonably matches the person, the name reasonably matches the printed list, and the ID is not obviously expired, altered, damaged, or unreadable.

#callout(
  [Resist pressure],
  [If anyone pressures you to accept a mismatch, sign immediately, skip checks, or verify someone you are unsure about, stop and tell an organizer. It is always acceptable to say, "I'm not comfortable signing this one."],
  kind: "warning",
)
#pagebreak()
= After the Event

The organizer will send the final package by Monday, May 4, 2026 at 11:59 PM Mountain Time. It will include the key bundle, participant list, final PDF key list, and signing instructions.

Import the key bundle:

#command[`gpg --import all-keys.asc`]

For each person you personally verified, check the fingerprint again:

#command[`gpg --fingerprint KEYID`]

Then sign only keys you are comfortable signing:

#command[`gpg --ask-cert-level --sign-key KEYID`]

Certification level 3 is appropriate when you carefully checked a government-issued photo ID and the full fingerprint matched. Choose a lower level, or do not sign, if you are unsure.

Export the signed public key and send it directly to the key owner:

#command[`gpg --armor --export KEYID > signed-key.asc`]

Do not rely on keys.openpgp.org to distribute third-party signatures.

= More Information

- #link("https://keys.openpgp.org/about/usage-gnupg/")[keys.openpgp.org GnuPG usage guide]
- #link("https://keys.openpgp.org/about/faq/")[keys.openpgp.org FAQ]
- #link("https://www.gnupg.org/documentation/howtos.html")[GnuPG HOWTO index]
- #link("https://danielpecos.com/2024/01/23/attending-a-pgp-gnupg-signing-party/")[Attending a PGP/GnuPG signing party]
]

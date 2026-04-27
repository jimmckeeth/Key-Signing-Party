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
  [Fri, May 1], [The organizer will email the final key list. Save it and run: `sha256sum keylist.pdf` (Linux/macOS) or `Get-FileHash keylist.pdf` (Windows). Write down the hash. Print your fingerprint. Bring both with your government-issued photo ID.],
  [Sat, May 2], [Bring your ID, printed fingerprint, and computed hash. Verify hash at the start; verify identity and fingerprint in person; sign later.],
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

#callout(
  [Advanced: offline master key with subkeys],
  [
    A stronger setup separates your long-term primary (master) key from daily-use subkeys for signing, encryption, and authentication. The primary key is kept offline on encrypted media and brought online only to certify new subkeys, sign others' keys, or issue revocations. Daily operations use subkeys stored on your computer or a hardware token such as a YubiKey or Nitrokey.

    This means a compromised laptop or lost hardware token does not expose your identity — you revoke and replace the affected subkey while your web of trust remains intact.

    - #link("https://github.com/drduh/yubikey-guide")[drduh YubiKey Guide — offline key generation, subkey setup, and hardware token provisioning]
    - #link("https://www.gnupg.org/gph/en/manual/c235.html")[GnuPG key management — primary keys and subkeys]
    - #link("https://wiki.debian.org/Subkeys")[Debian Wiki: Subkeys]
  ],
)

= 3. Protect Your Private Key

Never submit, email, upload, paste, copy, or share your private key or GnuPG home directory. The organizer only needs your public key.

If you see text beginning with this, stop:

#command[`-----BEGIN PGP PRIVATE KEY BLOCK-----`]

Do not submit it.

== Passphrase

GnuPG encrypts your private key on disk with a passphrase. A weak passphrase is one of the most common ways keys are compromised.

#callout(
  [Passphrase best practices],
  [
    - *Use a diceware phrase* — five or more random words (for example, "correct horse battery staple finch") gives strong protection and is practical to memorize. See #link("https://www.eff.org/dice")[EFF's diceware word list].
    - *Avoid* keyboard patterns, dictionary words alone, or anything derived from personal information.
    - *Never reuse* a passphrase from another account or service.
    - *Back up your passphrase* in writing and store it in a physically separate, secure location from your key backup media. If you lose both, your key is unrecoverable.
  ],
)

== Private Key Backup

Export an encrypted backup of your full private key and store it on offline media (such as an encrypted USB drive) kept in a secure location:

#command[`gpg --armor --export-secret-keys you@example.com > private-key-backup.asc`]

Also generate a revocation certificate immediately and keep it separately — you will need it to invalidate your key if it is ever compromised or lost:

#command[`gpg --gen-revoke you@example.com > revoke.asc`]

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
  [Your computed SHA-256 hash of the key list file the organizer emailed.],
))

School IDs, workplace badges, conference badges, social media profiles, and personal recognition are not enough for this event's key verification process.

= At the Event

At the start of the session, the organizer will announce the SHA-256 hash of the key list file. Compare it to the hash you computed at home. If they do not match, do not mark any entries — tell an organizer immediately. This step confirms that every person in the room is working from an identical, unaltered list.

When you receive the printed key list, check your own entry first. Confirm your name, email, and full fingerprint are correct. If anything is wrong, tell an organizer immediately and do not ask others to verify your key until the organizer resolves it.

For each person you verify:
1. Check their government-issued photo ID.
2. Confirm the name reasonably matches the printed key list.
3. Compare the complete fingerprint — read it aloud together.
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

Do not rely on keys.openpgp.org to distribute third-party signatures — it strips them by design.

#callout(
  [Automated signing tools],
  [
    `caff` (from the `signing-party` package on Debian/Ubuntu) and `pius` automate this workflow and add an important privacy step: they encrypt your signature using the recipient's public key before emailing it. This proves the recipient controls the key, and it ensures the signature cannot be published without their knowledge or consent. Using these tools is the recommended approach when signing many keys.

    - #link("https://salsa.debian.org/signing-party-team/signing-party")[signing-party package (caff) — Debian Salsa]
    - #link("https://www.phildev.net/pius/")[pius — PGP Individual UID Signer]
  ],
)

= More Information

- #link("https://keys.openpgp.org/about/usage-gnupg/")[keys.openpgp.org GnuPG usage guide]
- #link("https://keys.openpgp.org/about/faq/")[keys.openpgp.org FAQ]
- #link("https://www.gnupg.org/documentation/howtos.html")[GnuPG HOWTO index]
- #link("https://danielpecos.com/2024/01/23/attending-a-pgp-gnupg-signing-party/")[Attending a PGP/GnuPG signing party]
]

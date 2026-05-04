# Definitive OpenPGP

## A Comprehensive Framework for Cryptographic Identity, Trust Management, and Secure Communication

The landscape of secure digital communications demands cryptographic
frameworks capable of ensuring the absolute confidentiality, integrity,
and authenticity of data across untrusted networks. Since its conceptual
inception in 1991 and the formalization of the Web of Trust concept by
Phil Zimmermann in 1992, Pretty Good Privacy (PGP) and its open-source
standard implementation, the GNU Privacy Guard (GnuPG), have provided
the foundational architecture for decentralized identity verification
and end-to-end encryption.[^1] However, the modern threat
landscape, characterized by advanced persistent threats,
man-in-the-middle (MitM) attacks, and the looming advent of post-quantum
computing, necessitates an evolution in how cryptographic keys are
generated, stored, distributed, and verified.[^4]

While contemporary alternatives like the age file encryption tool have
emerged to offer streamlined, configuration-free encryption without the
overhead of global keyrings or decentralized trust graphs, OpenPGP
remains the requisite standard for complex digital identity management,
software supply chain security, and multi-party secure
communications.[^3] This comprehensive report details the
definitive best practices for creating, managing, and utilizing a modern
OpenPGP infrastructure. The analysis covers algorithmic selection, the
architectural dichotomy of master keys and subkeys, hardware-backed
security modules, the transition from traditional keyservers to
federated Web Key Directories (WKD), and the intricate
social-cryptographic protocols of key signing parties.

## Algorithmic Evolution: The Ascendancy of Elliptic Curve Cryptography

The transition from legacy cryptographic algorithms to modern elliptic
curve cryptography (ECC) represents the most critical shift in
contemporary OpenPGP best practices. Historically, the
Rivest-Shamir-Adleman (RSA) algorithm dominated the ecosystem, relying
on the computational difficulty of factoring massively large prime
numbers.[^7] As global computational power has increased
exponentially over the decades, maintaining adequate security margins
with RSA has required increasingly large key sizes, commonly pushing
standard implementations to mandate 2048-bit or 4096-bit
keys.[^7]

In contrast, the modern cryptographic standard mandates the use of
Ed25519, an elliptic curve signature algorithm based on Curve25519
originally designed by cryptographer Daniel J. Bernstein.[^7]
Ed25519 relies on the mathematics of elliptic curves and discrete
logarithms rather than prime factorization, delivering a vastly superior
security profile with drastically reduced computational overhead and
substantially smaller key sizes.[^8]

The technical disparity between the two algorithmic approaches becomes
stark when examining real-world performance characteristics and
symmetric security equivalents. A standard 2048-bit RSA key provides
approximately 112 bits of symmetric security, whereas the highly compact
256-bit Ed25519 key yields approximately 128 bits of symmetric
security.[^7] This mathematical efficiency translates directly
into operational performance gains, particularly in signature
generation, authentication speed, and verification processes across
low-power devices and highly congested servers.

| **Feature**                       | **RSA (2048-bit / 4096-bit)**               | **Ed25519**                       |
| --------------------------------- | ------------------------------------------- | --------------------------------- |
| **Symmetric Security Equivalent** | ~112-bit (2048-bit)                         | 128-bit                           |
| **Public Key Size**               | ~500 bytes                                  | 32 bytes                          |
| **Signature Size**                | 256 bytes (2048-bit)                        | 64 bytes                          |
| **Generation Speed**              | Computationally heavy (especially 4096-bit) | Nearly instantaneous              |
| **Verification Speed**            | Slower than Ed25519                         | Extremely fast                    |
| **Underlying Mathematics**        | Prime number factorization                  | Elliptic curve discrete logarithm |
| **Security Footprint**            | Variable, CPU-intensive                     | Fixed size, lightweight           |

The storage efficiency of Ed25519—shrinking public keys from over 500
bytes to a mere 32 bytes—provides cumulative infrastructure benefits
across distributed systems managing thousands of keys or within
constraint-heavy environments like smart cards.[^7] Furthermore,
the fixed size of Ed25519 signatures prevents specific classes of
cryptographic side-channel attacks and simplifies the architectural
design of parsing software.[^8] Consequently, executing the gpg
--full-generate-key command and explicitly selecting Ed25519 for all new
key generation represents the definitive best practice, relegating RSA
strictly to legacy interoperability requirements for outdated
systems.[^10]

## Architecting the Digital Identity: Master Keys and Ephemeral Subkeys

The architecture of a modern OpenPGP certificate is inherently
hierarchical, intentionally separating the core, long-term identity of
the user from the ephemeral cryptographic tools utilized in daily
operations. This separation is achieved through the structural
implementation of a primary "master" key and multiple specialized
"subkeys" bound to the primary identity.[^13]

### The Sovereign Role of the Master Key

The primary master key acts as the absolute root of trust for a user's
digital identity. Within the GnuPG framework, this master key is
exclusively vested with Certification \[C\] and, optionally, Signing
\`\` capabilities.[^15] The Certification capability empowers
the master key to perform identity-critical functions: binding User IDs
(UIDs)—which contain human-readable names and email addresses—to the key
structure, cryptographically signing other users' keys to expand the
global Web of Trust, generating emergency revocation certificates, and
mathematically binding subordinate subkeys to the primary
identity.[^14]

Because the master key represents the user's permanent cryptographic
reputation within the community—a reputation built over years of
physical verification and peer endorsements—its compromise represents a
catastrophic security failure. Such a compromise necessitates a total
revocation of the identity and the permanent severing of all accumulated
trust relationships.[^17] Therefore, the definitive operational
best practice dictates that the master key must be maintained in an
offline, air-gapped environment at all times, securely stored on
encrypted external media.[^13] It is brought online to a secure,
amnesic operating system solely to issue new subkeys, sign external
users' keys following a key signing party, or execute a revocation
sequence.[^18]

### The Mechanics and Utility of Subkeys

To facilitate daily operations without exposing the highly sensitive
master key to internet-connected devices, OpenPGP utilizes subkeys.
Subkeys are standard public/private key pairs that have been
cryptographically signed by the offline master key, thereby inheriting
its reputation and established trust graph.[^17]

By default, a robust OpenPGP certificate features specific subkeys
delineated by their capability flags, ensuring a strict separation of
cryptographic duties:

- **Encryption \[E\]**: Used exclusively to decrypt confidential data
  sent to the user. OpenPGP algorithms strictly separate signing
  mechanisms from encryption mechanisms; for instance, an Elliptic Curve
  key must be explicitly generated for encryption (e.g., utilizing
  Curve25519 for Diffie-Hellman key exchanges) separate from the Ed25519
  signing key.[^12]

- **Signing \`\`**: Deployed for daily digital signatures, such as
  authenticating source code commits in Git repositories, signing
  release binaries, or providing authenticity to routine email
  communications.[^15]

- **Authentication \[A\]**: Utilized for Secure Shell (SSH)
  authentication, TLS client certificates, or Pluggable Authentication
  Module (PAM) system logins, replacing traditional SSH RSA keys with a
  unified OpenPGP identity.[^15]

The strict isolation of capabilities into distinct subkeys prevents
cross-protocol vulnerabilities—where an attacker might trick a user into
signing a message using an encryption key—and allows for highly granular
key lifecycle management.[^16] If an attacker steals a corporate
laptop containing a daily-use signing subkey, the user simply retrieves
their offline master key, generates a revocation certificate
specifically targeting the compromised subkey, and issues a new
one.[^17] The primary identity, along with the user's
meticulously established Web of Trust, remains entirely intact and
unaffected by the local hardware loss.[^17]

## Strategic Identity Management: Multiplexed UIDs versus Isolated Master Keys

A frequent architectural dilemma arises when individuals operate across
disparate domains, such as maintaining a highly visible professional
corporate identity alongside a pseudonymous open-source contributor
persona or an activist profile. OpenPGP provides two divergent
approaches to managing multiple identities: multiplexing multiple User
IDs (UIDs) onto a single master key, or generating entirely isolated
master key pairs for each persona.[^20]

### Single Master Key with Multiple UIDs

A single master key architecture can seamlessly encapsulate multiple
UIDs, such as Corporate \<<jane.doe&#64;company.com>\> alongside Personal
\<<jane&#64;personal.org>\> and Pseudonym \<<hacker&#64;darknet.net>\>.[^20]
This approach drastically centralizes cryptographic management,
requiring the user to secure only one offline master key, memorize one
strong passphrase, and provision a single hardware token for daily
operations.[^25] Furthermore, trust transitivity is maximized in
this model; when a professional colleague signs the corporate UID during
a conference, that signature technically validates the underlying master
key, indirectly boosting the validity and trust metrics of the personal
and pseudonymous UIDs attached to the same root.[^25]

However, this structural convenience comes at the absolute cost of
strict privacy and identity leakage. All UIDs attached to a master key
are publicly and mathematically linked by the master key's cryptographic
signature.[^24] An adversary or automated scanner inspecting a
public keyserver can instantly correlate the professional corporate
identity with the pseudonymous identity, collapsing the operational
security of both.[^24] While the gpg --edit-key command allows
an administrator to revoke individual UIDs if an email address changes
or a persona is retired, the historical association remains etched into
distributed, append-only keyservers permanently.[^27]
Furthermore, the OpenPGP standard does not support binding specific
encryption subkeys to specific UIDs; any active encryption subkey
associated with the master key will decrypt payloads intended for any of
the attached UIDs, eliminating cryptographic
compartmentalization.[^24]

### Multiple Isolated Master Keys

To achieve true cryptographic and social compartmentalization, users
must utilize the gpg --full-generate-key command to create distinct,
completely independent master key pairs for each identity.[^23]
This siloed approach ensures that a compromise, expiration, or
revocation of a corporate key has absolutely no bearing on personal
communications or activist profiles.[^25]

Implementing this strategy requires a higher degree of operational
discipline: maintaining multiple offline backups, memorizing multiple
distinct passphrases, and provisioning multiple hardware tokens (or
expertly managing separate applet slots on advanced hardware
tokens).[^24] For users requiring definitive privacy, separation
of concerns, or compliance with strict enterprise data isolation
policies—such as journalists handling sensitive sources, intelligence
analysts, or security researchers—deploying isolated master keys is not
merely a preference, but a mandatory operational standard.[^29]

## Lifecycle Management: Key Generation, Rotation, and Revocation Protocols

The operational lifecycle of an OpenPGP identity requires proactive
administration to mitigate the risks of algorithmic obsolescence,
hardware degradation, and potential key compromise.[^27] A
robust lifecycle policy dictates the use of strict expiration dates,
rigorous rotation schedules, and emergency revocation
capabilities.[^31]

### Key Expiration and Automated Rotation

While a master key represents an enduring identity and can theoretically
exist indefinitely without an embedded expiration date, cryptographic
best practices dictate enforcing an expiration horizon of two to five
years on the master key, subject to manual renewal.[^26]
Subkeys, which handle active daily workloads and face significantly
higher exposure vectors across multiple devices, should operate on
strict annual or bi-annual expiration cycles.[^26]

Applying a hard expiration date serves as an automated fail-safe
mechanism.[^27] If a user loses access to both their operational
subkeys and their encrypted offline master key backup, they permanently
lose the cryptographic ability to officially revoke their identity. An
expiration date ensures that the orphaned keys will naturally age out of
the system and be flagged as invalid by client software, preventing them
from being indefinitely trusted by the ecosystem or used to verify
forged documents years in the future.[^27]

Key rotation involves generating a new subkey, signing it with the
offline master key, updating the local configuration to utilize the new
subkey, and distributing the updated public certificate to relevant
keyservers and peers.[^30] Because the newly generated subkey is
cryptographically endorsed by the established master key, the user's Web
of Trust reputation seamlessly transfers to the new subkey without
requiring the user to attend a new key signing party.[^17]
Modern enterprise environments enforce automated rotation schedules
using centralized key management systems to reduce human error and
ensure perfect forward secrecy—guaranteeing that the hypothetical future
compromise of a contemporary subkey cannot retroactively decrypt
historical data previously protected by older, expired
subkeys.[^4]

### Revocation Strategies and Contingency Planning

If a private subkey is exposed to malware, a hardware token is lost in
transit, or a master key's offline storage is physically breached,
immediate and decisive revocation is required.[^33] Revocation
is achieved by issuing a specialized cryptographic packet—a revocation
certificate—which informs the global keyserver network, Web Key
Directories, and local peers that the key is permanently invalidated and
should no longer be used for encryption or signature
verification.[^33]

Because a compromised master key cannot be reliably trusted to issue a
valid revocation during an active incident, the revocation certificate
must be generated immediately upon the initial creation of the master
key pair.[^34] This pre-generated certificate is stored in a
separate, highly secure physical location (often printed physically as a
high-density QR code or stored on an encrypted cold-storage medium
separate from the master key backups).[^13] In an emergency, the
user publishes this pre-calculated certificate to keys.openpgp.org and
other directories, immediately neutralizing the compromised key block
and alerting all communicating parties to halt data
transmission.[^4] Signatures verified prior to the revocation
timestamp remain cryptographically valid, ensuring historical archives
are not corrupted, but any data signed post-revocation is immediately
flagged as highly suspect.[^33]

## Hardware Security Modules: The OpenPGP Card Standard and Token Ecosystem

Even with the master key securely air-gapped, storing active daily-use
subkeys on a computer's local hard drive or within the operating
system's software keyring exposes them to sophisticated malware, memory
scraping, and unauthorized extraction.[^13] To definitively
mitigate these software-based exfiltration vectors, modern cryptographic
implementations strictly mandate transferring the private subkeys to a
hardware security module.

### The OpenPGP Smart Card Specification

Rather than relying on proprietary interfaces, the OpenPGP ecosystem
leverages the OpenPGP Card specification, an ISO/IEC 7816-4 and -8
compatible smart card standard. This standard defines a specialized,
tamper-resistant cryptographic co-processor specifically designed to
store three distinct subkeys concurrently (Signature, Encryption, and
Authentication). Once a private key is imported onto the secure element
of an OpenPGP-compliant device, the protocol enforces a strict security
boundary: the private keys and passwords can never be extracted, copied,
or read back to the host machine by any command. All cryptographic
operations occur directly on the silicon of the card itself, isolating
the key from the host operating system entirely.[^18] Modern
iterations of the specification, such as version 3.4, include robust
support for Elliptic Curve Cryptography (ECC), notably Curve25519
(Ed25519), which drastically improves signing speed on the constrained
smart card processors compared to computationally heavy legacy RSA keys.

### The Hardware Ecosystem: YubiKey, Nitrokey, Librem Key, and SoloKeys

Several manufacturers implement the OpenPGP Card specification, allowing
users to select hardware that best aligns with their threat model and
open-source philosophy:

- **YubiKey:** Manufactured by Yubico, the YubiKey 5 series is the most
  ubiquitous and widely supported token on the market. While its OpenPGP
  applet was historically open source, modern YubiKeys utilize a
  single-chip design with proprietary, closed-source firmware that
  cannot be audited by end-users or modified after manufacturing.
  However, they offer unparalleled operational reliability, broad
  platform compatibility, and multi-protocol support.

- **Nitrokey:** For privacy purists and users requiring transparent
  security, Nitrokey provides devices (like the Nitrokey 3) with fully
  open-source hardware and firmware. This transparency ensures that the
  cryptographic implementation can be independently audited for
  backdoors, aligning perfectly with the ethos of the OpenPGP community.

- **Librem Key:** Produced by Purism, the Librem Key is fundamentally
  based on the open-source Nitrokey Pro 2. However, it adds a unique
  layer of security by integrating heavily with the "Heads" firmware to
  provide a "trusted boot" process. If a Purism laptop's BIOS or
  firmware is tampered with, an LED on the Librem Key blinks red instead
  of green during boot, providing a physical, visual cryptographic
  attestation of system integrity alongside its standard OpenPGP
  capabilities.

- **SoloKeys:** While SoloKeys offers well-regarded open-source FIDO2
  tokens, their implementation of the OpenPGP Card standard has
  historically lagged in reliability and complete feature parity (such
  as full out-of-the-box Ed25519 support on early models), making them
  less suitable for dedicated GnuPG setups compared to YubiKey or
  Nitrokey.

### The Universal Provisioning Methodology

The most secure deployment protocol for any OpenPGP Card, formalized by
security researchers and widely adopted as the definitive "Dr. Duh
guide" standard, dictates a meticulous procedure for hardware
provisioning.[^13] A critical tenet of this methodology is that
keys should never be generated directly on the smart card
itself.[^13] While on-card generation ensures the private key
never touches a host operating system, it completely prevents the
creation of encrypted backups. Should the physical token be lost,
stolen, or destroyed, all encrypted data becomes permanently
unrecoverable, resulting in catastrophic data loss.[^13]

Instead, the provisioning process begins by booting a secure, air-gapped
live operating system (such as Tails or a stripped Debian environment)
running entirely in volatile memory (RAM) with all network interfaces
disabled.[^18] Within this sterile environment, the
administrator generates the master key and subkeys, immediately backing
them up to secure offline storage (e.g., encrypted USB flash
drives).[^13] Following the backup verification, the keytocard
command is executed within the interactive GnuPG interface, moving the
subkeys sequentially into their designated slots on the OpenPGP smart
card.[^9] Once the keytocard operation concludes, GnuPG
automatically replaces the local private keys with stubs that point to
the hardware device, ensuring the local machine contains no sensitive
key material.[^22] The volatile memory is then wiped, leaving
the hardware token as the sole active cryptographic agent.[^18]

### Hardware Configuration, PINs, and Touch-to-Sign Policies

Effective hardware deployment requires specific configurations to
prevent unauthorized physical and logical access. The OpenPGP smart card
standard defines three distinct PINs: the User PIN (default 123456), the
Admin PIN (default 12345678), and an optional Reset Code. The Admin PIN
is required to alter card attributes, whereas the User PIN authorizes
daily cryptographic operations.[^9]

By default, most OpenPGP cards permit three incorrect User PIN attempts
before locking the card, requiring the Admin PIN to unblock
it.[^36] Administrators can expand this threshold using the
GnuPG --card-edit interface or vendor-specific utilities (like ykman for
YubiKey or nitropy for Nitrokey) to prevent accidental lockouts during
routine use.

A critical hardware hardening measure introduced in recent hardware
iterations is the "Touch-to-Sign" policy. By default, if a token is left
plugged into a compromised workstation, malware could theoretically
submit payloads to the card for signing without the user's
knowledge.[^35] Using vendor tools, administrators can configure
the token to require physical, capacitive touch for every single
cryptographic operation.[^36] This ensures that even if an
attacker successfully compromises the host operating system and captures
the User PIN via a software keylogger, they cannot silently forge Git
code commits or decrypt files in the background, as the hardware
strictly enforces physical human presence verification before executing
the cryptographic instruction.[^35]

Integrating this hardware setup with developer workflows requires
precise configuration. To enable code signing with Git and GitHub,
developers must export their public key (gpg --export --armor) and
upload it to the platform's settings.[^22] Locally, the Git
configuration is updated to point to the subkey ID (git config --global
user.signingkey) and enforce mandatory signing (git config --global
commit.gpgsign true).[^22] This ensures that every line of code
submitted to the repository is cryptographically bound to the
developer's hardware-backed identity, mitigating the risk of supply
chain attacks.[^22]

## Federated Discoverability: The Transition from SKS to WKD and Hagrid

For public-key cryptography to function seamlessly at an enterprise or
global scale, users must possess a reliable, secure mechanism to locate
the public keys of their correspondents. The infrastructure facilitating
this discovery has undergone a necessary paradigm shift, transitioning
from vulnerable, decentralized synchronization networks to verified,
federated directories.[^40]

### The Collapse of the SKS Keyserver Network

Historically, public keys were distributed and synchronized via the
Synchronizing Key Server (SKS) network, a globally distributed cluster
of servers that shared keys using an append-only gossip
protocol.[^42] Because OpenPGP certificates are essentially
blocks of data upon which any third party can append a cryptographic
signature (in the form of trust endorsements or new UIDs), the SKS
network's append-only nature introduced a catastrophic architectural
vulnerability.[^41]

In 2019, malicious actors launched massive certificate poisoning attacks
against the SKS network.[^41] Attackers flooded high-profile
public keys (such as those belonging to kernel developers and privacy
advocates) with hundreds of thousands of arbitrary, mathematically valid
but useless signatures. When clients attempted to fetch or refresh these
poisoned keys via gpg --refresh-keys, the massive data bloat (often
exceeding several megabytes per key) caused GnuPG to crash, hang
indefinitely, or exhaust system resources.[^41] The lack of a
centralized moderation authority or a cryptographic deletion mechanism
within the SKS gossip protocol rendered the network unrecoverable,
leading to its effective abandonment by the global security
community.[^41]

### The Hagrid Architecture and keys.openpgp.org

The definitive successor to the compromised SKS network is
keys.openpgp.org, a modern keyserver built on the highly resilient
Hagrid software architecture and the Sequoia-PGP library.[^40]
Hagrid structurally mitigates poisoning attacks and data privacy
concerns by fundamentally separating the technical cryptographic
material (the public key numbers) from identity information (the UIDs
containing names and email addresses).[^40]

Upon receiving an uploaded key via the native Verifying Keyserver (VKS)
interface or a standard gpg --send-keys command, Hagrid immediately
strips all UIDs and third-party signatures from the key
block.[^40] The server then requires the uploader to undergo a
strict, consent-driven verification process, sending an encrypted
cryptographic challenge to the email address listed in the
UID.[^40] Only after the owner receives the email and clicks the
verification link to prove control of the address is the UID
mathematically re-attached to the public key and made
searchable.[^40]

This mechanism ensures high data fidelity, completely eliminates the
threat of key poisoning, and actively prevents the mass harvesting of
email addresses for spam, as the API rigorously restricts searches to
exact email matches rather than wildcard queries.[^45] Users
migrating to keys.openpgp.org occasionally encounter a gpg: key: no user
ID error during routine imports.[^48] This occurs when GnuPG
fetches a key where the owner has uploaded the cryptographic material
but has not yet completed the email verification consent loop, resulting
in the keyserver delivering a stripped, anonymous key
packet.[^48] The resolution involves the key owner navigating to
the web interface and completing the verification process.[^49]
To integrate this secure directory, users append keyserver
hkps://keys.openpgp.org to their dirmngr.conf file, replacing legacy SKS
pools.[^41]

### Implementing the Web Key Directory (WKD)

While keys.openpgp.org relies on an independent service infrastructure,
the Web Key Directory (WKD) protocol represents the pinnacle of
decentralized, federated key discovery, granting domain owners absolute
sovereignty over their cryptographic directories.[^54] WKD
leverages the Domain Name System (DNS) and standard HTTPS web servers to
allow email clients (like Thunderbird or GpgOL) to automatically
discover a recipient's public key simply by querying the domain of their
email address, seamlessly bridging the gap between email routing and
cryptographic key distribution.[^54]

When a user executes gpg --locate-keys <alice&#64;example.com>, the WKD client
automatically hashes the local part of the email ("alice") using a
specialized SHA-1 z-Base-32 encoding format.[^54] The client
then constructs a specific Uniform Resource Identifier (URI) to query
the domain. WKD supports two implementation methods:

| **WKD Implementation Method** | **Hosting URI Structure**                                                       | **DNS and Infrastructure Requirements**                                                  |
| ----------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Direct Method**             | <https://example.com/.well-known/openpgpkey/hu/\[hash\>]                        | Requires an empty DNS TXT record for openpgpkey to prevent client fallback delays.[^54]  |
| **Advanced Method**           | <https://openpgpkey.example.com/.well-known/openpgpkey/example.com/hu/\[hash\>] | Requires a CNAME or A Record delegating the openpgpkey subdomain to the web server.[^54] |

Setting up a WKD for a custom domain involves generating the hashed key
files using tools like gpg-wks-client --print-wkd-hash or the command
gpg --with-wkd-hash --fingerprint.[^54] The administrator must
export the public keys in raw binary format (explicitly without ASCII
armor, using --no-armor) and name the resulting file precisely as the
generated hash.[^54] These binary files are then placed into the
.well-known/openpgpkey/hu/ directory structure on the domain's web
server.[^54]

Crucially, the web server (e.g., Nginx, Apache, or Caddy) must be
meticulously configured to serve these files with an
application/octet-stream MIME type and implement an
Access-Control-Allow-Origin: \* HTTP header.[^54] This header
satisfies Cross-Origin Resource Sharing (CORS) requirements, allowing
web-based email clients and external applications to fetch the keys
securely.[^54] Furthermore, directory listing must be strictly
disabled to prevent directory traversal attacks.[^54] WKD
integration guarantees that the organization controlling the domain
explicitly authorizes the keys associated with its email addresses,
providing a powerful, authenticated alternative to third-party
keyservers.[^54]

## Trust Paradigms: The Web of Trust versus Trust on First Use (TOFU)

Cryptography mathematically secures the envelope of a message, ensuring
it has not been altered in transit and that only the possessor of the
private key can decrypt it.[^4] However, raw cryptography does
not inherently prove the human identity of the sender.[^60]
OpenPGP resolves the complex problem of identity verification through
distinct, evolving trust models: the legacy Web of Trust (WoT) and the
modern Trust on First Use (TOFU) heuristic.[^2]

### The Mechanics of the Web of Trust (WoT)

The Web of Trust is a decentralized, directed mathematical graph of
trust relationships, serving as a robust, peer-to-peer alternative to
centralized Public Key Infrastructure (PKI) models that rely exclusively
on monolithic Certificate Authorities.[^2] In the WoT, users
cryptographically sign each other's public keys, formally endorsing the
binding between the cryptographic material and the human identity (the
UID).[^2]

GnuPG quantifies this complex graph using a specific calculus based on
two interrelated metrics: "Validity" and "Ownertrust." Validity is an
objective measure of the systemic confidence that a key belongs to its
claimed owner, calculated by evaluating the cryptographic signatures
attached to that key.[^61] Ownertrust, conversely, is a highly
subjective value assigned by the local user to a specific key in their
keyring, indicating how much they trust that individual to correctly and
rigorously verify other people's identities before signing their
keys.[^62]

GnuPG defines distinct trust levels that a user can assign:

- **Ultimate**: Reserved exclusively for the user's own, personally
  generated keys. Any key signed by an ultimately trusted key is
  automatically considered fully valid by the local system.[^62]

- **Full**: Assigned to highly trusted introducers. If a fully trusted
  key signs a third party's key, the local system automatically
  considers the third party's key valid, extending the trust
  perimeter.[^62]

- **Marginal**: Assigned to individuals with moderate reliability. The
  system mathematically requires valid signatures from at least three
  distinct marginally trusted keys to validate a newly discovered
  key.[^61]

- **Unknown / Undefined**: The default state upon importing a new key.
  The user has not assigned a trust value, and the key's signatures
  carry absolutely no weight in calculating the validity of other
  keys.[^62]

- **Never**: Explicitly untrusted. Signatures originating from this key
  are ignored by the validity engine entirely.[^62]

To accommodate large organizational hierarchies and complex enterprises,
the WoT supports Trust Delegation using Meta-Introducers. A senior
administrator can assign "Level 2" or "Level 3" trust depth to a
manager's key, allowing that entity not only to validate subordinate
keys but to delegate trust authority to others downstream, effectively
creating localized, highly controlled certificate authorities within the
broader decentralized web.[^61]

### Trust on First Use (TOFU) Implementation

Despite its mathematical robustness and decentralized purity, the Web of
Trust suffers from severe usability limitations in practice. Maintaining
the graph requires active participation in key signing, meticulous
management of local trust settings, and constant manual
verification—practices that are often neglected outside of highly
specialized cryptographic engineering enclaves.[^5]

To bridge this usability gap and provide immediate security benefits to
standard users, modern GnuPG implementations integrate the Trust on
First Use (TOFU) policy.[^5] Conceptually similar to the
security mechanism utilized by SSH host keys, TOFU assumes that the
first key associated with a specific email address is valid and securely
memorizes this exact binding in a local database.[^66]

If the system later encounters a different cryptographic key asserting
ownership of that same email address, GnuPG immediately triggers a
conflict detection algorithm.[^66] The user receives an
aggressive, detailed warning describing the conflict and presenting
statistical anomalies—such as the number of messages previously verified
using the original key over a specific timeframe.[^5] This
alerts the user to a potential man-in-the-middle (MitM) attack, a forged
identity, or an improper key rotation by the sender.[^5]

Administrators can enforce granular TOFU policies via the --tofu-policy
flag—selecting among auto, good, unknown, bad, and ask—dictating
precisely how the system handles initial key imports and subsequent
conflicts.[^66] While TOFU lacks the rigorous, out-of-band
identity guarantees of the WoT, it provides a highly automated, reactive
defense against impersonation with vastly reduced user friction, making
it the preferred model for daily corporate communications.[^5]

## The Key Signing Party: Orchestration, Execution, and Cryptographic Ratification

The structural integrity of the Web of Trust relies entirely on the
rigorous verification of offline identities before applying
cryptographic signatures.[^61] To facilitate this critical
process efficiently, security professionals, software developers, and
CSIRT (Computer Security Incident Response Team) members frequently host
and attend Key Signing Parties—highly structured, in-person events
designed for mass identity verification and decentralized key
validation.[^60]

The protocol governing these events is meticulous, purposefully designed
to eliminate social engineering, mitigate the "peer pressure" of
immediate, unverified signing, and ensure that digital identities are
conclusively linked to government-issued physical
documentation.[^15]

### Pre-Event Preparation and Organizer Responsibilities

Coordination begins well before the physical gathering. Participants
must submit their OpenPGP public key fingerprints (usually extracted via
gpg --fingerprint) to the event organizer, often via an encrypted email
or a dedicated secure submission portal, prior to a strict cutoff
deadline.[^68] The organizer aggregates these fingerprints,
along with the corresponding names and email addresses, into a
standardized master text file.[^68] During this aggregation, the
organizer must respect privacy requests; if a participant indicates
their email address should not be exposed to the public, the organizer
must clearly mark or redact this in the details.[^60]

Once the cutoff is reached, the organizer distributes the master list to
all attendees via email.[^70] Crucially, each participant must
independently download this file at home, verify that their own
fingerprint is represented correctly, and compute a cryptographic hash
of the entire text file using a standard algorithm, typically SHA-256
(sha256sum list.txt).[^70] The attendee prints this list onto
physical paper and manually writes down the computed SHA-256 hash to
bring to the venue.[^68] Furthermore, participants are
instructed to bring a government-issued photo ID (e.g., passport,
national ID card) and a pen.[^15] In strict adherence to
security protocols, participants are explicitly forbidden from bringing
laptops, tablets, or operating computers during the ceremony to prevent
chaotic, on-the-fly digital signing or malware
distribution.[^60]

### Event Execution and In-Person Validation

The key signing party commences with a formal information session where
the organizer publicly announces the official, organizer-calculated
SHA-256 hash of the master list.[^70] Every participant checks
this verbally announced hash against the hash they calculated at
home.[^70] If the hashes match seamlessly across the room, it
proves mathematically that every single person holds an identical,
unmanipulated copy of the fingerprint list, defeating any localized
attempts to inject fraudulent keys into the roster.[^70]

Following the hash verification, the orchestration shifts to identity
confirmation. Attendees typically form a continuous line or a circle.
When two attendees meet, they execute a strict validation protocol:

1. They confirm mutually that their list hashes matched the official
   hash.[^70]

2. They confirm verbally that their own fingerprint is printed
   correctly on the list.[^70]

3. They meticulously examine each other's physical government-issued
   identification to verify the name associated with the
   key.[^15]

If the physical ID matches the name printed on the list next to the
corresponding fingerprint, the attendee places a checkmark or writes
"valid" on their physical paper copy.[^15] This process
continues methodically until all attendees have verified one
another.[^60] The physical paper, now containing authenticated
checkmarks, represents the cryptographically verified, offline ledger of
identities.[^68]

### Post-Event Signing and Asynchronous Verification Tools

In accordance with strict security policies, absolutely no digital
signing occurs at the physical venue.[^68] Upon returning to a
secure, trusted environment (such as a home office), participants
retrieve their air-gapped master keys or hardware security
modules.[^70] They review their annotated paper list and
download the public keys corresponding to the checked fingerprints from
WKD or keyservers (gpg --recv-keys).[^72]

Rather than manually signing a key and directly uploading it to a public
directory—which could expose an email address without consent—best
practices dictate utilizing specialized signing software tools, such as
caff (part of the Debian signing-party package) or pius (PGP Individual
User Signer).[^70] These automated tools execute a highly secure
protocol:

1. They download the target's public key into an isolated, temporary
   keyring to prevent contamination of the local database with
   unverified signatures.[^73]

2. The user signs the individual UIDs on the key using their master key
   (gpg --sign-key).[^73]

3. The software automatically encrypts the newly generated signature
   _using the target's own public key_ (gpg -se -r).[^73]

4. The encrypted signature is emailed directly to the address listed in
   the specific UID.[^73]

This methodology acts as an ingenious secondary layer of authentication.
By encrypting the signature, the sender ensures that the recipient truly
possesses the private key corresponding to the public key they presented
at the party.[^73] If the recipient cannot decrypt the email,
they cannot access the signature. Furthermore, emailing the signature
instead of uploading it directly to a keyserver ensures that the
recipient retains full sovereign control over their key's
publication.[^73] The recipient decrypts the incoming signature,
merges it into their local keyring (gpg --import), and autonomously
uploads their highly certified key to a directory like WKD or
keys.openpgp.org.[^73]

## Advanced Deployments: File Operations and Post-Quantum Preparedness

Beyond identity management, the practical application of OpenPGP keys
involves securing data at rest and in transit. Using the command line,
users can execute gpg --clearsign \[file\] to attach a verifiable
digital signature to a text document, ensuring its integrity without
encrypting the contents—ideal for publishing public announcements or
software checksums.[^76] For complete confidentiality, gpg
--encrypt --recipient \[email\]\[file\] utilizes the recipient's public
encryption subkey to mathematically seal the document.[^4] Best
practices for file transfers emphasize a hybrid approach: signing the
document with the sender's private key to prove origin, and encrypting
it with the recipient's public key to ensure confidentiality, a process
automated by gpg --sign --encrypt.[^76]

As the cryptographic community looks toward the future, the integration
of Post-Quantum Cryptography (PQC) has become a paramount concern. As of
2026, it is widely recognized that both traditional RSA algorithms and
modern ECC algorithms (like Ed25519) are theoretically vulnerable to
sufficiently powerful quantum computers utilizing Shor's
algorithm.[^4] Consequently, forward-thinking organizations are
implementing hybrid cryptographic models within their OpenPGP
architectures.[^4] This involves combining classical algorithms
like Ed25519 with quantum-resistant algorithms within the same OpenPGP
certificate structure.[^4] This layered approach ensures that
even if a quantum breakthrough shatters classical elliptic curves, the
underlying data remains secure, future-proofing encrypted communications
and historic archives against retrospective decryption attacks ("harvest
now, decrypt later").[^4]

The architecture of OpenPGP has matured from a rudimentary cipher
framework into a highly resilient, globally federated system of
cryptographic trust. Operating securely within this complex ecosystem
requires the rigorous application of defined best practices: utilizing
Ed25519 for optimized security, strictly segregating offline master keys
from hardware-bound ephemeral subkeys, replacing fragile keyserver
synchronization with robust protocols like WKD and Hagrid, and
diligently validating identities through structured Key Signing Parties.
By integrating these technical mechanisms with rigorous operational
discipline, organizations and individuals can maintain impregnable
communications and sovereign digital identities in an increasingly
hostile network environment.

#### Works cited

1. The GNU Privacy Handbook - GnuPG, accessed April 24, 2026, [https://www.gnupg.org/gph/en/manual.html](https://www.gnupg.org/gph/en/manual.html)
2. Web of trust - Wikipedia, accessed April 24, 2026, [https://en.wikipedia.org/wiki/Web_of_trust](https://en.wikipedia.org/wiki/Web_of_trust)
3. How Does PGP Encryption Work—and Is It Still Secure in 2025? - SecurityScorecard, accessed April 24, 2026, [https://securityscorecard.com/blog/how-does-pgp-encryption-work-and-is-it-still-secure-in-2025/](https://securityscorecard.com/blog/how-does-pgp-encryption-work-and-is-it-still-secure-in-2025/)
4. PGP Encryption in Application Security: Still Relevant in 2025?, accessed April 24, 2026, [https://www.appsecure.security/blog/pgp-encryption-in-application-security-2025](https://www.appsecure.security/blog/pgp-encryption-in-application-security-2025)
5. TOFU for OpenPGP - GnuPG, accessed April 24, 2026, [https://gnupg.org/ftp/people/neal/tofu.pdf](https://gnupg.org/ftp/people/neal/tofu.pdf)
6. SSH Keys in 2024: Why Ed25519 Replaced RSA as the Default - DEV Community, accessed April 24, 2026, [https://dev.to/theisraelolaleye/ssh-keys-in-2024-why-ed25519-replaced-rsa-as-the-default-47aa](https://dev.to/theisraelolaleye/ssh-keys-in-2024-why-ed25519-replaced-rsa-as-the-default-47aa)
7. RSA vs Ed25519: Which Key Pair Is Right for Your Security Needs? - GeeksforGeeks, accessed April 24, 2026, [https://www.geeksforgeeks.org/devops/rsa-vs-ed25519-which-key-pair-is-right-for-your-security-needs/](https://www.geeksforgeeks.org/devops/rsa-vs-ed25519-which-key-pair-is-right-for-your-security-needs/)
8. Developers Guide to GPG and YubiKey, accessed April 24, 2026, [https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg](https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg)
9. SSH Key Best Practices for 2025 - Using ed25519, key rotation, and other best practices, accessed April 24, 2026, [https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025](https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025)
10. GPG Quickstart Guide . I recently discovered GPG and how… \| by Anton Paras \| Medium, accessed April 24, 2026, <https://medium.com/@acparas/gpg-quickstart-guide-d01f005ca99>
11. Setup of YubiKey PGP module - rynkowski, accessed April 24, 2026, [https://rynkowski.pl/en/posts/setup-of-yubikey-pgp-module/](https://rynkowski.pl/en/posts/setup-of-yubikey-pgp-module/)
12. Key Management - GnuPG, accessed April 24, 2026, [https://www.gnupg.org/gph/en/manual/c235.html](https://www.gnupg.org/gph/en/manual/c235.html)
13. Hosting a successful GPG Keysigning Party - Techwolf12, accessed April 24, 2026, [https://techwolf12.nl/blog/hosting-successful-gpg-keysigning-party/](https://techwolf12.nl/blog/hosting-successful-gpg-keysigning-party/)
14. What is the relationship between an OpenPGP key and its subkey? - Super User, accessed April 24, 2026, [https://superuser.com/questions/1113308/what-is-the-relationship-between-an-openpgp-key-and-its-subkey](https://superuser.com/questions/1113308/what-is-the-relationship-between-an-openpgp-key-and-its-subkey)
15. GPG - why am I encrypting with subkey instead of primary key? - Server Fault, accessed April 24, 2026, [https://serverfault.com/questions/397973/gpg-why-am-i-encrypting-with-subkey-instead-of-primary-key](https://serverfault.com/questions/397973/gpg-why-am-i-encrypting-with-subkey-instead-of-primary-key)
16. Creating GPG keys with YubiKey (HOWTO) - Trent's blog, accessed April 24, 2026, [https://murgatroyd.za.net/?p=409](https://murgatroyd.za.net/?p=409)
17. Key Management, accessed April 24, 2026, [https://iwayinfocenter.informationbuilders.com/TLs/TL_soa_ism_pgp/source/intro11_pgp.htm](https://iwayinfocenter.informationbuilders.com/TLs/TL_soa_ism_pgp/source/intro11_pgp.htm)
18. A No-Nonsense Guide to GPG Commit Signing with a YubiKey \| Ryan Spletzer, accessed April 24, 2026, [https://www.spletzer.com/2026/04/a-no-nonsense-guide-to-gpg-commit-signing-with-a-yubikey/](https://www.spletzer.com/2026/04/a-no-nonsense-guide-to-gpg-commit-signing-with-a-yubikey/)
19. How many OpenPGP keys should I make? - Information Security Stack Exchange, accessed April 24, 2026, [https://security.stackexchange.com/questions/29851/how-many-openpgp-keys-should-i-make](https://security.stackexchange.com/questions/29851/how-many-openpgp-keys-should-i-make)
20. Using PGP capabilities but separate identities. : r/yubikey - Reddit, accessed April 24, 2026, [https://www.reddit.com/r/yubikey/comments/1lcvj61/using_pgp_capabilities_but_separate_identities/](https://www.reddit.com/r/yubikey/comments/1lcvj61/using_pgp_capabilities_but_separate_identities/)
21. Multiple uid's vs. multiple primary keys & "master signing keys" - GnuPG and GNUTLS Mailing List Archives, accessed April 24, 2026, [https://lists.gnupg.org/pipermail/gnupg-users/2008-June/033793.html](https://lists.gnupg.org/pipermail/gnupg-users/2008-June/033793.html)
22. Seeking Guidance For The Best Practices for Managing Multiple GPG Keys - General, accessed April 24, 2026, [https://forum.gnupg.org/t/seeking-guidance-for-the-best-practices-for-managing-multiple-gpg-keys/4900](https://forum.gnupg.org/t/seeking-guidance-for-the-best-practices-for-managing-multiple-gpg-keys/4900)
23. How to create GPG keypairs - Red Hat, accessed April 24, 2026, [https://www.redhat.com/en/blog/creating-gpg-keypairs](https://www.redhat.com/en/blog/creating-gpg-keypairs)
24. PGP encryption subkeys are less useful than I thought - ZeroIndexed, accessed April 24, 2026, [https://zeroindexed.com/pgp-encryption-subkeys](https://zeroindexed.com/pgp-encryption-subkeys)
25. Should I create separate GPG key pairs or just one GPG key pair for multiple uses (e.g. email, sign commits)?, accessed April 24, 2026, [https://superuser.com/questions/1683772/should-i-create-separate-gpg-key-pairs-or-just-one-gpg-key-pair-for-multiple-use](https://superuser.com/questions/1683772/should-i-create-separate-gpg-key-pairs-or-just-one-gpg-key-pair-for-multiple-use)
26. Encryption Best Practices 2025: Guide to Data Protection - Training Camp, accessed April 24, 2026, [https://trainingcamp.com/articles/encryption-best-practices-2025-complete-guide-to-data-protection-standards-and-implementation/](https://trainingcamp.com/articles/encryption-best-practices-2025-complete-guide-to-data-protection-standards-and-implementation/)
27. Rotating my PGP key - Ruud van Asseldonk, accessed April 24, 2026, [https://ruudvanasseldonk.com/2025/rotating-my-pgp-key](https://ruudvanasseldonk.com/2025/rotating-my-pgp-key)
28. Comprehensive Yet Simple Guide for GPG Key/Subkey Encryption, Signing, Verification & Other Common Operations - Medium, accessed April 24, 2026, [https://medium.com/code-oil/comprehensive-yet-simple-guide-for-gpg-key-subkey-encryption-signing-verification-other-common-c28fd868cbe7](https://medium.com/code-oil/comprehensive-yet-simple-guide-for-gpg-key-subkey-encryption-signing-verification-other-common-c28fd868cbe7)
29. drduh/YubiKey-Guide: Community guide to using YubiKey ... - GitHub, accessed April 24, 2026, [https://github.com/drduh/yubikey-guide](https://github.com/drduh/yubikey-guide)
30. YubiKey GPG + GitHub setup, accessed April 24, 2026, [https://gist.github.com/bhouse/fbf3d62825a9f4df86e9267476fc2079](https://gist.github.com/bhouse/fbf3d62825a9f4df86e9267476fc2079)
31. keys.openpgp.org, accessed April 24, 2026, [https://keys.openpgp.org/about](https://keys.openpgp.org/about)
32. SKS Keyserver Network Under Attack - GitHub Gist, accessed April 24, 2026, [https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f)
33. A Protocol for Solving Certificate Poisoning for the OpenPGP Keyserver Network - Journals, accessed April 24, 2026, [https://journals-sol.sbc.org.br/index.php/jisa/article/download/3810/2678](https://journals-sol.sbc.org.br/index.php/jisa/article/download/3810/2678)
34. FAQ - keys.openpgp.org, accessed April 24, 2026, [https://keys.openpgp.org/about/faq/](https://keys.openpgp.org/about/faq/)
35. Usage: GnuPG - keys.openpgp.org, accessed April 24, 2026, [https://keys.openpgp.org/about/usage-gnupg/](https://keys.openpgp.org/about/usage-gnupg/)
36. gpg: key 3804BB82D39DC0E3: new key but contains no user ID - skipped · Issue \#5121 · rvm/rvm - GitHub, accessed April 24, 2026, [https://github.com/rvm/rvm/issues/5121](https://github.com/rvm/rvm/issues/5121)
37. WKDHosting - GnuPG wiki, accessed April 24, 2026, [https://wiki.gnupg.org/WKDHosting](https://wiki.gnupg.org/WKDHosting)
38. PGP/GnuPG Key Signing Party - Forum of Incident Response and Security Teams (FIRST), accessed April 24, 2026, [https://www.first.org/pgp/PGP-GnuPG_Key_Signing_Party_v1.0.pdf](https://www.first.org/pgp/PGP-GnuPG_Key_Signing_Party_v1.0.pdf)
39. PGP Web of Trust: Delegated Trust and Keyservers - Linux Foundation, accessed April 24, 2026, [https://www.linuxfoundation.org/blog/blog/pgp-web-of-trust-delegated-trust-and-keyservers](https://www.linuxfoundation.org/blog/blog/pgp-web-of-trust-delegated-trust-and-keyservers)
40. What is Ownertrust? Trust-levels explained / FAQ / Knowledge Base - GPGTools Support, accessed April 24, 2026, [https://gpgtools.tenderapp.com/kb/faq/what-is-ownertrust-trust-levels-explained](https://gpgtools.tenderapp.com/kb/faq/what-is-ownertrust-trust-levels-explained)
41. GPG Configuration Options (Using the GNU Privacy Guard), accessed April 24, 2026, [https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
42. Key-signing party \| Tristan Miller, accessed April 24, 2026, [https://logological.org/keysigning](https://logological.org/keysigning)
43. Key-signing party - DebConf25, accessed April 24, 2026, [https://debconf25.debconf.org/about/ksp/](https://debconf25.debconf.org/about/ksp/)
44. CS50 Key-Signing Party Event Guide, accessed April 24, 2026, [http://www.cs.cmu.edu/~davide/cs50ksp/event.html](http://www.cs.cmu.edu/~davide/cs50ksp/event.html)
45. Signing someone's GPG key - GitHub Gist, accessed April 24, 2026, [https://gist.github.com/F21/b0e8c62c49dfab267ff1d0c6af39ab84](https://gist.github.com/F21/b0e8c62c49dfab267ff1d0c6af39ab84)
46. Pgp: A Comprehensive Guide for 2025 - シャードコーダー - 100% インビジブル AI コーディング面接コパイロット - Shadecoder, accessed April 24, 2026, [https://www.shadecoder.com/ja/topics/pgp-a-comprehensive-guide-for-2025](https://www.shadecoder.com/ja/topics/pgp-a-comprehensive-guide-for-2025)

#### Additional References (Uncited)

- A Modern and Simple Alternative to GPG: age and the Cryptographic Engineering Behind It, accessed April 24, 2026, <https://fr0stb1rd.gitlab.io/posts/a-modern-and-simple-alternative-to-gpg-age-and-its-cryptographic-engineering/>
- SSH key: rsa vs ed25519 : r/linuxadmin - Reddit, accessed April 24, 2026, <https://www.reddit.com/r/linuxadmin/comments/1oj864k/ssh_key_rsa_vs_ed25519/>
- What is the purpose of subkeys : r/GnuPG - Reddit, accessed April 24, 2026, <https://www.reddit.com/r/GnuPG/comments/136i6ov/what_is_the_purpose_of_subkeys/>
- PGP - Why have separate encryption subkey - Information Security Stack Exchange, accessed April 24, 2026, <https://security.stackexchange.com/questions/43590/pgp-why-have-separate-encryption-subkey/>
- Are there risks to having many uids on my gpg key? - Information Security Stack Exchange, accessed April 24, 2026, <https://security.stackexchange.com/questions/198243/are-there-risks-to-having-many-uids-on-my-gpg-key>
- Explore 8 Best Practices for Cryptographic Key Management - GlobalSign, accessed April 24, 2026, <https://www.globalsign.com/en/blog/8-best-practices-cryptographic-key-management>
- Setup | Yubico, accessed April 24, 2026, <https://www.yubico.com/setup/>
- GPG Agent with a Yubikey for SSH, Code Signing and Passwords - Cal Bryant, accessed April 24, 2026, <https://calbryant.uk/blog/gpg-agent-with-a-yubikey-for-ssh-code-signing-and-passwords/>
- Comparing GitHub Commit Signing Options - Ken Muse, accessed April 24, 2026, <https://www.kenmuse.com/blog/comparing-github-commit-signing-options/>
- Current challenges for the OpenPGP keyserver network - Is there a way forward?, accessed April 24, 2026, <http://ru.iiec.unam.mx/5711/1/debconf.pdf>
- SKS Keyserver Network Under Attack : r/programming - Reddit, accessed April 24, 2026, <https://www.reddit.com/r/programming/comments/c6v900/sks_keyserver_network_under_attack/>
- keys.openpgp.org, accessed April 24, 2026, <https://keys.openpgp.org/>
- Verifying Keyserver (VKS) Interface - keys.openpgp.org, accessed April 24, 2026, <https://keys.openpgp.org/about/api/>
- new key but contains no user ID - skipped : r/GnuPG - Reddit, accessed April 24, 2026, <https://www.reddit.com/r/GnuPG/comments/dpp5ay/new_key_but_contains_no_user_id_skipped/>
- gpg: can't import key: "new key but contains no user ID - skipped", accessed April 24, 2026, <https://superuser.com/questions/1485213/gpg-cant-import-key-new-key-but-contains-no-user-id-skipped>
- GPG keys new key but contains no user ID - Stack Overflow, accessed April 24, 2026, <https://stackoverflow.com/questions/62406350/gpg-keys-new-key-but-contains-no-user-id>
- About | News - keys.openpgp.org, accessed April 24, 2026, <https://keys.openpgp.org/about/news/>
- Usage: WKD as a service - keys.openpgp.org, accessed April 24, 2026, <https://keys.openpgp.org/about/usage-wkd/>
- WKD - GnuPG wiki, accessed April 24, 2026, <https://wiki.gnupg.org/WKD>
- Setting up WKD for self-hosted automatic key discovery - GitHub Gist, accessed April 24, 2026, <https://gist.github.com/kafene/0a6e259996862d35845784e6e5dbfc79>
- Guide for WKD with Custom Domain without a dedicated Webserver : r/ProtonMail - Reddit, accessed April 24, 2026, <https://www.reddit.com/r/ProtonMail/comments/gikusp/guide_for_wkd_with_custom_domain_without_a/>
- Setting up Web Key Directory - Jonatan Miarecki, accessed April 24, 2026, <https://miarecki.eu/posts/web-key-directory-setup/>
- Validating other keys on your public keyring - GnuPG, accessed April 24, 2026, <https://www.gnupg.org/gph/en/manual/x334.html>
- PGP Trust Levels and Signature Types Explained - Tek's Domain, accessed April 24, 2026, <https://teknikaldomain.me/post/pgp-trust-levels-and-sig-types-explained/>
- What is the difference between "full" and "ultimate" trust? [duplicate], accessed April 24, 2026, <https://security.stackexchange.com/questions/69062/what-is-the-difference-between-full-and-ultimate-trust>
- How should I choose a trust model in GnuPG? - Information Security Stack Exchange, accessed April 24, 2026, <https://security.stackexchange.com/questions/170721/how-should-i-choose-a-trust-model-in-gnupg>
- PGP/GPG Key-signing - Trusted Introducer, accessed April 24, 2026, <https://www.trusted-introducer.org/transits/transits-1/keysigning/>
- Attending a PGP / GnuPG signing party | GeekWare - Daniel Pecos Martínez, accessed April 24, 2026, <https://danielpecos.com/2024/01/23/attending-a-pgp-gnupg-signing-party/>
- GPG keysigning made easy with Pius - Daniel P. Berrangé, accessed April 24, 2026, <https://www.berrange.com/posts/2012/02/10/gpg-keysigning-made-easy-with-pius/>
- gpg-wks-client - man pages section 1: User Commands, accessed April 24, 2026, <https://docs.oracle.com/cd/E88353_01/html/E37839/gpg-wks-client-1.html>
- This guide explains how to sign and encrypt an email using the `gpg` (GNU Privacy Guard) tool from the command line. - GitHub, accessed April 24, 2026, <https://github.com/pcaversaccio/gpg-sign-and-encrypt>

[^1]:
    The GNU Privacy Handbook - GnuPG, accessed April 24, 2026,
    [https://www.gnupg.org/gph/en/manual.html](https://www.gnupg.org/gph/en/manual.html)

[^2]:
    Web of trust - Wikipedia, accessed April 24, 2026,
    [https://en.wikipedia.org/wiki/Web_of_trust](https://en.wikipedia.org/wiki/Web_of_trust)

[^3]:
    How Does PGP Encryption Work—and Is It Still Secure in 2025? -
    SecurityScorecard, accessed April 24, 2026,
    [https://securityscorecard.com/blog/how-does-pgp-encryption-work-and-is-it-still-secure-in-2025/](https://securityscorecard.com/blog/how-does-pgp-encryption-work-and-is-it-still-secure-in-2025/)

[^4]:
    PGP Encryption in Application Security: Still Relevant in 2025?,
    accessed April 24, 2026,
    [https://www.appsecure.security/blog/pgp-encryption-in-application-security-2025](https://www.appsecure.security/blog/pgp-encryption-in-application-security-2025)

[^5]:
    TOFU for OpenPGP - GnuPG, accessed April 24, 2026,
    [https://gnupg.org/ftp/people/neal/tofu.pdf](https://gnupg.org/ftp/people/neal/tofu.pdf)

[^7]:
    SSH Keys in 2024: Why Ed25519 Replaced RSA as the Default - DEV
    Community, accessed April 24, 2026,
    [https://dev.to/theisraelolaleye/ssh-keys-in-2024-why-ed25519-replaced-rsa-as-the-default-47aa](https://dev.to/theisraelolaleye/ssh-keys-in-2024-why-ed25519-replaced-rsa-as-the-default-47aa)

[^8]:
    RSA vs Ed25519: Which Key Pair Is Right for Your Security Needs? -
    GeeksforGeeks, accessed April 24, 2026,
    [https://www.geeksforgeeks.org/devops/rsa-vs-ed25519-which-key-pair-is-right-for-your-security-needs/](https://www.geeksforgeeks.org/devops/rsa-vs-ed25519-which-key-pair-is-right-for-your-security-needs/)

[^9]:
    Developers Guide to GPG and YubiKey, accessed April 24, 2026,
    [https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg](https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg)

[^10]:
    SSH Key Best Practices for 2025 - Using ed25519, key rotation, and
    other best practices, accessed April 24, 2026,
    [https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025](https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025)

[^12]:
    GPG Quickstart Guide . I recently discovered GPG and how… \| by
    Anton Paras \| Medium, accessed April 24, 2026,
    <https://medium.com/@acparas/gpg-quickstart-guide-d01f005ca99>

[^13]:
    Setup of YubiKey PGP module - rynkowski, accessed April 24, 2026,
    [https://rynkowski.pl/en/posts/setup-of-yubikey-pgp-module/](https://rynkowski.pl/en/posts/setup-of-yubikey-pgp-module/)

[^14]:
    Key Management - GnuPG, accessed April 24, 2026,
    [https://www.gnupg.org/gph/en/manual/c235.html](https://www.gnupg.org/gph/en/manual/c235.html)

[^15]:
    Hosting a successful GPG Keysigning Party - Techwolf12, accessed
    April 24, 2026,
    [https://techwolf12.nl/blog/hosting-successful-gpg-keysigning-party/](https://techwolf12.nl/blog/hosting-successful-gpg-keysigning-party/)

[^16]:
    What is the relationship between an OpenPGP key and its subkey? -
    Super User, accessed April 24, 2026,
    [https://superuser.com/questions/1113308/what-is-the-relationship-between-an-openpgp-key-and-its-subkey](https://superuser.com/questions/1113308/what-is-the-relationship-between-an-openpgp-key-and-its-subkey)

[^17]:
    GPG - why am I encrypting with subkey instead of primary key? -
    Server Fault, accessed April 24, 2026,
    [https://serverfault.com/questions/397973/gpg-why-am-i-encrypting-with-subkey-instead-of-primary-key](https://serverfault.com/questions/397973/gpg-why-am-i-encrypting-with-subkey-instead-of-primary-key)

[^18]:
    Creating GPG keys with YubiKey (HOWTO) - Trent's blog, accessed
    April 24, 2026,
    [https://murgatroyd.za.net/?p=409](https://murgatroyd.za.net/?p=409)

[^20]:
    Key Management, accessed April 24, 2026,
    [https://iwayinfocenter.informationbuilders.com/TLs/TL_soa_ism_pgp/source/intro11_pgp.htm](https://iwayinfocenter.informationbuilders.com/TLs/TL_soa_ism_pgp/source/intro11_pgp.htm)

[^22]:
    A No-Nonsense Guide to GPG Commit Signing with a YubiKey \| Ryan
    Spletzer, accessed April 24, 2026,
    [https://www.spletzer.com/2026/04/a-no-nonsense-guide-to-gpg-commit-signing-with-a-yubikey/](https://www.spletzer.com/2026/04/a-no-nonsense-guide-to-gpg-commit-signing-with-a-yubikey/)

[^23]:
    How many OpenPGP keys should I make? - Information Security Stack
    Exchange, accessed April 24, 2026,
    [https://security.stackexchange.com/questions/29851/how-many-openpgp-keys-should-i-make](https://security.stackexchange.com/questions/29851/how-many-openpgp-keys-should-i-make)

[^24]:
    Using PGP capabilities but separate identities. : r/yubikey -
    Reddit, accessed April 24, 2026,
    [https://www.reddit.com/r/yubikey/comments/1lcvj61/using_pgp_capabilities_but_separate_identities/](https://www.reddit.com/r/yubikey/comments/1lcvj61/using_pgp_capabilities_but_separate_identities/)

[^25]:
    Multiple uid's vs. multiple primary keys & "master signing keys" -
    GnuPG and GNUTLS Mailing List Archives, accessed April 24, 2026,
    [https://lists.gnupg.org/pipermail/gnupg-users/2008-June/033793.html](https://lists.gnupg.org/pipermail/gnupg-users/2008-June/033793.html)

[^26]:
    Seeking Guidance For The Best Practices for Managing Multiple GPG
    Keys - General, accessed April 24, 2026,
    [https://forum.gnupg.org/t/seeking-guidance-for-the-best-practices-for-managing-multiple-gpg-keys/4900](https://forum.gnupg.org/t/seeking-guidance-for-the-best-practices-for-managing-multiple-gpg-keys/4900)

[^27]:
    How to create GPG keypairs - Red Hat, accessed April 24, 2026,
    [https://www.redhat.com/en/blog/creating-gpg-keypairs](https://www.redhat.com/en/blog/creating-gpg-keypairs)

[^29]:
    PGP encryption subkeys are less useful than I thought - ZeroIndexed,
    accessed April 24, 2026,
    [https://zeroindexed.com/pgp-encryption-subkeys](https://zeroindexed.com/pgp-encryption-subkeys)

[^30]:
    Should I create separate GPG key pairs or just one GPG key pair for
    multiple uses (e.g. email, sign commits)?, accessed April 24, 2026,
    [https://superuser.com/questions/1683772/should-i-create-separate-gpg-key-pairs-or-just-one-gpg-key-pair-for-multiple-use](https://superuser.com/questions/1683772/should-i-create-separate-gpg-key-pairs-or-just-one-gpg-key-pair-for-multiple-use)

[^31]:
    Encryption Best Practices 2025: Guide to Data Protection - Training
    Camp, accessed April 24, 2026,
    [https://trainingcamp.com/articles/encryption-best-practices-2025-complete-guide-to-data-protection-standards-and-implementation/](https://trainingcamp.com/articles/encryption-best-practices-2025-complete-guide-to-data-protection-standards-and-implementation/)

[^33]:
    Rotating my PGP key - Ruud van Asseldonk, accessed April 24, 2026,
    [https://ruudvanasseldonk.com/2025/rotating-my-pgp-key](https://ruudvanasseldonk.com/2025/rotating-my-pgp-key)

[^34]:
    Comprehensive Yet Simple Guide for GPG Key/Subkey Encryption,
    Signing, Verification & Other Common Operations - Medium, accessed
    April 24, 2026,
    [https://medium.com/code-oil/comprehensive-yet-simple-guide-for-gpg-key-subkey-encryption-signing-verification-other-common-c28fd868cbe7](https://medium.com/code-oil/comprehensive-yet-simple-guide-for-gpg-key-subkey-encryption-signing-verification-other-common-c28fd868cbe7)

[^35]:
    drduh/YubiKey-Guide: Community guide to using YubiKey ... - GitHub,
    accessed April 24, 2026,
    [https://github.com/drduh/yubikey-guide](https://github.com/drduh/yubikey-guide)

[^36]:
    YubiKey GPG + GitHub setup, accessed April 24, 2026,
    [https://gist.github.com/bhouse/fbf3d62825a9f4df86e9267476fc2079](https://gist.github.com/bhouse/fbf3d62825a9f4df86e9267476fc2079)

[^40]:
    keys.openpgp.org, accessed April 24, 2026,
    [https://keys.openpgp.org/about](https://keys.openpgp.org/about)

[^41]:
    SKS Keyserver Network Under Attack - GitHub Gist, accessed April 24,
    2026,
    [https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f)

[^42]:
    A Protocol for Solving Certificate Poisoning for the OpenPGP
    Keyserver Network - Journals, accessed April 24, 2026,
    [https://journals-sol.sbc.org.br/index.php/jisa/article/download/3810/2678](https://journals-sol.sbc.org.br/index.php/jisa/article/download/3810/2678)

[^45]:
    FAQ - keys.openpgp.org, accessed April 24, 2026,
    [https://keys.openpgp.org/about/faq/](https://keys.openpgp.org/about/faq/)

[^48]:
    Usage: GnuPG - keys.openpgp.org, accessed April 24, 2026,
    [https://keys.openpgp.org/about/usage-gnupg/](https://keys.openpgp.org/about/usage-gnupg/)

[^49]:
    gpg: key 3804BB82D39DC0E3: new key but contains no user ID - skipped
    · Issue \#5121 · rvm/rvm - GitHub, accessed April 24, 2026,
    [https://github.com/rvm/rvm/issues/5121](https://github.com/rvm/rvm/issues/5121)

[^54]:
    WKDHosting - GnuPG wiki, accessed April 24, 2026,
    [https://wiki.gnupg.org/WKDHosting](https://wiki.gnupg.org/WKDHosting)

[^60]:
    PGP/GnuPG Key Signing Party - Forum of Incident Response and
    Security Teams (FIRST), accessed April 24, 2026,
    [https://www.first.org/pgp/PGP-GnuPG_Key_Signing_Party_v1.0.pdf](https://www.first.org/pgp/PGP-GnuPG_Key_Signing_Party_v1.0.pdf)

[^61]:
    PGP Web of Trust: Delegated Trust and Keyservers - Linux Foundation,
    accessed April 24, 2026,
    [https://www.linuxfoundation.org/blog/blog/pgp-web-of-trust-delegated-trust-and-keyservers](https://www.linuxfoundation.org/blog/blog/pgp-web-of-trust-delegated-trust-and-keyservers)

[^62]:
    What is Ownertrust? Trust-levels explained / FAQ / Knowledge Base -
    GPGTools Support, accessed April 24, 2026,
    [https://gpgtools.tenderapp.com/kb/faq/what-is-ownertrust-trust-levels-explained](https://gpgtools.tenderapp.com/kb/faq/what-is-ownertrust-trust-levels-explained)

[^66]:
    GPG Configuration Options (Using the GNU Privacy Guard), accessed
    April 24, 2026,
    [https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)

[^68]:
    Key-signing party \| Tristan Miller, accessed April 24, 2026,
    [https://logological.org/keysigning](https://logological.org/keysigning)

[^70]:
    Key-signing party - DebConf25, accessed April 24, 2026,
    [https://debconf25.debconf.org/about/ksp/](https://debconf25.debconf.org/about/ksp/)

[^72]:
    CS50 Key-Signing Party Event Guide, accessed April 24, 2026,
    [http://www.cs.cmu.edu/~davide/cs50ksp/event.html](http://www.cs.cmu.edu/~davide/cs50ksp/event.html)

[^73]:
    Signing someone's GPG key - GitHub Gist, accessed April 24, 2026,
    [https://gist.github.com/F21/b0e8c62c49dfab267ff1d0c6af39ab84](https://gist.github.com/F21/b0e8c62c49dfab267ff1d0c6af39ab84)

[^76]:
    Pgp: A Comprehensive Guide for 2025 - シャードコーダー - 100%
    インビジブル AI コーディング面接コパイロット - Shadecoder, accessed
    April 24, 2026,
    [https://www.shadecoder.com/ja/topics/pgp-a-comprehensive-guide-for-2025](https://www.shadecoder.com/ja/topics/pgp-a-comprehensive-guide-for-2025)

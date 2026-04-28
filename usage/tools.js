const tools = [
  {
    name: "Thunderbird",
    type: "Email client",
    url: "https://www.thunderbird.net/",
    logo: "images/logos/thunderbird.svg",
    platforms: ["Windows", "macOS", "Linux", "Android"],
    usages: ["Email", "Key management", "Signing & verification", "Key discovery"],
    summary: "A strong default for desktop email because OpenPGP is built in and tied to each mail account.",
    steps: [
      "Open account settings and choose End-to-End Encryption.",
      "Create a new personal key or import an existing private key backup.",
      "Send signed mail first, then test encrypted mail with a known contact."
    ]
  },
  {
    name: "Kleopatra",
    type: "Certificate manager",
    url: "https://apps.kde.org/kleopatra/",
    logo: "images/logos/kde.svg",
    platforms: ["Windows", "Linux"],
    usages: ["Key management", "File encryption", "Signing & verification", "Identity certification"],
    summary: "A visual OpenPGP certificate manager for importing keys, certifying keys, encrypting files, and verifying signatures.",
    steps: [
      "Install through Gpg4win on Windows or your Linux software center.",
      "Import public keys, compare fingerprints, then certify keys you have verified.",
      "Use the file actions to sign, encrypt, decrypt, and verify documents."
    ]
  },
  {
    name: "Gpg4win",
    type: "Windows suite",
    url: "https://www.gpg4win.org/",
    platforms: ["Windows"],
    usages: ["Key management", "File encryption", "Email", "Signing & verification"],
    summary: "The standard Windows OpenPGP bundle, including GnuPG, Kleopatra, and Outlook integration.",
    steps: [
      "Install the suite and keep Kleopatra selected during setup.",
      "Create or import your certificate before exchanging public keys.",
      "Use Kleopatra for files and the mail plugin for supported Outlook workflows."
    ]
  },
  {
    name: "GPG Suite",
    type: "macOS suite",
    url: "https://gpgtools.org/",
    logo: "images/logos/apple.svg",
    platforms: ["macOS"],
    usages: ["Key management", "Email", "File encryption", "Signing & verification", "Key discovery"],
    summary: "macOS-oriented OpenPGP tools for Apple Mail users and people who prefer a native keychain-style interface.",
    steps: [
      "Install the suite and open GPG Keychain.",
      "Create or import your key, then publish or share the public key.",
      "Enable mail integration if you want OpenPGP inside Apple Mail."
    ]
  },
  {
    name: "OpenKeychain",
    type: "Android key manager",
    url: "https://www.openkeychain.org/",
    logo: "images/logos/android.svg",
    platforms: ["Android"],
    usages: ["Key management", "Email", "File encryption", "Key discovery", "Identity certification"],
    summary: "Android key storage and OpenPGP operations for mobile apps such as FairEmail. Note: the project is in maintenance-only mode — security fixes are still applied but no new features are planned.",
    steps: [
      "Install OpenKeychain and create or import your key.",
      "Connect it to a compatible mail app or sharing workflow.",
      "Use fingerprint comparison, QR exchange, or key lookup before trusting contacts."
    ]
  },
  {
    name: "FairEmail",
    type: "Android email client",
    url: "https://email.faircode.eu/",
    platforms: ["Android"],
    usages: ["Email", "Signing & verification"],
    summary: "Privacy-focused Android email client that delegates all OpenPGP operations to OpenKeychain. Note that OpenKeychain is now in maintenance-only mode with no new features planned.",
    steps: [
      "Configure your mail account in FairEmail.",
      "Install OpenKeychain and make sure your personal key is available there.",
      "Use FairEmail's encryption and signing options when composing sensitive mail."
    ]
  },
  {
    name: "Thunderbird for Android",
    type: "Android email client",
    url: "https://k9mail.app/",
    logo: "images/logos/thunderbird.svg",
    platforms: ["Android"],
    usages: ["Email", "Signing & verification"],
    summary: "The rebranded successor to K-9 Mail, now officially Thunderbird for Android as of October 2024. Pairs with OpenKeychain for OpenPGP workflows.",
    steps: [
      "Add your email account and install OpenKeychain.",
      "Select the OpenPGP provider in account cryptography settings.",
      "Send a signed test message before relying on encrypted mail."
    ]
  },
  {
    name: "Mailvelope",
    type: "Browser extension",
    url: "https://mailvelope.com/",
    platforms: ["Browser", "Web"],
    usages: ["Email", "Browser/webmail", "Key management", "Signing & verification"],
    summary: "Browser extension that adds OpenPGP to supported webmail providers.",
    steps: [
      "Install the extension in your browser.",
      "Generate or import your key in Mailvelope's keyring.",
      "Open supported webmail and use the Mailvelope compose overlay for protected messages."
    ]
  },
  {
    name: "FlowCrypt",
    type: "Browser and mobile app",
    url: "https://flowcrypt.com/",
    platforms: ["Browser", "Android", "iOS", "Web", "Self-hosted"],
    usages: ["Email", "Browser/webmail", "Key management", "Enterprise", "Self hosted"],
    summary: "Gmail-focused OpenPGP experience with browser extensions, mobile apps, and enterprise options.",
    steps: [
      "Install the browser extension or mobile app.",
      "Connect your mail account and import or create a key.",
      "Use FlowCrypt's secure compose flow for encrypted mail and attachments."
    ]
  },
  {
    name: "Proton Mail",
    type: "Webmail provider",
    url: "https://proton.me/mail",
    logo: "images/logos/protonmail.svg",
    platforms: ["Web", "Android", "iOS", "Browser"],
    usages: ["Email", "Browser/webmail", "Key management"],
    summary: "Hosted encrypted mail service with OpenPGP-compatible workflows and key import/export options.",
    steps: [
      "Create or sign in to a Proton Mail account.",
      "Review encryption keys in account settings before importing outside keys.",
      "Use external address key sharing when communicating with non-Proton OpenPGP users."
    ]
  },
  {
    name: "Mailfence",
    type: "Webmail provider",
    url: "https://mailfence.com/",
    platforms: ["Web", "Browser"],
    usages: ["Email", "Browser/webmail", "Key management"],
    summary: "Webmail suite with built-in OpenPGP support for users who prefer browser-based mail.",
    steps: [
      "Create or open a Mailfence account.",
      "Generate or import an OpenPGP key in the mail settings.",
      "Exchange public keys with contacts and test signed mail first."
    ]
  },
  {
    name: "mailbox.org",
    type: "Webmail provider",
    url: "https://mailbox.org/",
    platforms: ["Web", "Browser"],
    usages: ["Email", "Browser/webmail", "Key discovery"],
    summary: "Hosted mail provider listed by OpenPGP.org for webmail OpenPGP support.",
    steps: [
      "Set up your mailbox.org account.",
      "Enable the provider's OpenPGP options for your mailbox.",
      "Confirm how your private key is stored before using it for sensitive mail."
    ]
  },
  {
    name: "Canary Mail",
    type: "Email client",
    url: "https://canarymail.io/",
    platforms: ["macOS", "iOS", "Android"],
    usages: ["Email", "Signing & verification"],
    summary: "Cross-platform commercial mail client listed by OpenPGP.org for OpenPGP-capable email.",
    steps: [
      "Install Canary Mail on your device.",
      "Add your mail account and review the encryption settings.",
      "Import existing keys if you need compatibility with established OpenPGP contacts."
    ]
  },
  {
    name: "Delta Chat",
    type: "Messaging over email",
    url: "https://delta.chat/",
    platforms: ["Windows", "macOS", "Linux", "Android", "iOS"],
    usages: ["Email", "Messaging"],
    summary: "Chat-style app that uses email transport and Autocrypt for encryption. Does not support importing or managing a personal OpenPGP key — keys are created and managed internally by the app.",
    steps: [
      "Install the app and connect an email account.",
      "Let the app manage keys automatically via Autocrypt.",
      "Use it when conversational flow matters more than classic email UI, but note it cannot use keys from a key signing party."
    ]
  },
  {
    name: "Claws Mail",
    type: "Email client",
    url: "https://www.claws-mail.org/",
    platforms: ["Windows", "Linux"],
    usages: ["Email", "Signing & verification"],
    summary: "Lightweight desktop email client listed by OpenPGP.org for Windows and Linux.",
    steps: [
      "Install Claws Mail and configure your mail account.",
      "Enable the OpenPGP plugin or integration in preferences.",
      "Import contact keys and send signed test mail before encrypting."
    ]
  },
  {
    name: "Evolution",
    type: "Linux email client",
    url: "https://wiki.gnome.org/Apps/Evolution",
    logo: "images/logos/gnome.svg",
    platforms: ["Linux"],
    usages: ["Email", "Signing & verification"],
    summary: "GNOME desktop mail client commonly paired with Seahorse and system key management.",
    steps: [
      "Set up your mail account in Evolution.",
      "Prepare your OpenPGP keys in the GNOME key tools.",
      "Select signing and encryption behavior in account security settings."
    ]
  },
  {
    name: "Seahorse",
    type: "GNOME key manager",
    url: "https://wiki.gnome.org/Apps/Seahorse",
    logo: "images/logos/gnome.svg",
    platforms: ["Linux"],
    usages: ["Key management", "Identity certification"],
    summary: "GNOME key manager for passwords and encryption keys, often used alongside Linux desktop mail clients.",
    steps: [
      "Open the password and keys app on GNOME.",
      "Import, inspect, and organize OpenPGP public keys.",
      "Compare fingerprints before marking a key as trusted."
    ]
  },
  {
    name: "KMail",
    type: "Linux email client",
    url: "https://kontact.kde.org/components/kmail/",
    logo: "images/logos/kde.svg",
    platforms: ["Linux"],
    usages: ["Email", "Signing & verification"],
    summary: "KDE mail client that pairs naturally with Kleopatra for OpenPGP certificate management.",
    steps: [
      "Configure mail accounts in KMail or Kontact.",
      "Use Kleopatra to prepare and verify certificates.",
      "Select signing and encryption keys in KMail identity settings."
    ]
  },
  {
    name: "Mutt",
    type: "Terminal email client",
    url: "http://www.mutt.org/",
    platforms: ["macOS", "Linux"],
    usages: ["Email", "Signing & verification"],
    summary: "Keyboard-driven mail client for users who prefer a terminal-centered workflow.",
    steps: [
      "Set up Mutt with your mail account and local OpenPGP toolchain.",
      "Bind signing and encryption behavior to your mail identities.",
      "Practice with a test mailbox before using it for event keys."
    ]
  },
  {
    name: "eM Client",
    type: "Email client",
    url: "https://www.emclient.com/",
    platforms: ["Windows", "macOS"],
    usages: ["Email", "Signing & verification"],
    summary: "Commercial desktop email client listed by OpenPGP.org for Windows OpenPGP-capable mail.",
    steps: [
      "Install eM Client and add your mail account.",
      "Review encryption and certificate settings for the account.",
      "Import keys for contacts before sending encrypted messages."
    ]
  },
  {
    name: "The Bat!",
    type: "Email client",
    url: "https://www.ritlabs.com/en/products/thebat/",
    platforms: ["Windows"],
    usages: ["Email", "Signing & verification"],
    summary: "Windows email client listed by OpenPGP.org for OpenPGP-capable email workflows.",
    steps: [
      "Install the client and configure your mailbox.",
      "Connect it to your OpenPGP key material in security settings.",
      "Exchange and verify contact public keys before encrypting."
    ]
  },
  {
    name: "iPGMail",
    type: "iOS app",
    url: "https://ipgmail.com/",
    platforms: ["iOS"],
    usages: ["Email", "File encryption", "Key management"],
    summary: "iOS OpenPGP app for people who need key and message operations on Apple mobile devices.",
    steps: [
      "Install the app and import or create a key.",
      "Bring in public keys for recipients you expect to contact.",
      "Use the app's share and mail flows for encrypted or signed content."
    ]
  },
  {
    name: "PGP Everywhere",
    type: "iOS app",
    url: "https://www.pgpeverywhere.com/",
    platforms: ["iOS"],
    usages: ["Email", "Key management"],
    summary: "iOS OpenPGP option listed by OpenPGP.org for mobile key and message handling.",
    steps: [
      "Install the app and set up your personal key.",
      "Import public keys for contacts.",
      "Use the iOS sharing workflow to move protected text into the apps you use."
    ]
  },
  {
    name: "keys.openpgp.org",
    type: "Key discovery service",
    url: "https://keys.openpgp.org/",
    platforms: ["Web", "Server"],
    usages: ["Key discovery", "Key publishing", "Identity certification"],
    summary: "Public key discovery service that supports search, upload, verified email identities, and managed WKD.",
    steps: [
      "Search by fingerprint or email address when you need a public key.",
      "Upload your public key and complete email verification for discoverability.",
      "Use the manage page when you need to remove identities or update published key material."
    ]
  },
  {
    name: "Web Key Directory",
    type: "Domain key discovery",
    url: "https://keys.openpgp.org/about/usage-wkd/",
    platforms: ["Web", "Self-hosted", "Server"],
    usages: ["Key discovery", "Key publishing", "Enterprise", "Self hosted"],
    summary: "A standard way for a domain to publish OpenPGP keys for email addresses under that domain.",
    steps: [
      "Choose whether to host WKD yourself or delegate it to a managed service.",
      "Publish keys for the domain addresses that should be discoverable.",
      "Test discovery from the mail clients your participants use."
    ]
  },
  {
    name: "GnuPG",
    type: "CLI tool",
    url: "https://gnupg.org/",
    platforms: ["Windows", "macOS", "Linux"],
    usages: ["Key management", "File encryption", "Signing & verification", "Key discovery", "Identity certification"],
    summary: "The reference OpenPGP command-line implementation. Underpins Kleopatra, Gpg4win, GPG Suite, and most Linux desktop OpenPGP tooling.",
    steps: [
      "Install via your package manager, Homebrew, Gpg4win (Windows), or GPG Suite (macOS).",
      "Create a key with gpg --full-generate-key and back up both the key and a revocation certificate.",
      "Export and share the public key, then use gpg --sign-key after fingerprint verification at the event."
    ]
  },
  {
    name: "Sequoia PGP",
    type: "CLI and Rust library",
    url: "https://sequoia-pgp.org/",
    platforms: ["Windows", "macOS", "Linux", "Rust"],
    usages: ["File encryption", "Signing & verification", "Key management", "Development", "Key discovery"],
    summary: "Modern Rust OpenPGP implementation with the sq tool and libraries for safer integrations.",
    steps: [
      "Install the sq tooling from the project documentation or your package manager.",
      "Create or import certificates into the tool's certificate store.",
      "Use it for repeatable encryption, signing, verification, and key discovery workflows."
    ]
  },
  {
    name: "RNP",
    type: "CLI and C++ library",
    url: "https://www.rnpgp.com/",
    platforms: ["Windows", "macOS", "Linux", "C/C++"],
    usages: ["Development", "File encryption", "Signing & verification", "Key management"],
    summary: "C++ OpenPGP implementation used by Thunderbird and available as tools and libraries.",
    steps: [
      "Use RNP directly when you need its command-line tools or library API.",
      "Prefer the project documentation for integration details and supported key types.",
      "Test interoperability with the exact clients your users will use."
    ]
  },
  {
    name: "OpenPGP.js",
    type: "JavaScript library",
    url: "https://openpgpjs.org/",
    logo: "images/logos/javascript.svg",
    platforms: ["JavaScript", "Browser", "Node.js"],
    usages: ["Development", "Browser/webmail", "File encryption", "Signing & verification"],
    summary: "JavaScript OpenPGP implementation for browser and Node.js applications.",
    steps: [
      "Add the library to the web or Node project.",
      "Design where keys live before building encrypt and decrypt flows.",
      "Use library verification results to show users clear trust states."
    ]
  },
  {
    name: "PGPainless",
    type: "Java library",
    url: "https://pgpainless.org/",
    logo: "images/logos/openjdk.svg",
    platforms: ["Java", "Android"],
    usages: ["Development", "File encryption", "Signing & verification"],
    summary: "High-level Java and Android library built to make OpenPGP operations easier to compose correctly.",
    steps: [
      "Add the library to the Java or Android project.",
      "Use its high-level builders for key generation, encryption, decryption, signing, and verification.",
      "Test expired, revoked, and wrong-key cases rather than only the happy path."
    ]
  },
  {
    name: "PGPy",
    type: "Python library",
    url: "https://github.com/SecurityInnovation/PGPy",
    logo: "images/logos/python.svg",
    platforms: ["Python"],
    usages: ["Development", "File encryption", "Signing & verification"],
    summary: "Python OpenPGP library for application-level handling of keys, messages, and signatures. Note: the library has not had a release since November 2022 and has numerous open issues.",
    steps: [
      "Add the library to the Python project environment.",
      "Load keys and messages through the library API instead of parsing armored text manually.",
      "Write tests for malformed input, wrong recipients, expired keys, and revoked keys."
    ]
  },
  {
    name: "GOpenPGP",
    type: "Go library",
    url: "https://gopenpgp.org/",
    logo: "images/logos/go.svg",
    platforms: ["Go"],
    usages: ["Development", "File encryption", "Signing & verification"],
    summary: "High-level Go OpenPGP library maintained by Proton for application integrations.",
    steps: [
      "Add the module to the Go application.",
      "Use high-level helpers for common encryption, decryption, signing, and verification flows.",
      "Keep key storage and passphrase handling separate from request handling."
    ]
  },
  {
    name: "Bouncy Castle",
    type: "Java and C# library",
    url: "https://www.bouncycastle.org/",
    platforms: ["Java", ".NET", "Android"],
    usages: ["Development", "File encryption", "Signing & verification"],
    summary: "Low-level cryptography library with OpenPGP support, often used underneath higher-level Java tooling.",
    steps: [
      "Use it when you need lower-level control in Java, C#, or Android.",
      "Wrap common operations in your own safer application API.",
      "Prefer higher-level libraries when you do not need packet-level control."
    ]
  },
  {
    name: "GpgFrontend",
    type: "Desktop app",
    url: "https://www.gpgfrontend.bktus.com/",
    platforms: ["Windows", "macOS", "Linux"],
    usages: ["Key management", "File encryption", "Signing & verification"],
    summary: "Cross-platform desktop frontend listed by OpenPGP.org for PC-based OpenPGP work.",
    steps: [
      "Install the desktop app for your operating system.",
      "Import or create keys and verify contact fingerprints.",
      "Use the visual workflows for file encryption, decryption, signing, and verification."
    ]
  },
  {
    name: "Passbolt",
    type: "Password manager",
    url: "https://www.passbolt.com/",
    platforms: ["Web", "Self-hosted", "Server", "Browser"],
    usages: ["Password management", "Enterprise", "Self hosted"],
    summary: "Team password manager listed by OpenPGP.org that uses OpenPGP concepts for shared-secret workflows.",
    steps: [
      "Choose hosted or self-hosted deployment.",
      "Set up users and recovery policy before importing team secrets.",
      "Teach users how their private key affects account recovery."
    ]
  },
  {
    name: "pass",
    type: "Password manager",
    url: "https://www.passwordstore.org/",
    platforms: ["Linux", "macOS"],
    usages: ["Password management", "File encryption"],
    summary: "Unix password-store workflow that stores each secret as an OpenPGP-encrypted file.",
    steps: [
      "Prepare a working OpenPGP key before initializing the password store.",
      "Use one encrypted file per secret and keep the repository private.",
      "Back up both the password store and the private key recovery path."
    ]
  }
];

const usageTags = document.querySelector("#usageTags");
const platformTags = document.querySelector("#platformTags");
const toolSearch = document.querySelector("#toolSearch");
const resetFilters = document.querySelector("#resetFilters");
const toolGrid = document.querySelector("#toolGrid");
const toolCount = document.querySelector("#toolCount");
const activeFilters = document.querySelector("#activeFilters");
const emptyState = document.querySelector("#emptyState");

const usageLabels = [...new Set(tools.flatMap((tool) => tool.usages))].sort();
const platformLabels = [...new Set(tools.flatMap((tool) => tool.platforms))].sort();
const activeUsages = new Set();
const activePlatforms = new Set();

function initials(name) {
  return name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase();
}

function makeTag(label, type) {
  const tag = document.createElement("button");
  const selected = type === "usage" ? activeUsages.has(label) : activePlatforms.has(label);
  tag.className = `tag ${type}`;
  tag.type = "button";
  tag.textContent = label;
  tag.setAttribute("aria-pressed", selected ? "true" : "false");
  if (selected) tag.classList.add("active");
  tag.addEventListener("click", () => {
    toggleFilter(type, label);
    tag.closest(".tool-card")?.scrollIntoView({ block: "nearest", behavior: "smooth" });
  });
  return tag;
}

function makeFilterChip(label, type) {
  const selectedSet = type === "usage" ? activeUsages : activePlatforms;
  const chip = document.createElement("button");
  chip.type = "button";
  chip.className = `filter-chip ${type}`;
  chip.textContent = label;
  chip.setAttribute("aria-pressed", selectedSet.has(label) ? "true" : "false");
  if (selectedSet.has(label)) chip.classList.add("active");
  chip.addEventListener("click", () => toggleFilter(type, label));
  return chip;
}

function toggleFilter(type, label) {
  const selectedSet = type === "usage" ? activeUsages : activePlatforms;
  if (selectedSet.has(label)) {
    selectedSet.delete(label);
  } else {
    selectedSet.add(label);
  }
  renderTools();
}

function setSingleUsageFilter(label) {
  activeUsages.clear();
  activePlatforms.clear();
  activeUsages.add(label);
  toolSearch.value = "";
  renderTools();
  document.querySelector(".filter-row").scrollIntoView({ block: "start", behavior: "smooth" });
}

function makeLogo(tool) {
  const logoBox = document.createElement("div");
  logoBox.className = "logo-box";

  if (tool.logo) {
    const image = document.createElement("img");
    image.src = tool.logo;
    image.alt = `${tool.name} logo`;
    image.loading = "eager";
    image.referrerPolicy = "no-referrer";
    image.onerror = () => {
      logoBox.replaceChildren(makeFallback(tool));
    };
    logoBox.append(image);
  } else {
    logoBox.append(makeFallback(tool));
  }

  return logoBox;
}

function makeFallback(tool) {
  const fallback = document.createElement("span");
  fallback.className = "logo-fallback";
  fallback.textContent = initials(tool.name);
  fallback.setAttribute("aria-hidden", "true");
  return fallback;
}

function makeToolCard(tool) {
  const card = document.createElement("article");
  card.className = "tool-card";

  const header = document.createElement("div");
  header.className = "tool-card-header";
  header.append(makeLogo(tool));

  const titleWrap = document.createElement("div");
  const titleRow = document.createElement("div");
  titleRow.className = "tool-title-row";

  const title = document.createElement("h3");
  const link = document.createElement("a");
  link.href = tool.url;
  link.textContent = tool.name;
  title.append(link);

  const type = document.createElement("span");
  type.className = "tool-type";
  type.textContent = tool.type;

  titleRow.append(title, type);
  titleWrap.append(titleRow);
  header.append(titleWrap);

  const summary = document.createElement("p");
  summary.className = "tool-summary";
  summary.textContent = tool.summary;

  const platformRow = document.createElement("div");
  platformRow.className = "tag-row";
  platformRow.setAttribute("aria-label", `${tool.name} platforms`);
  tool.platforms.forEach((platform) => platformRow.append(makeTag(platform, "platform")));

  const usageRow = document.createElement("div");
  usageRow.className = "tag-row";
  usageRow.setAttribute("aria-label", `${tool.name} uses`);
  tool.usages.forEach((usage) => usageRow.append(makeTag(usage, "usage")));

  const instructions = document.createElement("div");
  instructions.className = "tool-instructions";
  const instructionTitle = document.createElement("strong");
  instructionTitle.textContent = "How to start";
  const list = document.createElement("ol");
  tool.steps.forEach((step) => {
    const item = document.createElement("li");
    item.textContent = step;
    list.append(item);
  });
  instructions.append(instructionTitle, list);

  card.append(header, summary, platformRow, usageRow, instructions);
  return card;
}

function matchesSearch(tool, query) {
  const haystack = [
    tool.name,
    tool.type,
    tool.summary,
    ...tool.platforms,
    ...tool.usages,
    ...tool.steps
  ].join(" ").toLowerCase();
  return haystack.includes(query);
}

function renderTools() {
  const query = toolSearch.value.trim().toLowerCase();

  const filtered = tools.filter((tool) => {
    const usageMatch = activeUsages.size === 0 || [...activeUsages].every((usage) => tool.usages.includes(usage));
    const platformMatch = activePlatforms.size === 0 || [...activePlatforms].every((platform) => tool.platforms.includes(platform));
    const searchMatch = query === "" || matchesSearch(tool, query);
    return usageMatch && platformMatch && searchMatch;
  });

  usageTags.replaceChildren(...usageLabels.map((label) => makeFilterChip(label, "usage")));
  platformTags.replaceChildren(...platformLabels.map((label) => makeFilterChip(label, "platform")));
  toolGrid.replaceChildren(...filtered.map(makeToolCard));
  toolCount.textContent = `${filtered.length} ${filtered.length === 1 ? "tool" : "tools"}`;
  emptyState.hidden = filtered.length > 0;

  const filterText = [];
  if (activeUsages.size) filterText.push(`uses: ${[...activeUsages].join(", ")}`);
  if (activePlatforms.size) filterText.push(`platforms: ${[...activePlatforms].join(", ")}`);
  if (query) filterText.push(`"${query}"`);
  activeFilters.textContent = filterText.length ? `Filtered by ${filterText.join(" + ")}` : "Showing everything";
}

toolSearch.addEventListener("input", renderTools);

resetFilters.addEventListener("click", () => {
  activeUsages.clear();
  activePlatforms.clear();
  toolSearch.value = "";
  renderTools();
});

document.querySelectorAll("[data-filter-usage]").forEach((card) => {
  card.addEventListener("click", () => setSingleUsageFilter(card.dataset.filterUsage));
  card.addEventListener("keydown", (event) => {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      setSingleUsageFilter(card.dataset.filterUsage);
    }
  });
});

renderTools();

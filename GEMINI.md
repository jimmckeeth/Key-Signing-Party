# GEMINI.md - Project Overview & Instructions

## Directory Overview
This project contains the logistical guides, handouts, and technical reference materials for running an OpenPGP key signing party. The materials are specifically designed for the Boise Code Camp event but are structured to serve as a high-quality template for any modern cryptographic identity verification ceremony.

The project prioritizes:
- **Security & Privacy**: Clear separation of public material from private data.
- **Modern Best Practices**: Promoting Ed25519, full fingerprint verification, and keys.openpgp.org.
- **Consistency**: Using [Typst](https://typst.app/) for professional, branded PDF generation across all event handouts.

## Key Files & Directories

### Root Directory
- **DefinitiveOpenPGP.md**: A comprehensive technical reference on modern OpenPGP best practices. Use this for deep-dive questions on cryptographic theory and master/subkey architecture.
- **DefinitiveOpenPGP.typ**: Typst version of the technical reference, ideal for PDF conversion.
- **CLAUDE.md**: Technical instructions for AI agents regarding build commands and project architecture.
- **README.md**: General event overview and quick-start instructions for humans.

### `handouts/` Directory
- **attendee_pre_event_guide.typ**: Instructions for participants on how to create, publish, and submit their keys.
- **organizer_pre_event_guide.typ**: The "Standard Operating Procedure" for organizers, including validation policies and data handling.
- **attendee_keylist_topper.typ**: Compact rules displayed at the top of the physical verification list during the event.
- **organizer_day_of_checklist.typ**: A one-page punch-list for managing the event on-site.
- **typst/bcc-keysigning-style.typ**: The central design system. All visual updates (colors, fonts, layout) must happen here.
- **build_handouts.sh / .ps1**: Platform-specific scripts to compile the Typst sources into PDFs.

## Usage & Workflow

### 1. Modifying Content
If you need to update event details (dates, deadlines, form links):
- Most event-specific details are currently hardcoded in the individual `.typ` files.
- **Strategy**: Always search across all `.typ` files in `handouts/` when updating a date or URL to ensure consistency.

### 2. Updating Design
If you want to change the visual branding:
- **Do not** edit styles within individual handout files.
- **Action**: Modify `handouts/typst/bcc-keysigning-style.typ`. It exports the `bcc-doc` template and reusable UI components (`callout`, `pill`, etc.) used by all documents.

### 3. Generating PDFs
To build the handouts:
- **Prerequisites**: Ensure Typst is installed using the `install_prerequisites` scripts.
- **Build**: Run `bash handouts/build_handouts.sh` (Linux/macOS) or `handouts\build_handouts.ps1` (Windows).
- **Output**: PDFs are generated in the same directory as their `.typ` source.

### 4. Technical Reference Conversion
The `DefinitiveOpenPGP.md` file uses Pandoc-compatible footnotes. If you modify it and need to update the Typst version:
- **Command**: `pandoc DefinitiveOpenPGP.md -t typst -o DefinitiveOpenPGP.typ`
- **Note**: Ensure `@` symbols in URLs are properly handled to avoid Pandoc misinterpreting them as citation markers.

## Development Conventions
- **Path Formatting**: Prefer forward slashes (`/`) for cross-platform compatibility in documentation and Typst imports, even though the project currently contains some Windows-style backslashes in documentation.
- **Footnotes**: Follow the Pandoc footnote format `[^N]` for citations in Markdown files.
- **Typography**: The design system relies on "Segoe UI" and "Consolas". Ensure these or their fallbacks are available if editing the style library.

# Repository Guidelines

## Project Structure & Module Organization

This repository contains event materials for the Boise Code Camp OpenPGP key signing party. Root-level `DefinitiveOpenPGP.*` files are reference material in AsciiDoc, Markdown, and Typst formats. The main deliverables live in `handouts/`.

- `handouts/*.typ`: Typst sources for attendee and organizer handouts.
- `handouts/*.pdf`: generated PDFs, written next to their source files.
- `handouts/typst/bcc-keysigning-style.typ`: shared Typst style library and reusable components.
- `handouts/images/`: logos and supporting images.
- `handouts/build_handouts.*` and `handouts/install_prerequisites.*`: cross-platform helper scripts.

Planned validation tooling may later use `handouts/data/`, `handouts/scripts/`, and `handouts/build/`; do not invent generated artifacts there unless implementing that workflow.

## Build, Test, and Development Commands

Install Typst if needed:

```powershell
powershell -ExecutionPolicy Bypass -File handouts\install_prerequisites.ps1
```

```bash
bash handouts/install_prerequisites.sh
```

Build all PDFs:

```powershell
powershell -ExecutionPolicy Bypass -File handouts\build_handouts.ps1
```

```bash
bash handouts/build_handouts.sh
```

Compile one file while iterating:

```bash
typst compile handouts/attendee_pre_event_guide.typ handouts/attendee_pre_event_guide.pdf
```

There is no automated unit test suite. Treat successful Typst compilation and a visual review of changed PDFs as the required verification.

## Coding Style & Naming Conventions

Keep Typst handouts text-focused and conservative. All shared visual design, margins, colors, headers, footers, and reusable components belong in `handouts/typst/bcc-keysigning-style.typ`. Each handout should import the shared style with:

```typst
#import "typst/bcc-keysigning-style.typ": *
```

Use descriptive lowercase file names with underscores for handout sources, matching the existing pattern: `attendee_pre_event_guide.typ`, `organizer_day_of_checklist.typ`.

## Testing Guidelines

After editing any `.typ` file or shared style, run the full handout build script for your platform. Open the regenerated PDFs and check page breaks, tables, callouts, dates, and command examples. If only one source changed, direct `typst compile` is acceptable during iteration, but run the full build before submitting.

## Commit & Pull Request Guidelines

The current history uses short imperative or descriptive subjects, such as `PDF versions` and `Delete ...`. Keep commit messages concise and specific to the artifact or source changed.

Pull requests should include a short summary, the build command run, and screenshots or exported PDFs when layout changes are visible. Link related event issues when applicable.

## Security & Privacy

Never commit private keys, attendee private data, unpublished attendee lists, or raw form exports. Public keys may be distributed to event participants, but the attendee list is not intended for public posting. Do not manually edit generated final artifacts once validation tooling exists.

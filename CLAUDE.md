# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Event materials for running an OpenPGP key signing party at Boise Code Camp (next event: Saturday, May 2, 2026). The repo contains:

- **Handout source files** (`handouts/*.typ`) — Typst documents for attendees and organizers
- **A shared style library** (`handouts/typst/bcc-keysigning-style.typ`) — shared layout, colors, and components used by all handouts
- **Build scripts** — PowerShell and bash wrappers around `typst compile`
- **Reference documents** (`DefinitiveOpenPGP.*`) — OpenPGP best-practices reference in AsciiDoc, Markdown, and Typst formats
- **Usage page** (`usage/index.html`) — static HTML tool-chooser listing OpenPGP clients, key managers, libraries, and services; driven by `usage/tools.js`

## Building the Handouts

Install Typst first (one-time):

```bash
bash handouts/install_prerequisites.sh
```

```powershell
powershell -ExecutionPolicy Bypass -File handouts\install_prerequisites.ps1
```

Then compile all four PDFs:

```bash
bash handouts/build_handouts.sh
```

```powershell
powershell -ExecutionPolicy Bypass -File handouts\build_handouts.ps1
```

To compile a single file directly:

```bash
typst compile handouts/attendee_pre_event_guide.typ handouts/attendee_pre_event_guide.pdf
```

Generated PDFs are written next to their `.typ` sources inside `handouts/`.

## Architecture

All four handout `.typ` files share a single design system via `handouts/typst/bcc-keysigning-style.typ`. Every handout starts with:

```typst
#import "typst/bcc-keysigning-style.typ": *
```

The style library exposes a document template function `bcc-doc(body, title:, subtitle:, audience:, docdate:)` plus reusable components: `pill`, `callout`, `stepbox`, `checklist`, `command`, and `compact-table`. All visual changes (colors, fonts, margins, header/footer) live exclusively in `bcc-keysigning-style.typ`.

## Planned but Not Yet Implemented

The organizer guide documents a validation workflow under `handouts/data/`, `handouts/scripts/`, and `handouts/build/` — these directories and scripts do not exist yet. The handouts describe the intended policy; the scripts are future event tooling.

## Privacy Constraints

- The attendee list must not be publicly posted.
- Private keys must never be committed, emailed, or uploaded anywhere in this repo.
- Public keys distributed to event participants are acceptable.

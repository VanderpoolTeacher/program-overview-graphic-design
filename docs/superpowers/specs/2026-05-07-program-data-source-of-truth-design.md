# Program Data — Source of Truth Design

**Date:** 2026-05-07
**Status:** Approved (design)
**Owner:** Michael Vanderpool

## Context

The DC Graphic Design program-overview app (`program-overview.html`) holds all
program data — MLOs, courses, CLOs, course→MLO mappings, and the four-year
Plan of Study — as three hand-authored JavaScript array literals inline in the
`<script>` block. There is no external data file; the HTML file is both the
app and the data store.

A new authoritative document — `source/DC Graphic Design Major Design
Document.pdf` — was placed in the repo. The app's data was originally derived
from this PDF, but the connection is informal: the PDF contradicts itself in
places, the app paraphrases the PDF's CLO wording, and at least one
course-level mapping (DSGN 205 + MLO 5) disagrees between the two.

We need a single, canonical, editable source of truth that resolves these
conflicts and from which the app data can be derived.

## Goals

- One canonical data file that captures everything the app currently displays.
- Human-readable enough for the program coordinator (and faculty reviewers) to
  edit directly without code skills.
- Structured enough that the app can later be wired to read from it
  (parseable headings, fenced metadata blocks, predictable conventions).
- Resolve the known content discrepancies between the PDF and the app.
- Fix the find-and-replace damage in the PDF prose during extraction.

## Non-goals

- **Wiring the app to read from the new file.** The HTML app keeps its inline
  JS literals for now. Integration is a separate spec.
- **Re-deriving from the PDF on an ongoing basis.** The PDF becomes a frozen
  reference; from this point forward, the new MD file is canonical.
- **Restructuring the app, adding a build step, or introducing a framework.**
- **Updating the README** beyond a single sentence pointing to the new source.

## File and folder structure

```
program-overview-graphic-design/
├── source/
│   ├── DC Graphic Design Major Design Document.pdf   (unchanged, reference only)
│   └── program-data.md                                (NEW — canonical)
├── program-overview.html                              (unchanged this spec)
├── index.html
└── README.md                                          (one-line update)
```

`source/program-data.md` is canonical. If it conflicts with the PDF, the
inline JS literals, or any other artifact, the MD file wins.

## Document structure

The MD file is one top-down readable document with three top-level sections,
in this order:

1. Top-of-file YAML frontmatter — program-level metadata (program name,
   catalog year, emphasis, career pathways, domain definitions).
2. `# Program Learning Outcomes (MLOs)` — eight `## MLO N — Name` subsections,
   each with a `**Domain:** ...` line and the verbatim MLO description.
3. `# Courses` — thirteen `## CODE — Title` subsections, each with a fenced
   `yaml` block (`level:`, `mlos:`), a `**Purpose.**` paragraph, and a
   `**Course Learning Outcomes**` numbered list.
4. `# Plan of Study` — four `## Year N — Name` subsections, each containing
   semester `### Term YYYY (N cr)` subsections with a bulleted course list.

### Conventions (load-bearing — the app parser will rely on these)

| Element | Convention |
|---|---|
| Course heading | `## DSGN 114 — Intro to Graphic Design` (code first, em-dash separator) |
| Course metadata | A single fenced ` ```yaml ` block immediately under the heading, with keys `level:` and `mlos:` |
| Course `level` values | One of: `Foundational`, `Intermediate`, `Advanced`, `Capstone` |
| Plan course `type` values | One of: `major`, `gened`, `elective` |
| MLO heading | `## MLO N — Name` |
| Domain line under an MLO | `**Domain:** Conceptual` (capitalized, matches frontmatter `domains` keys when lowercased) |
| CLO list | Numbered list. Each item ends with a separate line: `→ MLOs: 1, 2, 3` |
| Plan course line | `- CODE — Title (N cr) [type]` where `type` ∈ `{major, gened, elective}` |
| Plan semester heading | `### Fall YYYY (N cr)` |
| Plan year heading | `## Year N — Freshman` (or Sophomore/Junior/Senior) |

### Sample (excerpt)

```markdown
---
program: DC Graphic Design (BA)
catalog: 2025–26
emphasis: Design thinking as core methodology
career_pathways:
  - UX/UI
  - Marketing
  - Data visualization
  - Freelancing
  - Agency work
  - Entrepreneurship
domains:
  conceptual:   { name: Conceptual,   icon: fa-lightbulb,    mlos: [1, 3] }
  technical:    { name: Technical,    icon: fa-laptop-code,  mlos: [2, 4] }
  applied:      { name: Applied,      icon: fa-chart-column, mlos: [5]    }
  professional: { name: Professional, icon: fa-briefcase,    mlos: [6, 7, 8] }
---

# Program Learning Outcomes (MLOs)

## MLO 1 — Design Thinking
**Domain:** Conceptual

Apply the principles of design thinking to solve complex visual communication
problems across diverse media and user contexts.

# Courses

## DSGN 114 — Intro to Graphic Design

```yaml
level: Foundational
mlos: [1, 2, 4, 6, 7]
```

**Purpose.** First formal exposure to graphic design — core principles, visual
literacy, composition, typography, and digital tools.

**Course Learning Outcomes**

1. Identify and apply fundamental design principles in visual compositions.
   → MLOs: 1, 2
2. Create graphic design projects that demonstrate effective visual hierarchy,
   typography, and composition for print and screen.
   → MLOs: 2, 4
```

## Content decisions (resolved)

These are the four explicit calls made during the brainstorming session.
The MD file MUST reflect each one.

### 1. DSGN 205 + MLO 5 — INCLUDE

The PDF contradicts itself: page-4 cumulative matrix omits MLO 5 for DSGN 205,
but the per-CLO matrix (CLOs 2 and 4 check MLO 5), the CLO text annotations
("MLOs 1, 3, 4, 5" and "MLOs 1, 3, 5, 6"), and the summary highlights ("MLO 5
... built into courses like DSGN 107, 205, 310, ...") all include it.

**Decision:** DSGN 205 covers MLO 5.
- Course-level: `mlos: [1, 2, 3, 4, 5, 6, 7, 8]`
- CLO 2: `→ MLOs: 1, 3, 4, 5`
- CLO 4: `→ MLOs: 1, 3, 5, 6`
- The "Data Visualization built into..." summary lists 6 courses:
  107, 205, 310, 320, 498, 410.

### 2. DSGN 310 — internal consistency fix

The PDF's per-CLO matrix shows MLO 5 ✓ for DSGN 310 CLOs 3, 4, and 5, but the
CLO text annotations underneath do not list MLO 5. The app currently has
DSGN 310 covering MLO 5 at the course level with no CLO actually tagged.

**Decision:** Honor the per-CLO matrix. Add MLO 5 to DSGN 310 CLO 3
("Design brand collateral across various media platforms..."), since brand
collateral commonly includes data-visualization deliverables.
- CLO 3 becomes: `→ MLOs: 2, 4, 5, 6`
- Course-level mapping is already `[1, 2, 3, 4, 5, 6, 7, 8]` — unchanged.

### 3. PDF find-and-replace bug — fix during extraction

The PDF was apparently subjected to a global replace of `plo` → `MLO`. Every
affected word is restored when copied into the MD file:

| In PDF | In MD |
|---|---|
| `exMLOre` | `explore` |
| `exMLOres` | `explores` |
| `exMLOred` | `explored` |
| `exMLOring` | `exploring` |
| `emMLOyment` | `employment` |

Real MLO references (`MLO 5`, `MLOs 1, 2, 3`, etc.) are left untouched.
Apply only to prose copied from the PDF.

### 4. CLO wording — verbatim from PDF

The current app paraphrases the PDF's CLOs (e.g., dropping "for print and
screen", trimming trailing clauses). The MD file uses the **PDF's verbatim
wording** for each CLO, since the PDF is being treated as the original.
Stylistic improvements can be re-introduced later, but the source of truth
should match what was officially written.

## README update

Append one line to the existing `README.md` Files table:

| `source/program-data.md` | Canonical source of truth for program data (MLOs, courses, CLOs, plan of study) |

No further README rewrites in this spec. Other documentation about how the
app consumes the data will be added when the integration spec is written.

## Derived values (not stored in the MD)

The following are computed from the source data and MUST NOT be hand-stored in
`program-data.md`:

- Total / major / gen-ed / elective credit counts.
- Per-MLO course count (e.g., "MLO 1: 13 of 13 courses").
- Headline stats on the Overview tab (8 MLOs / 13 courses / 78 CLOs / 0 gaps).
- The "MLO 5 built into DSGN 107, 205, 310, 320, 498, 410" highlight list.

These are the consumer's responsibility (the app, or any future renderer).

## Risks and open questions

- **No automated check.** Until the app reads from `program-data.md`, the
  inline JS arrays can drift from the canonical source silently. Mitigation:
  the next spec (app integration) closes this gap. Until then, the MD file is
  the contract — if the JS disagrees, the JS is wrong.
- **Markdown table parsing.** The Plan of Study uses bullet lists rather than
  tables to keep parsing simple. If a future renderer wants tables, it can
  generate them from the bullet data.
- **YAML inside Markdown.** The course `yaml` blocks and the top-level
  frontmatter are both YAML; downstream parsers must distinguish them by
  position (top of file vs. immediately under a `## DSGN ...` heading).
- **Em-dash vs hyphen.** Course headings use an em-dash (`—`). Parsers must
  not rely on a regular hyphen as the separator.

## Out of scope (recap)

- Wiring `program-overview.html` to read from `program-data.md`.
- Adding a build step, framework, or bundler.
- Restructuring the app's UI or data model.
- Translating the data into other formats (JSON export, etc.).

## Next step

Hand off to the writing-plans skill to create a step-by-step implementation
plan for extracting the PDF content into `source/program-data.md` per these
conventions and decisions.

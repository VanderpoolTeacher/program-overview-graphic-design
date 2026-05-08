# Course Content Authoring System — Design

**Date:** 2026-05-08
**Status:** Approved (design)
**Owner:** Michael Vanderpool
**Branch:** `3-dsgn-410-course-content`

## Context

Course content development for the DC Graphic Design BA needs a repeatable
process. The DSGN 410 work this week proved out a useful pattern — extract
the course's facts from the canonical source, analyze any existing materials,
identify gaps against CLOs, then author assignments from a standard template.
That pattern is currently informal: the artifacts are scattered, the
conventions live in my head, and there is nothing stopping the next course
from drifting into a different shape.

This spec turns the pattern into a system: standard folders, scaffolding,
validation, and a visible progress tracker — usable across all 13 courses.

## Goals

- One standard layout per course under `course-design/<course-slug>/`.
- A scaffolding script that creates that layout, pre-fills facts from the
  canonical source, and forces the human to inspect any existing source
  materials.
- A validation script that catches CLO/MLO/rubric drift mechanically.
- A documented pipeline in `course-design/README.md`.
- A standalone HTML progress tracker as the single source of truth for
  per-course status (no duplicated table in the README).

## Non-goals

- **Modifying `program-overview.html`.** That app is student/admin facing.
  The tracker is internal and lives separately.
- **Authoring any new course content** in this spec. That happens after the
  system is in place, course by course.
- **Auto-publishing assignments to an LMS or syllabus generator.**
- **Auto-generating the progress tracker HTML from the README.** The HTML
  page is the canonical store for tracker data; the README references it.
- **AI-assisted assignment review.** Worth doing later for high-stakes
  courses; out of scope here.

## File and folder structure

```
program-overview-graphic-design/
├── course-design/
│   ├── README.md                            # NEW — pipeline doc; references progress.html
│   ├── progress.html                        # NEW — canonical progress tracker
│   ├── templates/
│   │   ├── assignment-template.md           # already exists
│   │   ├── source-analysis-template.md      # NEW
│   │   ├── existing-materials-analysis-template.md  # NEW
│   │   └── authoring-plan-template.md       # NEW
│   └── <course-slug>/                       # one per course as work progresses
│       ├── <course>-source-analysis.md
│       ├── <course>-existing-materials-analysis.md
│       ├── <course>-authoring-plan.md
│       └── assignments/
│           ├── 00-template-copy.md          # fresh copy of the template
│           ├── 01-<slug>.md
│           └── ...
├── scripts/
│   ├── validate-program-data.sh             # already exists
│   ├── scaffold-course.sh                   # NEW
│   └── validate-course-design.sh            # NEW
└── source/
    ├── program-data.md                      # canonical course data (existing)
    └── <Course Folder Name>/                # zero or more existing-materials folders
```

`course-design/dsgn-410/` is the existing example folder used to prove out the
pattern. After this system is in place, future courses follow the same shape.

## Pipeline stages

| Stage | Action | Output |
|---|---|---|
| 0 — Sanity check | `grep "^## DSGN NNN" source/program-data.md` | (verification) |
| 1 — Scaffold | `./scripts/scaffold-course.sh DSGN_NNN` | Folder + stamped templates |
| 2 — Existing-materials review | Inspect `source/` for matching folder; resolve `*-existing-materials-analysis.md` | Either inventory + analysis, or explicit "none found, confirmed" |
| 3 — Source analysis | Fill in `*-source-analysis.md` | Filled doc |
| 4 — Authoring plan | Fill in `*-authoring-plan.md` | Filled doc with assignment list and CLO map |
| 5 — Author assignments | Per planned assignment, copy `00-template-copy.md` and fill it out | One MD per assignment |
| 6 — Validate | `./scripts/validate-course-design.sh DSGN_NNN` | Pass/fail report |
| 7 — Review | Walk the author's checklist at the bottom of each assignment | Checklist boxes ticked |
| 8 — Publish | (External — LMS / syllabus / Google Doc) | (Out of scope) |

Stage 2 is non-skippable. Even a course with no existing materials must
produce a `*-existing-materials-analysis.md` that explicitly says "none found,
confirmed by inspection on YYYY-MM-DD."

## Templates (NEW, three files)

### `source-analysis-template.md`

Codifies the structure used in `course-design/dsgn-410/dsgn-410-source-analysis.md`:

- Course shape table (title, level, credits, CLO count, MLOs covered, MLOs not covered)
- "What the source actually says" — verbatim purpose paragraph from `program-data.md`
- CLO-by-CLO read — table mapping each CLO to its theme and likely deliverable type
- Patterns worth noting — analytical observations (through-lines, unique aspects)
- Content gaps the source does not fill

The scaffold script pre-fills the course shape table and quotes the verbatim
purpose by reading `source/program-data.md`. The human writes the analytical
sections.

### `existing-materials-analysis-template.md`

Codifies the structure used in `course-design/dsgn-410/dsgn-410-existing-materials-analysis.md`:

- Inventory table — file name, type, format
- Weekly schedule overview (when one is present)
- Assignment → CLO coverage map — matrix table
- Coverage by CLO — per-CLO line of fully/partial/uncovered
- Gaps the existing materials do not fill
- Mismatches and tensions
- Quick wins

If no existing materials are found, the template is still stamped but with a
header that says ⚠ *No existing source folder detected. Confirm by inspecting
`source/` manually before declaring "no existing materials," then replace
this notice with "Confirmed none on YYYY-MM-DD."*

### `authoring-plan-template.md`

A new artifact (no DSGN 410 example yet). Contents:

- Header — course code, list of CLOs with verbatim text
- Assignments to author table — columns: # | Title | CLO(s) addressed | MLO union | Priority (P0/P1/P2) | Notes
- CLO coverage check — auto-readable mapping showing every CLO has at least
  one assignment in the planned list
- Open questions for instructor review

The scaffold script pre-fills the CLO list at the top and the empty
assignment-list table.

## Scaffold script — `scripts/scaffold-course.sh`

**Usage:** `./scripts/scaffold-course.sh DSGN312`

**Behavior:**

1. Validate input. Course must exist as a `## DSGN NNN — ...` heading in
   `source/program-data.md`. Exit 1 with a clear message otherwise.
2. Compute the folder slug — lowercase course code with a single hyphen
   (e.g., `DSGN312` → `dsgn-312`; also accept input like `DSGN 312`).
3. Create `course-design/<slug>/` if it doesn't exist.
4. Extract course facts from `source/program-data.md`:
   - Title (from heading)
   - Level (from yaml block)
   - MLOs covered (from yaml block)
   - All CLOs (numbered list with `→ MLOs:` lines)
   - Course purpose paragraph
5. Always check for an existing source folder. Glob `source/DSGN NNN*/` — if
   one or more match, use the first; if zero, note "no existing folder".
6. If a folder is found, run `textutil -convert txt` on every `.docx` file
   inside it to a sibling `.cache/` directory (gitignored). Inventory all
   files (name, extension, size).
7. Stamp three template files into the course folder, substituting course
   facts and (if applicable) the existing-materials inventory:
   - `<slug>-source-analysis.md` — course shape table + verbatim purpose pre-filled
   - `<slug>-existing-materials-analysis.md` — inventory pre-filled, OR ⚠ notice
   - `<slug>-authoring-plan.md` — CLO list + empty assignments table
8. Create `assignments/00-template-copy.md` as a fresh copy of
   `course-design/templates/assignment-template.md` with the course code
   pre-filled in the header.
9. Print a stage checklist with next steps.

**Idempotence:** re-running the script never overwrites existing files; only
missing files are created. Safe to re-run after adding new courses or
templates.

**Updates the progress tracker:** after a successful run, the script prints
a hint to update `course-design/progress.html` with the new course at
"Stage 1 — scaffold done." It does not auto-update the HTML.

## Validation script — `scripts/validate-course-design.sh`

**Usage:**
- `./scripts/validate-course-design.sh DSGN312` — single course
- `./scripts/validate-course-design.sh` — all courses found in `course-design/`

**Per-course checks:**

1. Folder exists at `course-design/<slug>/`.
2. Required files exist: `<slug>-source-analysis.md`,
   `<slug>-existing-materials-analysis.md`, `<slug>-authoring-plan.md`,
   `assignments/` directory.
3. **CLO coverage:** every CLO listed in `source/program-data.md` for the
   course is referenced by at least one assignment in `assignments/`. The
   `00-template-copy.md` is excluded from this check (it's the seed copy).
4. **No phantom CLOs:** each assignment's declared CLOs must exist on its
   course. Catches typos like "CLO 9" on a 6-CLO course.
5. **MLO union correctness:** each assignment's declared MLOs equal the
   union of MLOs of its declared CLOs (per `source/program-data.md`).
6. **Rubric alignment:** every CLO declared at the top of an assignment
   appears in at least one rubric row's `CLO(s)` column. Every CLO in the
   rubric appears in the top declaration.
7. **No template residue:** no `{{placeholder}}` strings, no instructional
   `>` callouts that should have been deleted before publishing.
8. **Existing-materials check resolved:** the ⚠ notice is gone OR the
   inventory has at least one file.

**Output format:** matches `validate-program-data.sh`:
- `  ok: <check>` per pass
- `FAIL: <check>` per failure
- exit 1 if any failure

**Aggregate behavior:** running with no argument prints a per-course
summary like "12 of 13 courses pass; DSGN 312 has 2 failures." Exits 0 if
all courses pass, exits 1 if any course fails.

**Out of scope:** semantic checks (rubric calibration, prose quality,
pedagogical soundness, tool currency). Those require human/AI judgment.

## `course-design/README.md`

Contents:

- Title + 1-paragraph overview
- Pipeline stages table (the 8-stage table above)
- Folder layout reference (the tree snippet above)
- Templates list with one-line description of each
- "How to use this system with Claude" — patterns that worked for DSGN 410
  (e.g., "ask Claude to read the source PDF and `program-data.md`, then
  produce the source-analysis doc; iterate")
- A single line linking to the HTML tracker:
  `Status across all 13 courses → see course-design/progress.html`

The README does NOT contain a tracker table. The HTML page is the only place
that data lives.

## `course-design/progress.html`

A standalone single-file HTML page. Same architectural pattern as
`program-overview.html`: inline CSS + JS, no framework, no build step. Reads
its data from an inline JS array (no fetch).

**Visual parity with the existing app:**
- Imports the same Font Awesome CDN
- Reuses the color palette (Indigo Velvet, Pale Oak, Tech Blue, etc.)
- Defaults to dark mode with a light/dark toggle
- Same nav chrome and font choices

**Page contents:**

- Header — title "Course Design Progress" + subtitle "Internal authoring
  tracker — DC Graphic Design BA"
- Summary stats row — total courses, courses started, courses validated,
  total assignments authored (computed from inline data)
- Tracker table — one row per course:
  | Course | Title | Stage | Assignments authored | Notes / blockers |
  Stage column is a styled pill with a domain-style color (Foundational →
  blue, Intermediate → purple, etc., or per-stage colors).
- Inline JS array `courses[]` is the source of truth. Manually maintained.
  Updated by hand when stage advances.

**Hosting:** opened locally via the same `python3 -m http.server` workflow
already used for `program-overview.html`, OR via `file://` (since there is
no fetch).

## Risks and open questions

- **Manual tracker drift.** The HTML tracker is hand-maintained. If forgotten
  to update, it lies. Mitigation: stage advancement is part of the pipeline
  checklist; small enough scope (13 rows) that drift is correctable in
  minutes.
- **textutil dependency.** The scaffold's `.docx` extraction relies on the
  macOS-bundled `textutil`. If the user moves to Linux, this breaks.
  Mitigation: gracefully fall back to skipping extraction, just inventorying
  filenames. Documented in the script.
- **Course-folder naming convention drift.** Existing source folders don't
  match `program-data.md` headings exactly (e.g., `DSGN 410 Business of
  Graphic Design/` vs. `DSGN 410 — The Business of Graphic Design`). The
  scaffold uses a fuzzy `DSGN NNN*` glob and accepts the first match.
  Multiple matches → script lists them and asks the user to rename for
  consistency.
- **`assignments/00-template-copy.md` semantics.** This file is a starter
  copy and should not be counted as a real assignment by the validator
  (rule 3 above). The validator must explicitly skip it.

## Out of scope (recap)

- Modifying `program-overview.html`.
- Authoring course content under any course folder.
- Auto-publishing assignments to an external system.
- AI-assisted semantic review of assignments.
- Auto-generating the HTML tracker from MD or JSON sources.

## Next step

Hand off to the writing-plans skill to create the implementation plan
(scaffold script, validate script, three new templates, README, and
progress.html).

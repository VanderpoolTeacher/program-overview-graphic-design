# Course Design — DC Graphic Design BA

Internal workspace for authoring course content (assignments, syllabi,
schedules) for the 13 core DSGN courses. The canonical course data lives
in `../source/program-data.md`; this folder is where derived course
content is built up over time.

## Status

Per-course progress tracker → **[`progress.html`](./progress.html)**.

Open it in a browser (e.g., `python3 -m http.server` from the repo root,
then visit `http://localhost:8000/course-design/progress.html`). The
tracker is hand-maintained — update the `courses` array in
`progress.html` as work advances.

## Pipeline

| Stage | Action | Output |
|---|---|---|
| 0 — Sanity check | `grep "^## DSGN NNN" ../source/program-data.md` | (verification) |
| 1 — Scaffold | `../scripts/scaffold-course.sh DSGN_NNN` | Folder + stamped templates |
| 2 — Existing-materials review | Inspect `../source/` for matching folder; resolve `*-existing-materials-analysis.md` (replace ⚠ notice or fill in inventory) | Filled or "confirmed none" doc |
| 3 — Source analysis | Fill in `*-source-analysis.md` (DSGN 410 is the canonical example) | Filled doc |
| 4 — Authoring plan | Fill in `*-authoring-plan.md` listing assignments to author with CLO map and priority | Filled doc |
| 4b — Course design document | Copy `templates/course-design-document-template.md` and fill it out for this course (Backward Design + 7 pedagogy frameworks). Open via the `Course Design Document` GitHub issue template. The "capstone" of the course-design artifacts — covers the WHOLE course, not a single assignment. | Filled doc; pedagogical contract for the course |
| 5 — Author assignments | Per planned assignment, copy `assignments/00-template-copy.md` and fill it out | One MD per assignment |
| 5b — Author weekly modules | Per week of class, copy `templates/weekly-module-template.md` to `weeks/week-NN.md` and fill it out (lesson plan, in-class interactive, readings, reference to that week's formative) | One MD per week |
| 6 — Validate | `../scripts/validate-course-design.sh DSGN_NNN` | Pass/fail report |
| 7 — Review | Walk the author's checklist at the bottom of each assignment | Checked-off lists |
| 8 — Publish | (External — LMS / syllabus / Google Doc) | (Out of scope here) |

Stage 2 is **non-skippable**. Even courses with no existing materials
must produce a `*-existing-materials-analysis.md` that explicitly says
"Confirmed none on YYYY-MM-DD" — otherwise the validator fails.

## Folder layout

```
course-design/
├── README.md                  # this file
├── progress.html              # canonical per-course progress tracker
├── templates/
│   ├── assignment-template.md
│   ├── source-analysis-template.md
│   ├── existing-materials-analysis-template.md
│   ├── authoring-plan-template.md
│   ├── course-design-document-template.md
│   └── weekly-module-template.md
├── pedagogy/                  # the 7 framework references
└── <course-slug>/             # one per course as work progresses
    ├── <course>-source-analysis.md
    ├── <course>-existing-materials-analysis.md
    ├── <course>-authoring-plan.md
    ├── <course>-course-design-document.md
    ├── assignments/
    │   ├── 00-template-copy.md  # fresh seed copy; not counted as a real assignment
    │   ├── 01-<slug>.md
    │   └── ...
    └── weeks/
        ├── week-01.md           # one per week of class — lesson + interactive + readings
        ├── week-02.md
        └── ...
```

## Templates

- **`assignment-template.md`** — one per assignment. Bakes in three-level
  CLO mapping (header block, inline tags, rubric column) and a
  4-point competency rubric.
- **`source-analysis-template.md`** — codifies what the source documents
  (`source/program-data.md`, the program-design PDF) say about a course,
  with patterns and gaps called out. The scaffold script pre-fills the
  course shape table and verbatim purpose paragraph.
- **`existing-materials-analysis-template.md`** — catalogues any
  pre-existing assignment docs found under `source/<course folder>/`,
  maps them to CLOs, and flags gaps. Pre-filled with file inventory.
- **`authoring-plan-template.md`** — lists the assignments to author for
  a course, mapped to CLOs, with priority and time estimates.
- **`course-design-document-template.md`** — comprehensive *course-level*
  design document built on Backward Design with all 7 pedagogy
  frameworks deliberately applied. Covers the WHOLE course — not a
  single assignment. The pedagogical contract for a course; drives
  every subsequent assignment and rubric. Use the GitHub issue template
  `.github/ISSUE_TEMPLATE/course-design-document.md` to start the work
  for a new course. DSGN 410 is the canonical worked example.
- **`weekly-module-template.md`** — one per week of class. Bundles
  learning goals, pre-class readings, lesson plan (50-min structure
  with timed segments), the in-class interactive activity, the
  formative deliverable due that week, and instructor's notes. The
  unit teachers actually plan and deliver from.

## How to use this system with Claude

The DSGN 410 work this week is the proof-of-concept. The pattern that
worked:

1. Run the scaffold script to set up the folder.
2. Ask Claude to read `source/program-data.md` (for the course's CLOs +
   purpose) and the program-design PDF (for fuller context). Then ask:
   "produce the source-analysis doc per the template, focusing on
   patterns and gaps."
3. If existing materials exist, run `textutil` (the scaffold does this
   automatically into `.cache/`) and ask Claude to read those files and
   produce the existing-materials-analysis doc.
4. Ask Claude to draft an authoring plan based on (2) and (3), with
   priority and CLO coverage explicit.
5. For each assignment in the plan, copy `assignments/00-template-copy.md`
   to a numbered file and ask Claude to fill it out — paying attention to
   the three-level CLO mapping and the rubric alignment rule.
6. Run the validator. Fix anything that fails.
7. Update `progress.html` to reflect the new stage.

## Validation

Run from repo root:

```bash
./scripts/validate-course-design.sh DSGN410   # one course
./scripts/validate-course-design.sh           # all courses
```

The validator checks:
- Required folder + files present
- CLO coverage (every CLO has at least one assignment)
- No phantom CLOs (assignments only reference CLOs that exist)
- Rubric alignment (every CLO at top of an assignment is in its rubric and vice versa)
- No `{{placeholder}}` residue
- Existing-materials check is resolved

It does NOT check semantic quality (rubric calibration, prose
readability, pedagogical soundness, tool currency). Those need human
or AI judgment.

---
name: Course Design Document
about: Comprehensive course-level design document for a single DSGN course (Backward Design + 7 pedagogy frameworks). Covers the WHOLE course, not a single assignment.
title: 'Build course design document for DSGN NNN'
labels: course-design
assignees: ''
---

## Course

**DSGN NNN — [Title]**

| | |
|---|---|
| Level | <!-- Foundational / Intermediate / Advanced / Capstone --> |
| Credits | <!-- per source/program-data.md Plan of Study --> |
| MLOs covered | <!-- pull from program-data.md --> |
| CLO count | <!-- pull from program-data.md --> |

## Goal

Produce a comprehensive **course design document** for DSGN NNN that:

- Begins with the end in mind (Stage 1 — desired results, before any instruction is planned)
- Names what graduates of the course can do *in the world* (transfer goals)
- Surfaces the enduring understandings the course should leave behind
- Maps every CLO to evidence (Stage 2) and every CLO to instruction (Stage 3)
- Visibly applies all 7 pedagogy frameworks (Backward Design, Bloom's, Merrill, Kolb, Schön, Hattie & Timperley, Critical Pedagogy / Design Justice)
- Engages honestly with whose competence is being certified and whose voice is centered

The completed document is the **pedagogical contract** for the course — the spec that any subsequent assignment authoring must align with.

## Inputs available

- [ ] `source/program-data.md` — canonical CLOs, MLOs, course purpose
- [ ] `course-design/dsgn-NNN/dsgn-NNN-source-analysis.md` — *(does this exist? if not, scaffold first)*
- [ ] `course-design/dsgn-NNN/dsgn-NNN-existing-materials-analysis.md` — *(if existing materials are present in `source/DSGN NNN*/`)*
- [ ] `course-design/pedagogy/` — the 7 framework references
- [ ] `course-design/templates/course-design-document-template.md` — the template

## Tasks

- [ ] **Scaffold** (if not already done): `./scripts/scaffold-course.sh DSGNNNN`
- [ ] **Read inputs:** source-analysis, existing-materials-analysis, and the relevant pedagogy framework files
- [ ] **Copy template:** `cp course-design/templates/course-design-document-template.md course-design/dsgn-NNN/dsgn-NNN-course-design-document.md`
- [ ] **Stage 1 — Desired Results** (transfer goals, enduring understandings, essential questions, Bloom's analysis, Design Justice lens)
- [ ] **Stage 2 — Acceptable Evidence** (performance task, multiple measures, course-level rubric, feedback structure)
- [ ] **Stage 3 — Learning Plan** (course arc, Merrill, Kolb, Schön, Design Justice in practice, course connections)
- [ ] **Open questions** documented honestly (at least 3 substantive items)
- [ ] **Author's checklist** at bottom of the doc walked through
- [ ] **Update progress tracker:** advance DSGN NNN's stage in `course-design/progress.html`

## Acceptance criteria

The design document is complete when:

- All `{{placeholders}}` are filled in and all `>` instructional callouts are deleted
- Every CLO listed in `source/program-data.md` for this course appears in Stage 1, in Stage 2's evidence, and in Stage 3's learning plan
- Each of the 7 pedagogy frameworks is engaged in the section where it belongs (not just name-dropped)
- The Design Justice section honestly answers whose competence is centered and whose is absent — not generic platitudes
- Open questions are real, not boilerplate

## Out of scope (handle in follow-up issues)

- Authoring the actual assignments (use `assignment-template.md`)
- Building the weekly schedule
- Running `validate-course-design.sh` (requires assignments to exist first)

## References

- Template: [`course-design/templates/course-design-document-template.md`](../../course-design/templates/course-design-document-template.md)
- Pedagogy folder: [`course-design/pedagogy/`](../../course-design/pedagogy/)
- Canonical course data: [`source/program-data.md`](../../source/program-data.md)

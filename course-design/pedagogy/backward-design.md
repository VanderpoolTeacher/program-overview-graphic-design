# Backward Design / Understanding by Design (UbD)

> Wiggins & McTighe (2005). The framework that says: design from the
> outcomes back, not from activities forward. The single most influential
> idea in the assignment template.

## Overview

Wiggins and McTighe's Understanding by Design reorients curriculum
planning away from content coverage toward three sequential stages.
**Stage 1** — identify desired results. What enduring understandings
and transfer goals should students leave with? **Stage 2** — determine
acceptable evidence. What performance tasks and assessments will confirm
understanding? **Stage 3** — plan learning experiences. *Only then*
design instruction and sequence.

The "backward" logic is especially powerful in studio courses, where
defining what professional-level design thinking looks like *before*
building assignments prevents the common trap of activity-rich but
learning-light projects.

## Core concepts

### The three stages

```
Stage 1: Desired results        →   Stage 2: Evidence       →   Stage 3: Learning plan
(transfer goals, big ideas,         (performance tasks,         (instruction,
 essential questions, CLOs)         rubrics, criteria)          activities, sequencing)
```

You write Stages 1 and 2 first. Stage 3 only happens once 1 and 2 are
locked. Most course-design failures come from skipping straight to
Stage 3.

### Six facets of understanding

UbD distinguishes "understanding" from mere knowing. A student who
*understands* can: **explain**, **interpret**, **apply**, see in
**perspective**, show **empathy**, and demonstrate **self-knowledge**.
A multiple-choice quiz tests recall; designing a campaign for a
stakeholder you disagree with tests perspective and empathy.

### Essential questions

UbD recommends each unit be organized around 1–3 *essential questions* —
open-ended questions that recur throughout the discipline (e.g., "How
do design choices encode power?"). Essential questions structure
instruction without dictating answers, and they generally outlast any
specific assignment.

### Two-pass planning

UbD authors typically draft Stage 1 broadly, then return to it after
roughing Stage 2; the act of designing assessment evidence usually
sharpens the desired results. The same is true for Stage 3 → 2: when
instruction is sketched, gaps in the evidence become visible.

## How it applies to DSGN course design

The DSGN course system encodes UbD directly:

- **`source/program-data.md`** captures Stage 1 at the program level —
  MLOs are the program's "desired results."
- **Per-course CLOs in `program-data.md`** are Stage 1 at the course
  level — what each course's enduring understandings are.
- **The assignment template's "Learning Outcome Mapping" block + the
  rubric** are Stage 2 — declared evidence that the CLOs are met.
- **The assignment's "Instructions" + "Tools"** are Stage 3 — only
  filled in once 1 and 2 are clear.

The validator (`scripts/validate-course-design.sh`) enforces the UbD
ordering by failing any assignment whose declared CLOs aren't in the
rubric, or whose rubric exercises CLOs not declared. That alignment
*is* Backward Design at the assignment level.

### Concrete example — DSGN 410 CLO 5

CLO 5 reads: *"Communicate business strategy through branded content,
data visualizations, and presentations."*

- Stage 1 says: students should leave able to communicate strategy
  visually with data.
- Stage 2 says: an assignment must produce a deliverable that *shows*
  this — a pitch deck with at least one data visualization, evaluated
  on a rubric whose criteria probe accuracy, clarity, and persuasion.
- Stage 3 (the syllabus week) only happens after the rubric exists.
  Lectures + tools + readings get chosen *because they prepare students
  for that specific deliverable* — not because they cover related
  topics generally.

Authoring an assignment without doing Stage 1 and 2 first is the most
common mistake. The template is designed to make that mistake awkward.

## Questions for assignment authors (UbD checklist)

When filling out the assignment template, ask:

- [ ] **Stage 1 — Desired results:** What CLOs does this assignment
      address? Are they verbatim from `source/program-data.md`?
- [ ] **Stage 1 — Transfer:** What will the student be able to do in a
      *new* situation after this — not just the situation they were
      taught?
- [ ] **Stage 1 — Essential question:** Is there an essential question
      this assignment lives inside? (Not always required, but helpful
      for cohesion across assignments.)
- [ ] **Stage 2 — Evidence:** Does the deliverable actually *show*
      mastery of the CLOs, or does it test something tangential?
- [ ] **Stage 2 — Rubric alignment:** Does every CLO listed at the top
      have at least one rubric row? Does every rubric row reference at
      least one declared CLO?
- [ ] **Stage 2 — Six facets:** Which of the six facets of
      understanding does this exercise? (Designing for explain +
      apply only is fine; just make it conscious.)
- [ ] **Stage 3 — Sequencing:** Once Stages 1 and 2 are locked, do the
      tools, readings, and instructions trace clearly to the
      deliverable? Anything not traceable should probably be cut.
- [ ] **Critique check:** Does this assignment reduce to "doing the
      activity" without producing transferable understanding? If so,
      Stage 2 is too thin.

## Sources

- **Wiggins, G., & McTighe, J. (2005).** *Understanding by Design*
  (2nd ed.). ASCD. ISBN 978-1-4166-0035-0.
  <https://www.ascd.org/books/understanding-by-design-expanded-2nd-edition>
  *Annotation:* The expanded and definitive seminal text. Part I lays
  out all three stages; Part II applies them to unit and course design.
  Open-access PDF widely mirrored online; confirm institutional
  permissions before assigning.

- **McTighe, J., & Wiggins, G. (2012).** *Understanding by Design®
  Framework.* ASCD White Paper.
  <https://files.ascd.org/staticfiles/ascd/pdf/siteASCD/publications/UbD_WhitePaper0312.pdf>
  *Annotation:* Concise practitioner-facing overview (20 pp.) that
  operationalizes the three-stage framework with example templates and
  essential-question prompts. The clearest fast read for a faculty
  member building their first UbD unit. Open access.

- **Meesuk, P., Sramoon, B., & Wongrugsa, A. (2021).** *Findings of
  qualitative studies on Understanding by Design: A meta-synthesis.*
  International Journal of Curriculum and Instructional Studies, 11(2),
  167–194. <https://files.eric.ed.gov/fulltext/EJ1329091.pdf>
  *Annotation:* Meta-synthesis of 12 qualitative studies on UbD
  implementation; finds consistent evidence that UbD improves
  cognitive development and student engagement, while also documenting
  recurring barriers (faculty inexperience with the model, inadequate
  pedagogy knowledge). Useful for calibrating realistic expectations.
  Open access via ERIC.

- **Burgess, A., & Mellis, C. (2015).** *Understanding by Design: A
  Framework for Effecting Curricular Development and Assessment.*
  Academic Medicine.
  <https://pmc.ncbi.nlm.nih.gov/articles/PMC1885909/>
  *Annotation:* Applied case study showing UbD implementation in a
  higher-education professional program; details how Stage 1 enduring
  understandings map to program learning outcomes and accreditation
  requirements — directly transferable logic for a BA program's
  programmatic assessment design. Open access via PubMed Central.

- **Lin, C.-H., et al. (2025).** *The stability and acceptance of the
  "System of Competency-Based Curriculum Design" framework: Perspectives
  of teachers.* The Curriculum Journal.
  <https://doi.org/10.1002/curj.265>
  *Annotation (critique):* Develops an alternative framework (SCCD) to
  address UbD's limitations in competency-based settings. Argues that
  UbD's "understanding" construct is discipline-biased (rooted in
  English/literacy education) and does not map cleanly onto skill-heavy
  fields. Relevant caution for graphic-design program directors aligning
  to NASAD competencies. Paywalled via Wiley; abstract free.

# Bloom's Taxonomy (Revised)

> Anderson & Krathwohl (Eds.) (2001). The framework that drives the
> *verbs* in your learning outcomes. The MLOs in `program-data.md` are
> already Bloom-aligned — this file makes that explicit so verb choice
> stays intentional.

## Overview

The revised taxonomy restructures Bloom's original 1956 hierarchy in
two important ways: it converts the categories from *nouns* to
*action verbs* (Remember, Understand, Apply, Analyze, Evaluate,
Create), and it adds an orthogonal **Knowledge Dimension** (Factual,
Conceptual, Procedural, Metacognitive). The result is a two-dimensional
**Taxonomy Table** — a grid that pairs *what* knowledge is being
worked with against *how* the learner is using it.

For DSGN, this is the framework that makes "use industry-standard
software to produce design files" (Apply / Procedural) genuinely
different from "evaluate brand effectiveness through case studies"
(Evaluate / Conceptual). Both are valid — but they require different
instruction and different evidence.

## Core concepts

### The Cognitive Process Dimension (six levels)

The verbs run from concrete to abstract:

| Level | Cognitive process | DSGN-flavored example |
|---|---|---|
| 1. Remember | Retrieve from memory | "List the principles of typographic hierarchy." |
| 2. Understand | Construct meaning | "Explain why a serif typeface reads differently than a sans-serif." |
| 3. Apply | Carry out a procedure | "Use Illustrator to produce a vector logo." |
| 4. Analyze | Break into parts; see structure | "Compare two brand systems and identify what distinguishes them." |
| 5. Evaluate | Make judgments based on criteria | "Critique a packaging design for usability and sustainability." |
| 6. Create | Produce something new | "Design a campaign that integrates brand strategy and visual system." |

**Important:** The levels are not strictly hierarchical — Create
doesn't require mastery of every prior level for that exact content.
But higher levels generally rely on at least some lower-level
proficiency.

### The Knowledge Dimension (four types)

| Type | What it is | DSGN example |
|---|---|---|
| Factual | Discrete elements | Names of typefaces; CMYK vs RGB |
| Conceptual | Frameworks, theories, models | Visual hierarchy principles; brand strategy |
| Procedural | Methods, techniques, skills | How to set up a print file; how to run a design-thinking sprint |
| Metacognitive | Knowledge about cognition | Knowing your own design process; recognizing when to seek feedback |

A well-rounded program develops all four types. A program that
emphasizes Procedural and Factual at the expense of Conceptual and
Metacognitive produces technicians, not designers.

### The Taxonomy Table

Plotting your CLOs on a grid (rows = Knowledge Dimension, columns =
Cognitive Process) reveals coverage gaps. If every CLO falls in
"Apply / Procedural," you're not building a designer. If every CLO
falls in "Evaluate / Conceptual," you're not building a maker.

## How it applies to DSGN course design

### MLOs are already Bloom-aligned (verify the verbs)

Open `source/program-data.md` and look at the MLO verbs:
- MLO 1 — **Apply** the principles of design thinking…
- MLO 2 — **Demonstrate** proficiency…
- MLO 3 — **Analyze** and **interpret** client needs…
- MLO 4 — **Design** [= Create] compelling user interfaces…
- MLO 5 — **Create** data visualizations…
- MLO 6 — **Construct** [= Create] a professional portfolio…
- MLO 7 — **Collaborate** [= Apply procedural and metacognitive knowledge]…
- MLO 8 — **Demonstrate** entrepreneurial thinking…

Most of the MLOs are at Apply, Analyze, or Create — appropriate for a
bachelor's-level program. Note: the program *under-emphasizes
Evaluate* compared to other levels. That's worth raising — designers
need to develop critical judgment.

### When writing CLOs, choose the verb deliberately

Generic verbs like "understand," "know," "learn" are unmeasurable.
Replace with a Bloom verb that names exactly what the student should
*do*:

| Avoid | Replace with |
|---|---|
| "Understand the design process" | "Explain the stages of design thinking" (Understand) or "Apply the design thinking process to a real-world brief" (Apply) |
| "Know typography" | "Identify the parts of a typeface and explain their function" (Understand / Conceptual) |
| "Learn Illustrator" | "Use Illustrator to produce vector-based illustrations" (Apply / Procedural) |

The validator doesn't enforce verb quality — but the assignment author
checklist below does.

### Plot CLOs on the Taxonomy Table

For each course, plot its CLOs on the grid. If they cluster in one
cell, the course is too narrow. If they spread across the table, the
course is doing the right structural work.

Example — DSGN 220 (Design Thinking) CLOs roughly map to:
| | Remember | Understand | Apply | Analyze | Evaluate | Create |
|---|---|---|---|---|---|---|
| Factual | | | | | | |
| Conceptual | | | CLO 1 | CLO 2 | | |
| Procedural | | | CLO 1, 4 | | | CLO 4 |
| Metacognitive | | | CLO 5, 6 | CLO 3 | | |

Good spread. Notably no Evaluate, which matches the program-level
under-emphasis.

## Questions for assignment authors (Bloom's checklist)

- [ ] **Verb intentionality:** Does each CLO use a Bloom-aligned verb?
      Are "understand / know / learn" replaced with measurable
      verbs?
- [ ] **Cognitive level appropriate:** Does the verb match the actual
      cognitive level the assignment exercises? (A "Create"
      assignment can't be assessed by a multiple-choice quiz.)
- [ ] **Knowledge type appropriate:** Is the knowledge being worked
      with primarily Factual, Conceptual, Procedural, or
      Metacognitive? Does the deliverable evidence work in that
      type?
- [ ] **Coverage check:** Across all CLOs in the course, are at least
      three Bloom levels represented? Are at least two Knowledge
      types represented?
- [ ] **Rubric alignment:** Do the rubric descriptors match the
      cognitive level of the CLO? (A rubric that says "list" for an
      "evaluate"-level CLO is misaligned.)
- [ ] **Visual-discipline note:** Visual analysis often gets stuck at
      Understand/Apply. Push at least one CLO per course toward
      Analyze, Evaluate, or Create on visual content specifically
      (cf. Arneson & Offerdahl 2018 in the bibliography).

## A note on critique

Larsen et al. (2022) tested the taxonomy's internal assumptions
empirically and found that (a) the Cognitive Process and Knowledge
dimensions are not always independent, and (b) action verbs do not
reliably signal cognitive level — "analyze" can be used for tasks
that are operationally Apply or Evaluate.

**Practical implication:** don't trust the verb alone. Evaluate the
*full task context* — what the student must actually do — when
deciding the cognitive level of an assignment. The taxonomy is a
helpful scaffold for verb choice, not a deterministic classifier.

## Sources

- **Anderson, L. W., & Krathwohl, D. R. (Eds.). (2001).** *A Taxonomy
  for Learning, Teaching, and Assessing: A Revision of Bloom's
  Taxonomy of Educational Objectives.* Longman.
  *Annotation:* The seminal revision introducing the verb-based
  six-level framework and the Knowledge Dimension matrix. The primary
  reference for drafting graphic-design program learning outcomes.
  Print/library access.

- **Krathwohl, D. R. (2002).** *A revision of Bloom's taxonomy: An
  overview.* Theory Into Practice, 41(4), 212–218.
  <https://doi.org/10.1207/s15430421tip4104_2>
  *Annotation:* The most-cited accessible summary of the revision,
  written by one of its editors. Essential practical reading for any
  instructor using the taxonomy to draft outcomes; concise enough to
  assign as a faculty-development reading. Paywalled; free PDF widely
  available (e.g., people.ucsc.edu).

- **Arneson, J. B., & Offerdahl, E. G. (2018).** *Visual literacy in
  bloom: Using Bloom's taxonomy to support visual learning skills.*
  CBE—Life Sciences Education, 17(1), ar7.
  <https://doi.org/10.1187/cbe.17-08-0178>
  *Annotation:* Develops a Visualization Blooming Tool that adapts
  the taxonomy specifically for visual representations. Though the
  source discipline is biochemistry, the scaffold for image
  interpretation and creation is directly applicable to
  graphic-design courses. Open access.

- **Larsen, T. M., Endo, B. H., Yee, A. T., Do, T., & Lo, S. M.
  (2022).** *Probing internal assumptions of the revised Bloom's
  taxonomy.* CBE—Life Sciences Education, 21(4), ar66.
  <https://doi.org/10.1187/cbe.20-08-0170>
  *Annotation (critique):* Empirically tests whether the taxonomy's
  two dimensions are truly independent and whether action verbs
  reliably signal cognitive level — both are found problematic.
  Critical for any program coordinator writing rubrics: do not depend
  on the verb alone; evaluate the full task context. Open access.

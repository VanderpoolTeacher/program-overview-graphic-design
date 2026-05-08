# Program Data Source of Truth — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extract the contents of `source/DC Graphic Design Major Design Document.pdf` into a single canonical Markdown file (`source/program-data.md`) following the conventions and content decisions in `docs/superpowers/specs/2026-05-07-program-data-source-of-truth-design.md`.

**Architecture:** One human-readable Markdown file with YAML frontmatter at the top (program metadata + domains) and three top-level sections — `# Program Learning Outcomes (MLOs)`, `# Courses`, `# Plan of Study`. Course-level metadata lives in fenced `yaml` blocks under each course heading. CLOs are numbered list items each followed by a `→ MLOs: N, N, N` line. No build step, no app changes — this work creates the data file only.

**Tech Stack:** Plain Markdown, YAML, Bash for validation. The HTML app stays untouched in this plan.

---

## File Structure

| Path | Action | Responsibility |
|---|---|---|
| `source/program-data.md` | Create | Canonical source of truth — MLOs, courses, CLOs, plan of study |
| `source/DC Graphic Design Major Design Document.pdf` | Read-only | Reference (extract content from this) |
| `README.md` | Modify | Append one-line entry pointing to the new source file |
| `scripts/validate-program-data.sh` | Create | Content lint — counts, malformed CLO lines, find/replace residue |

---

## Critical content decisions (re-stated from spec)

These diverge from the PDF and MUST be honored:

1. **DSGN 205 includes MLO 5.** Course `mlos: [1, 2, 3, 4, 5, 6, 7, 8]`. CLO 2 → `1, 3, 4, 5`; CLO 4 → `1, 3, 5, 6`.
2. **DSGN 310 CLO 3 includes MLO 5.** CLO 3 → `2, 4, 5, 6` (was `2, 4, 6` in PDF text).
3. **Find-and-replace fix.** Restore in copied prose: `exMLOre→explore`, `exMLOres→explores`, `exMLOred→explored`, `exMLOring→exploring`, `emMLOyment→employment`. Real `MLO 5` / `MLOs 1, 2` references are left alone.
4. **CLO wording is verbatim from the PDF** (after fix #3). Do not paraphrase as the current app does.

---

### Task 1: Scaffold `source/program-data.md`

**Files:**
- Create: `source/program-data.md`

- [ ] **Step 1: Create the file with top-level frontmatter + section skeletons**

Write the following exact content to `source/program-data.md`:

````markdown
---
program: DC Graphic Design (BA)
catalog: 2025–26
emphasis: Design thinking as core methodology
target_learner: High school graduates
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

<!-- Filled in Task 2 -->

# Courses

<!-- Foundational filled in Task 3, Intermediate Task 4, Advanced Task 5, Capstone Task 6 -->

# Plan of Study

<!-- Filled in Task 7 -->
````

- [ ] **Step 2: Verify file exists and frontmatter is valid YAML**

Run:
```bash
test -f source/program-data.md && head -20 source/program-data.md
```
Expected: First line is `---`, frontmatter renders as valid YAML, three `#` headings present.

- [ ] **Step 3: Commit**

```bash
git add source/program-data.md
git commit -m "Scaffold source/program-data.md with frontmatter and section headers"
```

---

### Task 2: Populate Program Learning Outcomes (MLOs)

**Files:**
- Modify: `source/program-data.md` (under `# Program Learning Outcomes (MLOs)`)

**Reference:** PDF page 3 (the "Draft Program Learning Outcomes" page).

- [ ] **Step 1: Replace the `<!-- Filled in Task 2 -->` placeholder with all 8 MLOs**

Each MLO uses this format. Description text is verbatim from the PDF.

```markdown
## MLO 1 — Design Thinking
**Domain:** Conceptual

Apply the principles of design thinking to solve complex visual communication problems across diverse media and user contexts.

## MLO 2 — Tools & Tech
**Domain:** Technical

Demonstrate proficiency in industry-standard graphic design tools and technologies to create effective visual solutions.

## MLO 3 — User-Centered Design
**Domain:** Conceptual

Analyze and interpret client needs, user behavior, and market data to inform user-centered design decisions.

## MLO 4 — UX/UI Design
**Domain:** Technical

Design compelling user interfaces and experiences that integrate accessibility, usability, and aesthetics.

## MLO 5 — Data Visualization
**Domain:** Applied

Create data visualizations that translate complex information into clear, engaging, and ethically responsible visual narratives.

## MLO 6 — Portfolio & Process
**Domain:** Professional

Construct a professional portfolio that showcases conceptual strength, technical skill, and process fluency across a range of design projects.

## MLO 7 — Collaboration & Comms
**Domain:** Professional

Collaborate effectively in multidisciplinary teams, applying project management and communication strategies used in creative industries.

## MLO 8 — Entrepreneurship
**Domain:** Professional

Demonstrate entrepreneurial thinking and freelancing readiness by developing design solutions that consider branding, business goals, and client engagement.
```

- [ ] **Step 2: Verify there are exactly 8 `## MLO ` headings**

Run:
```bash
grep -c "^## MLO " source/program-data.md
```
Expected: `8`

- [ ] **Step 3: Commit**

```bash
git add source/program-data.md
git commit -m "Add 8 program-level MLOs"
```

---

### Task 3: Add Foundational courses (DSGN 114, 105, 107)

**Files:**
- Modify: `source/program-data.md` (under `# Courses`)

**Reference:** PDF pages 7–14 (DSGN 114), 15–18 (DSGN 105), 19–22 (DSGN 107). Each course in the PDF has: a Course Purpose page, a CLO bullet page, and a per-CLO matrix page.

**Conventions (apply to every course in this and the following tasks):**
- Heading: `## DSGN NNN — Title` (em-dash, not hyphen)
- Single fenced ```yaml``` block immediately under the heading with `level:` and `mlos:`
- `**Purpose.**` paragraph next, **summarized in one or two sentences from the PDF's Course Purpose bullets** (the Purpose is the only place where summarization is allowed — CLOs stay verbatim)
- `**Course Learning Outcomes**` then a numbered list. Each CLO uses the PDF's verbatim wording, followed by a separate line `   → MLOs: N, N, N` (3-space indent, then arrow + `MLOs:` + comma-space list)
- `mlos:` in the YAML block is the union of MLOs across that course's CLOs (not separately authored)

**Find/replace fixes:** before pasting any prose, replace `exMLOre→explore`, `exMLOres→explores`, `exMLOred→explored`, `exMLOring→exploring`, `emMLOyment→employment`.

- [ ] **Step 1: Add DSGN 114**

Replace the foundational placeholder with:

````markdown
## DSGN 114 — Intro to Graphic Design

```yaml
level: Foundational
mlos: [1, 2, 4, 6, 7]
```

**Purpose.** First formal exposure to graphic design as a discipline — core design principles (contrast, alignment, hierarchy), visual literacy and critique, introduction to composition, typography, and layout, and initial project work using digital tools.

**Course Learning Outcomes**

1. Identify and apply fundamental design principles (e.g., balance, contrast, alignment) in visual compositions.
   → MLOs: 1, 2
2. Create graphic design projects that demonstrate effective visual hierarchy, typography, and composition for print and screen.
   → MLOs: 2, 4
3. Use industry-standard design software to produce, revise, and export design files for professional presentation.
   → MLOs: 2
4. Analyze and critique visual design using appropriate terminology and conceptual frameworks.
   → MLOs: 1, 6
5. Design and deliver visual presentations that clearly communicate design intent and process to peers and clients.
   → MLOs: 6, 7
6. Demonstrate an iterative design process through sketches, drafts, peer critique, and self-reflection.
   → MLOs: 1, 6, 7
````

- [ ] **Step 2: Add DSGN 105**

Append below DSGN 114:

````markdown
## DSGN 105 — Digital Imaging

```yaml
level: Foundational
mlos: [1, 2, 4, 6, 7, 8]
```

**Purpose.** Core digital imaging tools and editing techniques (raster-based, e.g., Photoshop): image editing/correction/manipulation, resolution and file formats, composition for screen and print, ethical use of imagery, and foundations of visual storytelling.

**Course Learning Outcomes**

1. Use industry-standard software to create, edit, and manipulate raster-based digital images for print and screen.
   → MLOs: 2
2. Demonstrate an understanding of image resolution, file formats, and color systems in the production of digital graphics.
   → MLOs: 2, 6
3. Apply compositional principles and visual hierarchy in the creation of digital imagery.
   → MLOs: 1, 2
4. Edit and retouch photographs to enhance visual clarity, consistency, and communicative impact.
   → MLOs: 2, 4
5. Evaluate digital images for clarity, ethical use, and appropriateness in professional design contexts.
   → MLOs: 6, 7, 8
6. Use generative AI tools to create, remix, and enhance digital images, applying ethical considerations and creative intent.
   → MLOs: 2, 6, 8
````

- [ ] **Step 3: Add DSGN 107**

Append below DSGN 105:

````markdown
## DSGN 107 — Digital Illustration

```yaml
level: Foundational
mlos: [1, 2, 3, 4, 5, 6, 7, 8]
```

**Purpose.** Vector-based illustration (e.g., Illustrator) — creating original illustrations for communication, vector drawing and shape-building, style development and visual storytelling, design for branding/icons/infographics/editorial, with some integration into print or motion workflows.

**Course Learning Outcomes**

1. Create original vector-based illustrations using industry-standard software and techniques.
   → MLOs: 2
2. Apply design principles to illustrate concepts, narratives, or messages with clarity and visual impact.
   → MLOs: 1, 4, 6
3. Demonstrate proficiency in shape-building, path editing, layering, and color workflows within a digital illustration environment.
   → MLOs: 2, 6
4. Develop a personal illustration style through iterative practice, critique, and reflection.
   → MLOs: 1, 6, 7
5. Design illustrations for use in branding, infographics, packaging, or other professional design contexts.
   → MLOs: 4, 5, 8
6. Apply user-centered design strategies when creating infographics or visual narratives to enhance audience understanding.
   → MLOs: 1, 3, 5
7. Use AI-assisted tools to generate, refine, or remix illustrative content while applying ethical and creative judgment.
   → MLOs: 2, 6, 8
````

- [ ] **Step 4: Verify three `## DSGN ` headings exist and the CLO count is correct**

Run:
```bash
grep -c "^## DSGN " source/program-data.md
```
Expected: `3`

```bash
awk '/^## DSGN /{c=$2} /→ MLOs:/{n[c]++} END{for(k in n) print k, n[k]}' source/program-data.md
```
Expected: `DSGN 114 6`, `DSGN 105 6`, `DSGN 107 7` (in any order).

- [ ] **Step 5: Commit**

```bash
git add source/program-data.md
git commit -m "Add foundational courses (DSGN 114, 105, 107)"
```

---

### Task 4: Add Intermediate courses (DSGN 205, 220, 230)

**Files:**
- Modify: `source/program-data.md`

**Reference:** PDF pages 23–26 (DSGN 205), 27–30 (DSGN 220), 31–34 (DSGN 230).

**⚠ Critical decision applies:** DSGN 205 includes MLO 5 in its course-level `mlos:` (the PDF's cumulative matrix omits it; we follow the per-CLO matrix and the summary highlights). CLO 2 already has MLOs 1, 3, 4, 5 in the PDF text and CLO 4 already has 1, 3, 5, 6 — leave those verbatim.

- [ ] **Step 1: Add DSGN 205 (with MLO 5 included)**

Append below DSGN 107:

````markdown
## DSGN 205 — Page Layout

```yaml
level: Intermediate
mlos: [1, 2, 3, 4, 5, 6, 7, 8]
```

**Purpose.** Organizing text and images on the page (print or digital) using layout, typography, and grid systems — editorial and publication design, multi-page documents, typographic hierarchy, grids and modular structures, file prep, accessibility and readability.

**Course Learning Outcomes**

1. Design multi-page layouts using typographic hierarchy, alignment, spacing, and grid systems.
   → MLOs: 1, 2, 4, 8
2. Apply principles of visual organization to enhance readability, navigation, and user engagement in print and digital formats.
   → MLOs: 1, 3, 4, 5
3. Prepare layout files for professional output, including proper use of margins, bleeds, resolution, and file formats.
   → MLOs: 2, 6
4. Integrate imagery and text to communicate clear, consistent, and audience-aware messages.
   → MLOs: 1, 3, 5, 6
5. Critique and revise layouts based on feedback, focusing on clarity, hierarchy, and communication goals.
   → MLOs: 1, 6, 7
6. Use AI-assisted tools for layout generation or content styling while applying ethical and creative oversight.
   → MLOs: 2, 6, 8
````

- [ ] **Step 2: Add DSGN 220**

Append below DSGN 205:

````markdown
## DSGN 220 — Design Thinking

```yaml
level: Intermediate
mlos: [1, 2, 3, 4, 6, 7, 8]
```

**Purpose.** Cornerstone course in human-centered design as a structured process — empathy and user research, problem definition, ideation (e.g., brainstorming, SCAMPER), rapid prototyping and testing, feedback loops, systems thinking and stakeholder mapping, with applications in social innovation, UX, and business.

**Course Learning Outcomes**

1. Apply the design thinking process—including empathy, definition, ideation, prototyping, and testing—to solve complex user-centered challenges.
   → MLOs: 1, 3, 4
2. Conduct user research and stakeholder analysis to inform the framing of design problems.
   → MLOs: 1, 3
3. Generate and evaluate multiple design concepts through rapid ideation and feedback cycles.
   → MLOs: 1, 6, 7
4. Develop low- and high-fidelity prototypes that explore possible solutions and communicate ideas effectively.
   → MLOs: 2, 4, 6
5. Collaborate within interdisciplinary teams to iterate and refine design concepts based on user insights.
   → MLOs: 3, 6, 7
6. Use AI tools to assist in ideation, prototyping, or user research while applying ethical design practices.
   → MLOs: 2, 3, 6, 8
````

Note: PDF CLO 4 reads "exMLOre possible solutions" — restored to "explore possible solutions" above per find/replace fix.

- [ ] **Step 3: Add DSGN 230**

Append below DSGN 220:

````markdown
## DSGN 230 — Design History

```yaml
level: Intermediate
mlos: [1, 2, 4, 6, 7, 8]
```

**Purpose.** Historical evolution of graphic design — major movements and key figures (Bauhaus, Swiss, Postmodernism, Digital Age), the relationship between design and social/political/technological shifts, critical analysis of design in context, and how historical knowledge informs contemporary practice.

**Course Learning Outcomes**

1. Describe major historical movements, styles, and figures in graphic design from the 19th century to the present.
   → MLOs: 1, 6
2. Analyze how social, political, and technological contexts have shaped graphic design across time.
   → MLOs: 1, 6
3. Evaluate the visual language and communicative strategies used in historical design works.
   → MLOs: 1, 4
4. Draw connections between historical design trends and contemporary practices or challenges.
   → MLOs: 1, 6, 8
5. Communicate research findings through written, visual, or oral presentations with clarity and critical insight.
   → MLOs: 6, 7
6. Use AI tools to explore, organize, or visualize historical design content while practicing critical evaluation of AI-generated data.
   → MLOs: 2, 6, 8
````

Note: PDF Course Purpose reads "exMLOring major movements" — restored to "exploring major movements" in the summarized purpose above. CLO 6 reads "explore" verbatim (no fix needed).

- [ ] **Step 4: Verify**

Run:
```bash
grep -c "^## DSGN " source/program-data.md
```
Expected: `6`

```bash
grep -A2 "^## DSGN 205 " source/program-data.md | grep "mlos:"
```
Expected line includes `5` in the array (e.g., `mlos: [1, 2, 3, 4, 5, 6, 7, 8]`).

- [ ] **Step 5: Commit**

```bash
git add source/program-data.md
git commit -m "Add intermediate courses (DSGN 205, 220, 230); include MLO 5 for DSGN 205"
```

---

### Task 5: Add Advanced courses (DSGN 312, 310, 320)

**Files:**
- Modify: `source/program-data.md`

**Reference:** PDF pages 35–38 (DSGN 312), 39–42 (DSGN 310), 43–46 (DSGN 320).

**⚠ Critical decision applies:** DSGN 310 CLO 3 must include MLO 5 (the PDF text says `MLOs 2, 4, 6` but the per-CLO matrix checks MLO 5 too — we honor the matrix). The course-level `mlos:` already includes 5 in the PDF.

- [ ] **Step 1: Add DSGN 312**

Append below DSGN 230:

````markdown
## DSGN 312 — Packaging Design

```yaml
level: Advanced
mlos: [1, 2, 3, 4, 6, 7, 8]
```

**Purpose.** Consumer product design — structural packaging (folds, dielines, mockups), brand identity in 3D space, materials/sustainability/printing considerations, visual storytelling and shelf impact, regulatory and ethical considerations, and market positioning. Prerequisites: DSGN 114 and 205.

**Course Learning Outcomes**

1. Design functional and visually engaging packaging solutions that communicate brand identity and appeal to specific audiences.
   → MLOs: 1, 3, 4, 8
2. Develop dielines, mockups, and 3D visualizations to prototype packaging designs for print or digital presentation.
   → MLOs: 2, 6
3. Apply principles of structure, hierarchy, and material consideration to ensure usability, sustainability, and impact.
   → MLOs: 1, 3, 6
4. Critique packaging systems based on market relevance, ethical considerations, accessibility, and visual communication.
   → MLOs: 1, 3, 4, 7, 8
5. Produce a packaging portfolio piece that demonstrates concept development, iterative design, and technical execution.
   → MLOs: 6, 2, 4
6. Use AI-assisted tools to generate or visualize packaging concepts, while critically evaluating their outputs.
   → MLOs: 2, 6, 8
````

Note: PDF Course Purpose reads "students will exMLOre" — restored to "students will explore" in the summarized purpose above (the explicit "explore" appears in the original packaging description).

- [ ] **Step 2: Add DSGN 310 — with the MLO 5 fix on CLO 3**

Append below DSGN 312:

````markdown
## DSGN 310 — Corporate Brand Communication

```yaml
level: Advanced
mlos: [1, 2, 3, 4, 5, 6, 7, 8]
```

**Purpose.** Brand strategy, identity systems, and communication design across platforms — brand identity (logos, visual systems, tone), strategy and positioning, voice and messaging, internal/external communication, consistency across media (print, digital, social, environments), stakeholder communication and brand storytelling, and real-world brand audits or campaigns.

**Course Learning Outcomes**

1. Develop comprehensive brand identity systems that include logos, typography, color, imagery, and tone of voice.
   → MLOs: 1, 2, 4, 6
2. Apply branding principles to create communication strategies tailored to target audiences and business goals.
   → MLOs: 1, 3, 4, 8
3. Design brand collateral across various media platforms, ensuring consistency and clarity of message.
   → MLOs: 2, 4, 5, 6
4. Critically evaluate brand effectiveness through case studies, audience response, and competitor analysis.
   → MLOs: 1, 3, 7
5. Collaborate to develop and pitch branding concepts using verbal, visual, and written presentation formats.
   → MLOs: 6, 7, 8
6. Use AI tools to assist with brand research, naming, visual development, or campaign ideation while maintaining strategic and ethical oversight.
   → MLOs: 2, 6, 8
````

**Note:** CLO 3 has been changed from the PDF's `MLOs: 2, 4, 6` to `MLOs: 2, 4, 5, 6` per the spec's content decision #2 (honor the per-CLO matrix; MLO 5 fits "design brand collateral [...] data viz" naturally).

- [ ] **Step 3: Add DSGN 320**

Append below DSGN 310:

````markdown
## DSGN 320 — Motion Graphics

```yaml
level: Advanced
mlos: [1, 2, 3, 4, 5, 6, 7, 8]
```

**Purpose.** Bringing visual design to life through time-based media — principles of motion design (timing, pacing, keyframes, easing), typography in motion, storyboarding and visual narrative, sound and timing integration, animation tools (e.g., After Effects), branding through motion (logo animations, explainer videos), and formats for web/social/broadcast.

**Course Learning Outcomes**

1. Apply principles of animation, timing, and sequencing to create engaging motion graphics.
   → MLOs: 1, 2, 4
2. Storyboard and design time-based visual narratives with clear communication goals.
   → MLOs: 1, 3, 6
3. Animate typography, imagery, and branding elements using industry-standard software.
   → MLOs: 2, 4, 6
4. Integrate audio, pacing, and visual effects to enhance user engagement and storytelling.
   → MLOs: 4, 6
5. Critique and revise motion designs based on audience needs and platform context.
   → MLOs: 3, 5, 6, 7
6. Use AI tools to assist with motion design tasks such as animation generation, voice syncing, or storyboarding, while applying ethical judgment.
   → MLOs: 2, 6, 8
````

- [ ] **Step 4: Verify the DSGN 310 CLO 3 fix landed**

Run:
```bash
awk '/^## DSGN 310 /{f=1} f && /^3\. Design brand collateral/{getline; print; exit}' source/program-data.md
```
Expected: `   → MLOs: 2, 4, 5, 6`

```bash
grep -c "^## DSGN " source/program-data.md
```
Expected: `9`

- [ ] **Step 5: Commit**

```bash
git add source/program-data.md
git commit -m "Add advanced courses (DSGN 312, 310, 320); add MLO 5 to DSGN 310 CLO 3"
```

---

### Task 6: Add Capstone courses (DSGN 412, 498, 410, 491)

**Files:**
- Modify: `source/program-data.md`

**Reference:** PDF pages 47–50 (DSGN 412), 51–54 (DSGN 498), 55–58 (DSGN 410), 59–62 (DSGN 491). (Page numbers approximate; sections are in order.)

- [ ] **Step 1: Add DSGN 412**

Append below DSGN 320:

````markdown
## DSGN 412 — Portfolio Design

```yaml
level: Capstone
mlos: [1, 2, 3, 4, 6, 7, 8]
```

**Purpose.** Capstone-adjacent course focused on curating, refining, and presenting a professional design portfolio for career launch — selecting and refining best work, writing case studies and project summaries, articulating design process and problem-solving, designing a cohesive visual and verbal identity, developing résumés/cover letters/online presence, preparing for interviews and critiques, and receiving peer/faculty/industry feedback.

**Course Learning Outcomes**

1. Curate a portfolio that demonstrates conceptual strength, technical skill, and process fluency across diverse design projects.
   → MLOs: 1, 2, 6
2. Write clear and compelling case studies that explain design intent, research, and outcomes.
   → MLOs: 1, 3, 6, 7
3. Design and present a cohesive personal brand identity across print and digital platforms.
   → MLOs: 4, 6, 8
4. Use peer and mentor feedback to revise portfolio materials for clarity, alignment, and professional impact.
   → MLOs: 6, 7
5. Prepare for design interviews through presentations, critiques, and storytelling strategies.
   → MLOs: 6, 7, 8
6. Use AI tools to support portfolio development, such as refining visuals, writing drafts, or simulating interviews.
   → MLOs: 2, 6, 8
````

- [ ] **Step 2: Add DSGN 498**

Append below DSGN 412:

````markdown
## DSGN 498 — Senior Capstone

```yaml
level: Capstone
mlos: [1, 2, 3, 4, 5, 6, 7, 8]
```

**Purpose.** Culminating course where students apply cumulative skills to a major self-directed or client-based project, with at least one outcome explicitly visualizing research, process, or outcomes. Students define a comprehensive design problem, conduct user/client/market research, apply iterative design and feedback, manage timelines and deliverables, integrate multiple competencies (UX/UI, branding, motion, etc.), and present in written, visual, and verbal formats.

**Course Learning Outcomes**

1. Propose and scope a self-directed design project that addresses a real-world problem or opportunity.
   → MLOs: 1, 3, 8
2. Conduct research and stakeholder analysis to inform design decisions and measure impact.
   → MLOs: 1, 3, 6
3. Apply advanced design methods to develop, prototype, and refine a comprehensive design solution.
   → MLOs: 1, 2, 4
4. Visualize data and insights clearly and persuasively to support design intent and outcomes.
   → MLOs: 1, 5, 6
5. Present the capstone project through written, visual, and verbal formats tailored to professional audiences.
   → MLOs: 6, 7, 8
6. Use AI tools to support project planning, research synthesis, or asset development, with ethical and strategic oversight.
   → MLOs: 2, 6, 8
````

- [ ] **Step 3: Add DSGN 410**

Append below DSGN 498:

````markdown
## DSGN 410 — The Business of Graphic Design

```yaml
level: Capstone
mlos: [1, 2, 3, 5, 6, 7, 8]
```

**Purpose.** Preparing students for the freelance, agency, and entrepreneurial side of the industry — pricing, contracts, intellectual property, project management and client relations, business models (freelance, agency, in-house), marketing and self-promotion, invoicing/proposals/legal basics, ethics and professional standards, and creative entrepreneurship.

**Course Learning Outcomes**

1. Describe key business models and career pathways in the graphic design industry, including freelancing, agency work, and entrepreneurship.
   → MLOs: 6, 8
2. Develop project budgets, timelines, and proposals in response to client or market needs.
   → MLOs: 3, 6, 8
3. Draft contracts, invoices, and usage rights agreements in alignment with industry standards.
   → MLOs: 6, 7, 8
4. Apply ethical, legal, and professional practices to client relationships, self-promotion, and content creation.
   → MLOs: 1, 6, 7, 8
5. Communicate business strategy through branded content, data visualizations, and presentations.
   → MLOs: 5, 6, 7, 8
6. Use AI tools to support business operations such as estimating, content drafting, client comms, or market research.
   → MLOs: 2, 6, 8
````

- [ ] **Step 4: Add DSGN 491**

Append below DSGN 410:

````markdown
## DSGN 491 — Design Internship

```yaml
level: Capstone
mlos: [1, 2, 4, 6, 7, 8]
```

**Purpose.** Real-world application of accumulated skills in a professional or client setting — experiential learning and professional development through working in a design firm, agency, in-house team, or freelance/client-based setting; applying design thinking and technical skills in real-world contexts; building professional habits, communication, and project management; receiving feedback from supervisors and reflecting on growth; and preparing for post-graduation employment or entrepreneurship.

**Course Learning Outcomes**

1. Apply design skills and tools in a professional work environment to meet client or team goals.
   → MLOs: 1, 2, 4, 6
2. Demonstrate professional communication, time management, and collaboration skills in a team-based or client-facing setting.
   → MLOs: 6, 7, 8
3. Reflect on the internship experience to assess personal strengths, challenges, and career goals.
   → MLOs: 6, 8
4. Document project contributions and design process as part of a professional portfolio.
   → MLOs: 6, 7
5. Use AI tools to support work tasks such as prototyping, research, or presentation development while maintaining professional standards.
   → MLOs: 2, 6, 8
````

Note: PDF Course Purpose reads "post-graduation emMLOyment" — restored to "post-graduation employment" in the summarized purpose above.

- [ ] **Step 5: Verify all 13 courses are present**

Run:
```bash
grep -c "^## DSGN " source/program-data.md
```
Expected: `13`

```bash
grep -c "→ MLOs:" source/program-data.md
```
Expected: `78`

- [ ] **Step 6: Commit**

```bash
git add source/program-data.md
git commit -m "Add capstone courses (DSGN 412, 498, 410, 491)"
```

---

### Task 7: Add Plan of Study

**Files:**
- Modify: `source/program-data.md`

**Reference:** Existing Plan of Study data lives in `program-overview.html` lines 794–857 (the `planSemesters` array). It is not in the PDF — extract from the HTML.

- [ ] **Step 1: Replace the `<!-- Filled in Task 7 -->` placeholder**

Append after the last course block:

````markdown
## Year 1 — Freshman

### Fall 2025 (14 cr)
- ART 110 — 2D Fundamentals (3 cr) [major]
- DSGN 105 — Digital Imaging (3 cr) [major]
- FYE 100 — College Engagement Sem. (2 cr) [gened]
- HUM 100 — Reacting to the Past (3 cr) [gened]
- Math Gen Ed — Student Choice (3 cr) [gened]

### Spring 2026 (16 cr)
- ART 112 — Drawing (3 cr) [major]
- ART 215 — Digital Photography (3 cr) [major]
- COMM 120 — Intro to Human Comm (3 cr) [gened]
- DSGN 114 — Intro to Graphic Design (3 cr) [major]
- ENGL 125 — Composition I (3 cr) [gened]
- GEN 101 — Jacket Journey (1 cr) [gened]

## Year 2 — Sophomore

### Fall 2026 (16 cr)
- DSGN 107 — Digital Illustration (3 cr) [major]
- DSGN 205 — Page Layout (3 cr) [major]
- ENGL 225 — Composition II (3 cr) [gened]
- Science Gen Ed — Student Choice (4 cr) [gened]
- Open Elective — Student Choice (3 cr) [elective]

### Spring 2027 (14 cr)
- COMM 260 — Digital Media Production (3 cr) [major]
- DSGN 220 — Design Thinking (1 cr) [major]
- DSGN 230 — Design History (1 cr) [major]
- HPM Gen Ed — Student Choice (3 cr) [gened]
- Soc Sci Gen Ed — Student Choice (3 cr) [gened]
- Open Elective — Student Choice (3 cr) [elective]
- GEN 201 — Jacket Journey (1 cr) [gened]

## Year 3 — Junior

### Fall 2027 (14 cr)
- CSCI 110 — Introduction to Web Dev. (2 cr) [major]
- DSGN 312 — Packaging Design (3 cr) [major]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]

### Spring 2028 (16 cr)
- DSGN 310 — Corporate Brand Comm. (3 cr) [major]
- DSGN 320 — Motion Graphics (3 cr) [major]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- GEN 301 — Jacket Journey (1 cr) [gened]

## Year 4 — Senior

### Fall 2028 (16 cr)
- DSGN 412 — Portfolio Design (1 cr) [major]
- DSGN 498 — Senior Capstone (3 cr) [major]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]

### Spring 2029 (14 cr)
- DSGN 410 — Bus. of Graphic Design (1 cr) [major]
- DSGN 491 — Design Internship (3 cr) [major]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- Open Elective — Student Choice (3 cr) [elective]
- GEN 401 — Jacket Journey (1 cr) [gened]
````

- [ ] **Step 2: Verify the plan parses to 8 semesters and 120 credits**

Run:
```bash
grep -c "^### " source/program-data.md
```
Expected: `8`

```bash
awk '/^### /{ match($0, /\(([0-9]+) cr\)/, a); s += a[1] } END { print s }' source/program-data.md
```
Expected: `120`

- [ ] **Step 3: Commit**

```bash
git add source/program-data.md
git commit -m "Add four-year plan of study (120 credits)"
```

---

### Task 8: Update README

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Append a row to the existing Files table**

In `README.md`, locate the Files table:

```markdown
| File | Purpose |
|------|---------|
| `program-overview.html` | Main application (all HTML, CSS, and JS in one file) |
| `index.html` | Redirect to `program-overview.html` |
```

Append a new row:

```markdown
| `source/program-data.md` | Canonical source of truth for program data (MLOs, courses, CLOs, plan of study) |
```

- [ ] **Step 2: Verify the row was added**

Run:
```bash
grep "source/program-data.md" README.md
```
Expected: one matching line.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "Point README to source/program-data.md as canonical data"
```

---

### Task 9: Add validation script and run it

**Files:**
- Create: `scripts/validate-program-data.sh`

- [ ] **Step 1: Create the script**

Write to `scripts/validate-program-data.sh`:

```bash
#!/usr/bin/env bash
# Validates source/program-data.md against the conventions in
# docs/superpowers/specs/2026-05-07-program-data-source-of-truth-design.md.
# Exits non-zero on any failure. Run from the repo root.

set -e
FILE="source/program-data.md"

fail() { echo "FAIL: $1"; exit 1; }
pass() { echo "  ok: $1"; }

echo "Validating $FILE…"

# 1. File exists
test -f "$FILE" || fail "$FILE missing"
pass "file exists"

# 2. Counts
mlos=$(grep -c "^## MLO " "$FILE")
courses=$(grep -c "^## DSGN " "$FILE")
clos=$(grep -c "→ MLOs:" "$FILE")
sems=$(grep -c "^### " "$FILE")

[ "$mlos" -eq 8 ]    || fail "expected 8 MLOs, got $mlos"
pass "8 MLOs"
[ "$courses" -eq 13 ] || fail "expected 13 courses, got $courses"
pass "13 courses"
[ "$clos" -eq 78 ]   || fail "expected 78 CLOs, got $clos"
pass "78 CLOs"
[ "$sems" -eq 8 ]    || fail "expected 8 semesters, got $sems"
pass "8 semesters"

# 3. Find/replace residue (any 'MLO' inside a word — but allow 'MLOs' and 'MLO ' followed by a digit)
# Match MLO followed by a lowercase letter (the bug pattern) but exclude 'MLOs'.
if grep -nE 'MLO[a-rt-z]' "$FILE" > /tmp/mlo-residue.txt; then
  cat /tmp/mlo-residue.txt
  fail "find/replace residue (MLO inside a word) detected"
fi
pass "no find/replace residue"

# 4. Critical decision: DSGN 205 has MLO 5
awk '/^## DSGN 205 /{f=1} f && /mlos:/{print; exit}' "$FILE" | grep -q "5" \
  || fail "DSGN 205 must include MLO 5 in its course-level mlos"
pass "DSGN 205 includes MLO 5"

# 5. Critical decision: DSGN 310 CLO 3 has MLO 5
awk '/^## DSGN 310 /{f=1} f && /^3\. Design brand collateral/{getline; print; exit}' "$FILE" \
  | grep -q "5" || fail "DSGN 310 CLO 3 must include MLO 5"
pass "DSGN 310 CLO 3 includes MLO 5"

# 6. Plan total credits == 120
total=$(awk '/^### /{ match($0, /\(([0-9]+) cr\)/, a); s += a[1] } END { print s }' "$FILE")
[ "$total" -eq 120 ] || fail "plan total credits expected 120, got $total"
pass "plan totals 120 credits"

echo "All checks passed."
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x scripts/validate-program-data.sh
```

- [ ] **Step 3: Run it from the repo root**

```bash
./scripts/validate-program-data.sh
```

Expected output ends with `All checks passed.` and exit code 0.

- [ ] **Step 4: Commit**

```bash
git add scripts/validate-program-data.sh
git commit -m "Add content lint for source/program-data.md"
```

---

## Self-review checklist

After all tasks complete:

- [ ] `source/program-data.md` exists and `./scripts/validate-program-data.sh` passes.
- [ ] `git log --oneline` shows 9 small commits, one per task, with informative messages.
- [ ] DSGN 205 includes MLO 5 (course-level + CLOs 2 and 4).
- [ ] DSGN 310 CLO 3 reads `→ MLOs: 2, 4, 5, 6`.
- [ ] No `MLO[a-z]` residue anywhere except real MLO references.
- [ ] README has a row pointing to `source/program-data.md`.
- [ ] The HTML app, the inline JS literals, and the PDF have NOT been modified by this work.

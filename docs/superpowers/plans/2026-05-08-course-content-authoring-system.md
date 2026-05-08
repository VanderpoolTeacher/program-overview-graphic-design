# Course Content Authoring System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the course content authoring system specified in `docs/superpowers/specs/2026-05-08-course-content-authoring-system-design.md` — three new templates, a scaffold script, a validation script, a pipeline README, and a standalone HTML progress tracker.

**Architecture:** Plain Markdown templates that the scaffold script copies and substitutes. Bash scripts that read from `source/program-data.md` (canonical) using awk/sed for extraction. Standalone HTML with inline CSS/JS that mirrors the visual style of `program-overview.html`. No build step, no framework.

**Tech Stack:** Markdown, Bash 3.2 (macOS default), awk (BSD), sed (BSD), `textutil` (macOS-bundled), HTML5 + CSS custom properties + vanilla JS.

---

## File Structure

| Path | Action | Responsibility |
|---|---|---|
| `.gitignore` | Create | Exclude `.cache/` directories used by scaffold for docx text extraction |
| `course-design/templates/source-analysis-template.md` | Create | Pre-fillable template for per-course source-analysis docs |
| `course-design/templates/existing-materials-analysis-template.md` | Create | Pre-fillable template for existing-materials analysis |
| `course-design/templates/authoring-plan-template.md` | Create | Pre-fillable template for the authoring plan |
| `scripts/scaffold-course.sh` | Create | Per-course scaffold: extract facts, stamp templates, inventory source materials |
| `scripts/validate-course-design.sh` | Create | Alignment checks across course-design folders |
| `course-design/progress.html` | Create | Canonical, internal-facing tracker; matches existing app style |
| `course-design/README.md` | Create | Pipeline doc; references progress.html |

---

### Task 1: Create `.gitignore`

**Files:**
- Create: `.gitignore`

- [ ] **Step 1: Create `.gitignore`**

Write to `.gitignore`:

```
# macOS
.DS_Store

# Scaffold script docx-text caches (generated, regenerable from source/)
.cache/
**/.cache/
```

- [ ] **Step 2: Verify .DS_Store is now ignored**

```bash
git status --porcelain | grep -F ".DS_Store" || echo "ok: .DS_Store no longer in untracked list"
```
Expected: `ok: .DS_Store no longer in untracked list`

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "Add .gitignore for .DS_Store and .cache directories"
```

---

### Task 2: Create `source-analysis-template.md`

**Files:**
- Create: `course-design/templates/source-analysis-template.md`

This codifies the structure used in `course-design/dsgn-410/dsgn-410-source-analysis.md`.

- [ ] **Step 1: Create the file with the following exact content**

````markdown
# {{COURSE_CODE}} — Source Analysis

> Reference document. Pulls together what the program-design source materials
> say about {{COURSE_CODE}}, with observations to inform new course content.
> Source: `source/program-data.md` (canonical) and
> `source/DC Graphic Design Major Design Document.pdf` (historical reference).
> Pairs with `{{COURSE_SLUG}}-existing-materials-analysis.md` and
> `{{COURSE_SLUG}}-authoring-plan.md`.

## Course shape

| Aspect | Value |
|---|---|
| Title | {{COURSE_TITLE}} |
| Level | {{COURSE_LEVEL}} |
| Credits | {{COURSE_CREDITS}} (verify against `source/program-data.md` Plan of Study) |
| CLOs | {{CLO_COUNT}} |
| MLOs covered | {{MLOS_COVERED}} |
| MLOs **not** covered | {{MLOS_NOT_COVERED}} |

## What the source actually says

**Purpose** (verbatim from `source/program-data.md`):

> {{COURSE_PURPOSE}}

That is the entirety of the course-design guidance in the source. The
document describes **what** the course covers, never **how**, **in what
sequence**, **with what tools**, or **measured against what rubrics**.

## CLO-by-CLO read

> Fill in. One row per CLO. The "Theme" and "Likely deliverable type"
> columns are your synthesis — not from the source.

| # | CLO (verbatim) | MLOs | Theme | Likely deliverable type |
|---|---|---|---|---|
{{CLO_TABLE_ROWS}}

## Patterns worth noting

> Free-form analytical observations: through-lines, unique aspects,
> assumptions baked into the design. 3–6 bullets is typical.

1. {{Pattern 1 — what is interesting about this course's MLO mapping?}}
2. {{Pattern 2 — what does the data-viz / AI / portfolio thread look like here?}}
3. {{Pattern 3 — what does this course assume students bring in?}}

## Content gaps the source does not fill

> Standard list — nearly every course will have these gaps. Add
> course-specific ones at the end.

- No syllabus / weekly schedule
- No assignment list or rubrics
- No CLO-to-assignment matrix
- No tool list (specific platforms, software, templates)
- No reading list / textbook recommendation
- No grading scheme or weighting
- No assumed prerequisite knowledge from earlier coursework
- {{Course-specific gap, if any}}
````

- [ ] **Step 2: Verify the file was written**

```bash
test -f course-design/templates/source-analysis-template.md && grep -c "{{" course-design/templates/source-analysis-template.md
```
Expected: A number ≥ 8 (placeholders are present).

- [ ] **Step 3: Commit**

```bash
git add course-design/templates/source-analysis-template.md
git commit -m "Add source-analysis template"
```

---

### Task 3: Create `existing-materials-analysis-template.md`

**Files:**
- Create: `course-design/templates/existing-materials-analysis-template.md`

Codifies the structure used in `course-design/dsgn-410/dsgn-410-existing-materials-analysis.md`.

- [ ] **Step 1: Create the file with the following exact content**

````markdown
# {{COURSE_CODE}} — Existing Materials Analysis

> Reference document. Catalogues any pre-existing assignments, schedules,
> or other course-design artifacts found in `source/` for {{COURSE_CODE}},
> maps them to the course's CLOs, and identifies coverage gaps to address
> when authoring new content.
> Pairs with `{{COURSE_SLUG}}-source-analysis.md` and
> `{{COURSE_SLUG}}-authoring-plan.md`.

{{EXISTING_MATERIALS_HEADER}}

## Inventory

> Fill in one row per file in the existing source folder. The scaffold
> script pre-fills file names; you add the type and expected format columns.

| # | Document | Type | Format expected from student |
|---|---|---|---|
{{INVENTORY_ROWS}}

## Weekly schedule at a glance (if present)

> If the existing materials include a weekly outline, paste / summarize
> here. Otherwise delete this section.

{{WEEKLY_SCHEDULE_PLACEHOLDER}}

## Assignment → CLO coverage map

> Build this matrix once you've read each existing assignment. CLO numbers
> match `source/program-data.md` for {{COURSE_CODE}}. ✓ = strongly
> addressed, ∼ = partially addressed, blank = not addressed.

| Assignment | {{CLO_COLUMN_HEADERS}} |
|---|{{CLO_COLUMN_SEPARATORS}}|
{{COVERAGE_ROWS_PLACEHOLDER}}

Coverage by CLO:
- **CLO 1:** {{covered/uncovered}}
- **CLO 2:** {{covered/uncovered}}
- … (one bullet per CLO; flag any with ⚠ for double attention)

## Gaps the existing materials do not fill

> Per-CLO gaps + cross-cutting gaps. Each should be specific enough that
> someone could later author a new assignment to address it.

1. **{{Gap title}} (CLO {{N}}).** {{Specific description.}}
2. {{...}}

## Mismatches and tensions

> Where the existing materials disagree with `source/program-data.md`, the
> Plan of Study, or themselves. E.g., credit hour mismatch, rubric
> inconsistency, missing CLO declarations.

- {{...}}

## Quick wins (high value, low effort)

> Things that could be added or fixed in under an hour each.

- {{...}}
````

- [ ] **Step 2: Verify**

```bash
test -f course-design/templates/existing-materials-analysis-template.md && grep -c "{{" course-design/templates/existing-materials-analysis-template.md
```
Expected: A number ≥ 6.

- [ ] **Step 3: Commit**

```bash
git add course-design/templates/existing-materials-analysis-template.md
git commit -m "Add existing-materials-analysis template"
```

---

### Task 4: Create `authoring-plan-template.md`

**Files:**
- Create: `course-design/templates/authoring-plan-template.md`

This is a new artifact (no DSGN 410 example yet).

- [ ] **Step 1: Create the file with the following exact content**

````markdown
# {{COURSE_CODE}} — Authoring Plan

> Reference document. Lists every assignment to author for {{COURSE_CODE}},
> mapped to the course's CLOs, with priority and estimated student time.
> Drives the work in `assignments/`.
> Pairs with `{{COURSE_SLUG}}-source-analysis.md` and
> `{{COURSE_SLUG}}-existing-materials-analysis.md`.

## Course CLOs (reference)

> Pre-filled from `source/program-data.md`. Do not edit.

{{CLO_LIST}}

## Assignments to author

> One row per planned assignment. The "Existing?" column references files
> already drafted in `source/<course folder>/` (if any). Priority: P0 =
> required for course to function, P1 = strongly recommended, P2 = nice to
> have. Time = estimated student work in hours.

| # | Title | CLO(s) | MLO union | Priority | Time | Existing? | Notes |
|---|---|---|---|---|---|---|---|
| 1 | {{Title}} | CLO {{N}} | MLOs {{N, N}} | P{{0/1/2}} | {{N}}h | {{filename or "new"}} | {{rationale}} |

> Add rows as needed. Aim for 5–9 assignments per 3-credit course, 2–4
> per 1-credit course.

## CLO coverage check

> Fill in once the table above is complete. Flag any CLO with no
> assignment as a ⚠ — that's a coverage failure.

- **CLO 1:** {{Assignments #__, #__}}
- **CLO 2:** {{Assignments #__}}
- … (one bullet per CLO)

## Open questions

> Things to resolve with stakeholders before authoring proceeds. Examples:
> credit-hour mismatch, prerequisite assumptions, tool selection.

- {{...}}

## Authoring sequence

> Suggested order to author the assignments. Default: P0 first in CLO
> order, then P1, then P2. Adjust if there are dependencies (e.g.,
> assignment 5 references work students did in assignment 2).

1. {{Title (#N)}}
2. {{...}}
````

- [ ] **Step 2: Verify**

```bash
test -f course-design/templates/authoring-plan-template.md && grep -c "{{" course-design/templates/authoring-plan-template.md
```
Expected: A number ≥ 5.

- [ ] **Step 3: Commit**

```bash
git add course-design/templates/authoring-plan-template.md
git commit -m "Add authoring-plan template"
```

---

### Task 5: Create `scripts/scaffold-course.sh`

**Files:**
- Create: `scripts/scaffold-course.sh`

This is the core scaffolding logic. The script reads `source/program-data.md` for course facts, fuzzy-matches an existing source folder under `source/`, and stamps the three templates with substitutions.

- [ ] **Step 1: Write the full script**

Write to `scripts/scaffold-course.sh`:

```bash
#!/usr/bin/env bash
# Scaffolds a per-course folder under course-design/ and pre-fills the
# three templates with facts pulled from source/program-data.md.
#
# Usage:
#   ./scripts/scaffold-course.sh DSGN312
#   ./scripts/scaffold-course.sh "DSGN 312"
#
# Idempotent: re-running never overwrites existing files.

set -euo pipefail

err()  { echo "ERROR: $*" >&2; exit 1; }
note() { echo "  $*"; }
ok()   { echo "  ok: $*"; }

[ $# -eq 1 ] || err "Usage: $0 <COURSE_CODE>  (e.g., DSGN312 or 'DSGN 312')"

# Normalize input. Accept "DSGN312", "DSGN 312", "dsgn-312" — output
# both heading form ("DSGN 312") and slug form ("dsgn-312").
RAW="$1"
NUM=$(printf '%s' "$RAW" | grep -oE '[0-9]+' | head -1)
[ -n "$NUM" ] || err "could not extract course number from '$RAW'"
HEADING_FORM="DSGN $NUM"
SLUG="dsgn-$NUM"

DATA_FILE="source/program-data.md"
test -f "$DATA_FILE" || err "$DATA_FILE not found — run from repo root"

# Confirm the course exists in program-data.md
if ! grep -q "^## $HEADING_FORM " "$DATA_FILE"; then
  err "course '$HEADING_FORM' not found as a heading in $DATA_FILE"
fi

# Extract the course block (from "## DSGN NNN " to the next "## DSGN " or "# Plan")
COURSE_BLOCK=$(awk -v h="^## $HEADING_FORM " '
  $0 ~ h { f=1; print; next }
  f && /^## DSGN / { exit }
  f && /^# Plan of Study/ { exit }
  f { print }
' "$DATA_FILE")

# Extract individual facts
TITLE=$(printf '%s' "$COURSE_BLOCK" | head -1 | sed -E "s/^## $HEADING_FORM — //")
LEVEL=$(printf '%s\n' "$COURSE_BLOCK" | grep -m1 '^level:' | sed 's/^level: *//')
MLOS=$(printf '%s\n' "$COURSE_BLOCK" | grep -m1 '^mlos:' | sed -E 's/^mlos: *\[(.*)\]$/\1/')
PURPOSE=$(printf '%s\n' "$COURSE_BLOCK" | awk '/^\*\*Purpose\.\*\*/{sub(/^\*\*Purpose\.\*\* */,""); print; exit}')
CLO_LINES=$(printf '%s\n' "$COURSE_BLOCK" | awk '/^[0-9]+\. /{c=$0; getline n; print c"\n"n}')
CLO_COUNT=$(printf '%s\n' "$COURSE_BLOCK" | grep -c '→ MLOs:')

# Compute MLOs covered and not covered
MLOS_COVERED="$MLOS"
MLOS_NOT_COVERED=$(awk -v have="$MLOS" 'BEGIN {
  split(have, h, /, ?/)
  for (i in h) seen[h[i]]=1
  out=""
  for (n=1; n<=8; n++) if (!(n in seen)) out = out (out?", ":"") n
  print (out=="" ? "(none — covers all 8)" : out)
}')

# Build CLO table rows for the source-analysis template
CLO_TABLE_ROWS=$(printf '%s\n' "$CLO_LINES" | awk '
  /^[0-9]+\. /     { num=$1; sub(/^[0-9]+\. /,""); text=$0; getline mlo;
                     sub(/^ *→ MLOs: */,"",mlo);
                     print "| " num " " text " | " mlo " | {{theme}} | {{deliverable}} |" }
')

# Find existing source folder for this course (fuzzy)
EXISTING_FOLDER=$(find source -maxdepth 1 -type d -name "$HEADING_FORM*" | head -1 || true)

# Make output paths
COURSE_DIR="course-design/$SLUG"
mkdir -p "$COURSE_DIR/assignments"

# Helper: write file from template, applying substitutions, only if dest doesn't exist
stamp() {
  local tpl="$1" dest="$2" extra_sed="${3:-}"
  if [ -e "$dest" ]; then
    note "skip (exists): $dest"
    return
  fi
  local clo_table_escaped purpose_escaped title_escaped
  # Use a sentinel + perl-style escaping is overkill; use python for safety
  python3 - "$tpl" "$dest" "$HEADING_FORM" "$SLUG" "$TITLE" "$LEVEL" "$CLO_COUNT" "$MLOS_COVERED" "$MLOS_NOT_COVERED" "$PURPOSE" "$CLO_TABLE_ROWS" <<'PY'
import sys, pathlib
tpl, dest, code, slug, title, level, clo_count, mlos_cov, mlos_not, purpose, clo_rows = sys.argv[1:12]
content = pathlib.Path(tpl).read_text()
subs = {
    "{{COURSE_CODE}}": code,
    "{{COURSE_SLUG}}": slug,
    "{{COURSE_TITLE}}": title,
    "{{COURSE_LEVEL}}": level,
    "{{COURSE_CREDITS}}": "(see Plan of Study in source/program-data.md)",
    "{{CLO_COUNT}}": clo_count,
    "{{MLOS_COVERED}}": mlos_cov,
    "{{MLOS_NOT_COVERED}}": mlos_not,
    "{{COURSE_PURPOSE}}": purpose,
    "{{CLO_TABLE_ROWS}}": clo_rows,
}
for k, v in subs.items():
    content = content.replace(k, v)
pathlib.Path(dest).write_text(content)
PY
  ok "wrote: $dest"
}

stamp "course-design/templates/source-analysis-template.md" \
      "$COURSE_DIR/$SLUG-source-analysis.md"

# Existing-materials analysis: header depends on whether folder was found
EM_HEADER=""
INVENTORY_ROWS=""
CACHE_DIR=""
if [ -n "$EXISTING_FOLDER" ]; then
  EM_HEADER="✅ **Existing source folder found:** \`$EXISTING_FOLDER\`"
  CACHE_DIR="$COURSE_DIR/.cache"
  mkdir -p "$CACHE_DIR"
  i=0
  while IFS= read -r f; do
    i=$((i+1))
    base=$(basename "$f")
    INVENTORY_ROWS="$INVENTORY_ROWS| $i | $base | {{type}} | {{format}} |"$'\n'
    # Extract docx text once
    if [[ "$f" == *.docx ]] && command -v textutil >/dev/null 2>&1; then
      out="$CACHE_DIR/${base%.docx}.txt"
      [ -f "$out" ] || textutil -stdout -convert txt "$f" > "$out" 2>/dev/null || true
    fi
  done < <(find "$EXISTING_FOLDER" -maxdepth 1 -type f ! -name '.*' | sort)
  ok "inventoried $i file(s) from $EXISTING_FOLDER"
else
  EM_HEADER="⚠ **No existing source folder detected** under \`source/\`. Confirm by inspecting \`source/\` manually before declaring \"no existing materials,\" then replace this notice with \"Confirmed none on YYYY-MM-DD.\""
  INVENTORY_ROWS="| _none_ | _none_ | _none_ | _none_ |"
  note "no existing source folder for $HEADING_FORM"
fi

# Stamp existing-materials template with EM-specific placeholders
EM_DEST="$COURSE_DIR/$SLUG-existing-materials-analysis.md"
if [ -e "$EM_DEST" ]; then
  note "skip (exists): $EM_DEST"
else
  python3 - "$EM_DEST" "$HEADING_FORM" "$SLUG" "$EM_HEADER" "$INVENTORY_ROWS" <<'PY'
import sys, pathlib
dest, code, slug, em_header, inv = sys.argv[1:6]
tpl = pathlib.Path("course-design/templates/existing-materials-analysis-template.md").read_text()
subs = {
    "{{COURSE_CODE}}": code,
    "{{COURSE_SLUG}}": slug,
    "{{EXISTING_MATERIALS_HEADER}}": em_header,
    "{{INVENTORY_ROWS}}": inv.rstrip(),
    "{{WEEKLY_SCHEDULE_PLACEHOLDER}}": "_(fill in if existing materials include one; otherwise delete this section)_",
    "{{CLO_COLUMN_HEADERS}}": "(fill in)",
    "{{CLO_COLUMN_SEPARATORS}}": "---",
    "{{COVERAGE_ROWS_PLACEHOLDER}}": "_fill in_",
}
for k, v in subs.items():
    tpl = tpl.replace(k, v)
pathlib.Path(dest).write_text(tpl)
PY
  ok "wrote: $EM_DEST"
fi

# Build CLO list block for authoring plan
CLO_LIST=$(printf '%s\n' "$CLO_LINES" | awk '/^[0-9]+\. /{print "- **CLO "$1" "; sub(/^[0-9]+\. /,""); printf "%s** ",$0; getline mlo; sub(/^ *→ MLOs: */,"",mlo); print "(MLOs " mlo ")"}' | sed 's/\*\* /\*\* /')

AP_DEST="$COURSE_DIR/$SLUG-authoring-plan.md"
if [ -e "$AP_DEST" ]; then
  note "skip (exists): $AP_DEST"
else
  python3 - "$AP_DEST" "$HEADING_FORM" "$SLUG" "$CLO_LIST" <<'PY'
import sys, pathlib
dest, code, slug, clo_list = sys.argv[1:5]
tpl = pathlib.Path("course-design/templates/authoring-plan-template.md").read_text()
subs = {
    "{{COURSE_CODE}}": code,
    "{{COURSE_SLUG}}": slug,
    "{{CLO_LIST}}": clo_list,
}
for k, v in subs.items():
    tpl = tpl.replace(k, v)
pathlib.Path(dest).write_text(tpl)
PY
  ok "wrote: $AP_DEST"
fi

# Create assignments/ with template seed copy
SEED="$COURSE_DIR/assignments/00-template-copy.md"
if [ ! -e "$SEED" ]; then
  sed "s/{{DSGN NNN — Course Title}}/$HEADING_FORM — $TITLE/" \
      course-design/templates/assignment-template.md > "$SEED"
  ok "wrote: $SEED"
else
  note "skip (exists): $SEED"
fi

cat <<EOF

Scaffold complete for $HEADING_FORM ($TITLE).

Next steps:
  [ ] Verify existing-materials check (especially if no folder was detected)
      → open: $EM_DEST
  [ ] Write source analysis
      → open: $COURSE_DIR/$SLUG-source-analysis.md
  [ ] Write existing-materials analysis (or document none)
      → open: $EM_DEST
  [ ] Write authoring plan
      → open: $AP_DEST
  [ ] Author each planned assignment in $COURSE_DIR/assignments/
  [ ] Run validation: ./scripts/validate-course-design.sh $HEADING_FORM
  [ ] Update course-design/progress.html with the current stage

EOF
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/scaffold-course.sh
```

- [ ] **Step 3: Smoke test on a course WITHOUT existing materials (DSGN 312 — no `source/DSGN 312*/` folder exists)**

```bash
./scripts/scaffold-course.sh DSGN312
```

Expected output (last lines):
- `ok: wrote: course-design/dsgn-312/dsgn-312-source-analysis.md`
- `no existing source folder for DSGN 312`
- `ok: wrote: course-design/dsgn-312/dsgn-312-existing-materials-analysis.md`
- `ok: wrote: course-design/dsgn-312/dsgn-312-authoring-plan.md`
- `ok: wrote: course-design/dsgn-312/assignments/00-template-copy.md`
- "Scaffold complete for DSGN 312" ...

- [ ] **Step 4: Verify expected files**

```bash
ls course-design/dsgn-312/ && ls course-design/dsgn-312/assignments/
```
Expected: 3 .md files at top level + assignments dir with `00-template-copy.md`.

```bash
grep -c "{{" course-design/dsgn-312/dsgn-312-source-analysis.md
```
Expected: a small number (the placeholder block remaining for human-authored sections like patterns and gaps); should be < 10.

```bash
grep -F "⚠ **No existing source folder detected**" course-design/dsgn-312/dsgn-312-existing-materials-analysis.md
```
Expected: matching line (the warning is in place).

- [ ] **Step 5: Smoke test on a course WITH existing materials (DSGN 410 — `source/DSGN 410 Business of Graphic Design/` exists)**

```bash
./scripts/scaffold-course.sh DSGN410
```

Expected: every line is `skip (exists): ...` because `course-design/dsgn-410/` is already populated. Confirms idempotence.

- [ ] **Step 6: Commit**

```bash
git add scripts/scaffold-course.sh
git commit -m "Add scaffold-course.sh: extracts course facts, stamps templates, inventories source materials"
```

---

### Task 6: Create `scripts/validate-course-design.sh`

**Files:**
- Create: `scripts/validate-course-design.sh`

- [ ] **Step 1: Write the full script**

Write to `scripts/validate-course-design.sh`:

```bash
#!/usr/bin/env bash
# Validates one course-design folder (or all) against the conventions in
# docs/superpowers/specs/2026-05-08-course-content-authoring-system-design.md.
#
# Usage:
#   ./scripts/validate-course-design.sh DSGN410   # one course
#   ./scripts/validate-course-design.sh           # all courses

set -uo pipefail

DATA_FILE="source/program-data.md"
test -f "$DATA_FILE" || { echo "ERROR: $DATA_FILE not found — run from repo root"; exit 2; }

# Validate a single course slug (e.g., dsgn-410).
# Returns 0 on pass, 1 on any failure. Prints check-by-check status.
validate_one() {
  local slug="$1"
  local num
  num=$(printf '%s' "$slug" | grep -oE '[0-9]+' | head -1)
  local heading="DSGN $num"
  local dir="course-design/$slug"
  local fail=0

  echo "=== $heading ($slug) ==="

  # 1. Folder exists
  if [ ! -d "$dir" ]; then
    echo "  FAIL: folder $dir missing"
    return 1
  fi
  echo "  ok: folder exists"

  # 2. Required files
  for f in "$slug-source-analysis.md" "$slug-existing-materials-analysis.md" "$slug-authoring-plan.md"; do
    if [ ! -f "$dir/$f" ]; then
      echo "  FAIL: required file $dir/$f missing"
      fail=1
    fi
  done
  if [ ! -d "$dir/assignments" ]; then
    echo "  FAIL: $dir/assignments/ directory missing"
    fail=1
  fi
  [ "$fail" -eq 0 ] && echo "  ok: all required files present"

  # Pull this course's CLOs and per-CLO MLO maps from program-data.md
  local block
  block=$(awk -v h="^## $heading " '
    $0 ~ h { f=1; print; next }
    f && /^## DSGN / { exit }
    f && /^# Plan of Study/ { exit }
    f { print }
  ' "$DATA_FILE")

  # Course CLO numbers (1..N)
  local clo_nums
  clo_nums=$(printf '%s\n' "$block" | grep -oE '^[0-9]+\.' | tr -d '.' | sort -un)
  [ -z "$clo_nums" ] && { echo "  FAIL: could not parse CLOs for $heading from $DATA_FILE"; return 1; }

  # Real assignments (exclude 00-template-copy.md)
  local assignments
  assignments=$(find "$dir/assignments" -maxdepth 1 -type f -name '*.md' ! -name '00-template-copy.md' 2>/dev/null || true)

  # Helper: extract all CLO numbers referenced in a list of files. Handles
  # both single ("CLO 1") and comma-list ("CLO 1, 5, 7") forms.
  extract_clos() {
    grep -hoE 'CLO [0-9]+(, *[0-9]+)*' "$@" 2>/dev/null \
      | grep -oE '[0-9]+' | sort -un
  }

  # 3. CLO coverage
  if [ -z "$assignments" ]; then
    echo "  FAIL: no real assignments yet (only 00-template-copy.md or empty) — coverage check skipped"
    fail=1
  else
    local referenced
    referenced=$(extract_clos $assignments)
    local missing=""
    local n
    for n in $clo_nums; do
      if ! echo "$referenced" | grep -qx "$n"; then
        missing="$missing $n"
      fi
    done
    if [ -n "$missing" ]; then
      echo "  FAIL: CLOs not covered by any assignment:$missing"
      fail=1
    else
      echo "  ok: every CLO referenced by at least one assignment"
    fi

    # 4. No phantom CLOs
    local phantoms=""
    local ref
    for ref in $referenced; do
      if ! echo "$clo_nums" | grep -qx "$ref"; then
        phantoms="$phantoms $ref"
      fi
    done
    if [ -n "$phantoms" ]; then
      echo "  FAIL: assignments reference CLOs that don't exist on this course:$phantoms"
      fail=1
    else
      echo "  ok: no phantom CLOs"
    fi

    # 5. Rubric alignment: every CLO declared at top must appear in rubric column;
    #    every CLO in rubric must appear at top.
    local a
    for a in $assignments; do
      local top_block rubric_block top_clos rubric_clos
      top_block=$(awk '/^## Learning Outcome Mapping/{f=1; next} f && /^## /{exit} f' "$a")
      rubric_block=$(awk '/^## Rubric/{f=1; next} f && /^## /{exit} f' "$a")
      top_clos=$(printf '%s\n' "$top_block" | extract_clos /dev/stdin || true)
      rubric_clos=$(printf '%s\n' "$rubric_block" | extract_clos /dev/stdin || true)
      local in_top_only in_rubric_only
      in_top_only=$(comm -23 <(echo "$top_clos") <(echo "$rubric_clos") | tr '\n' ' ')
      in_rubric_only=$(comm -13 <(echo "$top_clos") <(echo "$rubric_clos") | tr '\n' ' ')
      if [ -n "$(printf '%s' "$in_top_only" | tr -d ' ')" ]; then
        echo "  FAIL: $a — CLOs declared at top but missing from rubric: $in_top_only"
        fail=1
      fi
      if [ -n "$(printf '%s' "$in_rubric_only" | tr -d ' ')" ]; then
        echo "  FAIL: $a — CLOs in rubric but not declared at top: $in_rubric_only"
        fail=1
      fi
    done
    [ "$fail" -eq 0 ] && echo "  ok: rubric alignment"
  fi

  # 6. Template residue (in any md inside the course folder, except templates)
  local residue
  residue=$(grep -rln '{{' "$dir" --include='*.md' 2>/dev/null \
            | grep -v '/00-template-copy.md$' || true)
  if [ -n "$residue" ]; then
    echo "  FAIL: {{placeholder}} residue in: $residue"
    fail=1
  else
    echo "  ok: no template residue"
  fi

  # 7. Existing-materials check resolved
  local em_file="$dir/$slug-existing-materials-analysis.md"
  if [ -f "$em_file" ] && grep -qF "⚠ **No existing source folder detected**" "$em_file"; then
    echo "  FAIL: existing-materials warning still present in $em_file (resolve or replace with 'Confirmed none on YYYY-MM-DD')"
    fail=1
  elif [ -f "$em_file" ]; then
    echo "  ok: existing-materials check resolved"
  fi

  return $fail
}

# Find all course slugs to validate
courses_to_check=()
if [ $# -ge 1 ]; then
  num=$(printf '%s' "$1" | grep -oE '[0-9]+' | head -1)
  [ -n "$num" ] || { echo "ERROR: could not parse course code from '$1'"; exit 2; }
  courses_to_check+=("dsgn-$num")
else
  while IFS= read -r d; do
    courses_to_check+=("$(basename "$d")")
  done < <(find course-design -mindepth 1 -maxdepth 1 -type d -name 'dsgn-*' | sort)
fi

[ "${#courses_to_check[@]}" -eq 0 ] && { echo "no course folders found under course-design/"; exit 0; }

total=0
passed=0
failed_list=""
for slug in "${courses_to_check[@]}"; do
  total=$((total+1))
  if validate_one "$slug"; then
    passed=$((passed+1))
  else
    failed_list="$failed_list $slug"
  fi
done

echo
echo "=== Summary: $passed of $total courses pass ==="
if [ -n "$failed_list" ]; then
  echo "Failures:$failed_list"
  exit 1
fi
exit 0
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/validate-course-design.sh
```

- [ ] **Step 3: Smoke test on DSGN 410 (already-authored, but no real assignments yet)**

```bash
./scripts/validate-course-design.sh DSGN410
```

Expected: structural checks pass; CLO coverage check fails (because no real assignments exist yet); existing-materials check… depends on whether the dsgn-410-existing-materials-analysis.md still has the ⚠ — for the existing DSGN 410 doc, it doesn't (we wrote it without the warning since materials existed). So check should pass on existing-materials.

- [ ] **Step 4: Smoke test on freshly-scaffolded DSGN 312**

```bash
./scripts/validate-course-design.sh DSGN312
```

Expected: structural pass; CLO coverage fail (no real assignments yet); existing-materials FAIL because the ⚠ is still in place (the human hasn't resolved it).

- [ ] **Step 5: Smoke test no-arg form**

```bash
./scripts/validate-course-design.sh
```

Expected: prints results for both `dsgn-312` and `dsgn-410`, exits 1 (because both have failures).

- [ ] **Step 6: Commit**

```bash
git add scripts/validate-course-design.sh
git commit -m "Add validate-course-design.sh: alignment checks for course-design folders"
```

---

### Task 7: Create `course-design/progress.html`

**Files:**
- Create: `course-design/progress.html`

Standalone HTML, single file, mirrors the visual style of `program-overview.html`. Inline JS array of course objects is the source of truth for tracker data.

- [ ] **Step 1: Write the file**

Write to `course-design/progress.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Course Design Progress — DC Graphic Design BA</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  :root {
    --bg: #141416;
    --surface: #1e1e22;
    --surface2: #28282e;
    --border: #3a3a42;
    --text: #f0f0f0;
    --text-dim: #CCC4A8;
    --heading: #f0f0f0;
    --accent: #CCC4A8;
    --accent-glow: rgba(204,196,168,0.15);
    --green: #6dbf7b;
    --orange: #e8a04c;
    --purple: #7b5ea7;
    --cyan: #4a8ad4;
    --rose: #c97088;
    --shadow: rgba(0,0,0,0.4);
  }
  [data-theme="light"] {
    --bg: #f5f4f2;
    --surface: #ffffff;
    --surface2: #eeece8;
    --border: #d8d5ce;
    --text: #221338;
    --text-dim: #5a4d68;
    --heading: #4F2683;
    --accent: #4F2683;
    --accent-glow: rgba(79,38,131,0.1);
    --green: #3a8a4a;
    --orange: #c07a20;
    --purple: #4F2683;
    --cyan: #2F61AE;
    --rose: #a04060;
    --shadow: rgba(34,19,56,0.1);
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
    background: var(--bg); color: var(--text);
    font-size: 12pt; line-height: 1.5;
  }
  nav {
    position: fixed; top: 0; left: 0; right: 0; z-index: 100;
    background: var(--bg); border-bottom: 1px solid var(--border);
    padding: 0 2rem; display: flex; align-items: center;
    height: 56px; gap: 1rem;
  }
  nav .logo { font-weight: 700; color: var(--accent); }
  nav .spacer { flex: 1; }
  nav .theme-toggle {
    cursor: pointer; padding: 0.5rem 0.75rem;
    border-radius: 8px; color: var(--text-dim);
  }
  nav .theme-toggle:hover { background: var(--surface); color: var(--text); }
  main { padding: 80px 2rem 4rem; max-width: 1400px; margin: 0 auto; }
  h1 { font-size: 2rem; margin-bottom: 0.5rem; color: var(--heading); }
  .subtitle { color: var(--text-dim); margin-bottom: 2rem; }
  .stats-row {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem; margin-bottom: 2rem;
  }
  .stat-card {
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; padding: 1.25rem; text-align: center;
  }
  .stat-num { font-size: 2.5rem; font-weight: 700; color: var(--accent); }
  .stat-label { color: var(--text-dim); font-size: 0.95rem; margin-top: 0.25rem; }
  table.tracker {
    width: 100%; border-collapse: collapse;
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; overflow: hidden;
  }
  table.tracker th, table.tracker td {
    text-align: left; padding: 0.75rem 1rem;
    border-bottom: 1px solid var(--border);
  }
  table.tracker th {
    background: var(--surface2); color: var(--text-dim);
    font-weight: 600; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em;
  }
  table.tracker tbody tr:last-child td { border-bottom: none; }
  table.tracker tbody tr:hover { background: var(--accent-glow); }
  .pill {
    display: inline-block; padding: 0.25rem 0.75rem; border-radius: 999px;
    font-size: 0.85rem; font-weight: 500;
  }
  .pill-0 { background: rgba(127,142,170,0.2); color: var(--text-dim); }
  .pill-1 { background: rgba(74,138,212,0.2); color: var(--cyan); }
  .pill-2 { background: rgba(123,94,167,0.2); color: var(--purple); }
  .pill-3 { background: rgba(232,160,76,0.2); color: var(--orange); }
  .pill-4 { background: rgba(232,160,76,0.2); color: var(--orange); }
  .pill-5 { background: rgba(201,112,136,0.2); color: var(--rose); }
  .pill-6 { background: rgba(109,191,123,0.2); color: var(--green); }
  .pill-7 { background: rgba(109,191,123,0.2); color: var(--green); }
  .pill-8 { background: rgba(109,191,123,0.3); color: var(--green); }
  .notes { color: var(--text-dim); font-size: 0.9rem; }
  .footer { color: var(--text-dim); font-size: 0.85rem; margin-top: 2rem; }
</style>
</head>
<body>
<nav>
  <div class="logo">Course Design Progress</div>
  <div class="spacer"></div>
  <div class="theme-toggle" id="theme-toggle" title="Toggle light/dark">
    <i class="fa-solid fa-circle-half-stroke"></i>
  </div>
</nav>
<main>
  <h1>Course Design Progress</h1>
  <p class="subtitle">Internal authoring tracker — DC Graphic Design BA. Single source of truth for per-course status. Update inline below as work progresses.</p>

  <div class="stats-row" id="stats"></div>

  <table class="tracker">
    <thead>
      <tr>
        <th>Course</th>
        <th>Title</th>
        <th>Stage</th>
        <th>Assignments</th>
        <th>Notes / blockers</th>
      </tr>
    </thead>
    <tbody id="tracker-body"></tbody>
  </table>

  <p class="footer">Update the <code>courses</code> array in this file's source to advance a stage. Then re-open or refresh the page. Stages: 0 not-started · 1 scaffold · 2 existing-materials · 3 source-analysis · 4 authoring-plan · 5 authoring · 6 validate · 7 review · 8 published.</p>
</main>
<script>
const STAGES = [
  "0 — not started",
  "1 — scaffold",
  "2 — existing-materials review",
  "3 — source analysis",
  "4 — authoring plan",
  "5 — authoring",
  "6 — validate",
  "7 — review",
  "8 — published"
];

// SOURCE OF TRUTH for tracker. Update by hand as work advances.
const courses = [
  { code: "DSGN 114", title: "Intro to Graphic Design", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 105", title: "Digital Imaging", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 107", title: "Digital Illustration", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 205", title: "Page Layout", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 220", title: "Design Thinking", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 230", title: "Design History", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 312", title: "Packaging Design", stage: 1, assignments: 0, planned: null, notes: "Scaffolded as smoke test for the system." },
  { code: "DSGN 310", title: "Corporate Brand Communication", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 320", title: "Motion Graphics", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 412", title: "Portfolio Design", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 498", title: "Senior Capstone", stage: 0, assignments: 0, planned: null, notes: "" },
  { code: "DSGN 410", title: "The Business of Graphic Design", stage: 4, assignments: 0, planned: null,
    notes: "Source + materials analysis complete. Gaps flagged: data-viz, proposal writing, AI-as-tool, ethics scenario. Authoring plan TBD." },
  { code: "DSGN 491", title: "Design Internship", stage: 0, assignments: 0, planned: null, notes: "" }
];

function render() {
  const tbody = document.getElementById('tracker-body');
  tbody.innerHTML = courses.map(c => `
    <tr>
      <td><strong>${c.code}</strong></td>
      <td>${c.title}</td>
      <td><span class="pill pill-${c.stage}">${STAGES[c.stage]}</span></td>
      <td>${c.assignments}${c.planned !== null ? ' / ' + c.planned : ''}</td>
      <td class="notes">${c.notes || '—'}</td>
    </tr>
  `).join('');

  const total = courses.length;
  const started = courses.filter(c => c.stage > 0).length;
  const validated = courses.filter(c => c.stage >= 6).length;
  const totalAssignments = courses.reduce((s, c) => s + (c.assignments || 0), 0);
  document.getElementById('stats').innerHTML = `
    <div class="stat-card"><div class="stat-num">${total}</div><div class="stat-label">Total courses</div></div>
    <div class="stat-card"><div class="stat-num">${started}</div><div class="stat-label">Courses started</div></div>
    <div class="stat-card"><div class="stat-num">${validated}</div><div class="stat-label">Validated</div></div>
    <div class="stat-card"><div class="stat-num">${totalAssignments}</div><div class="stat-label">Assignments authored</div></div>
  `;
}

document.getElementById('theme-toggle').addEventListener('click', () => {
  const cur = document.documentElement.getAttribute('data-theme');
  document.documentElement.setAttribute('data-theme', cur === 'light' ? 'dark' : 'light');
});

render();
</script>
</body>
</html>
```

- [ ] **Step 2: Verify the file is well-formed and renders**

```bash
test -f course-design/progress.html && grep -c "DSGN " course-design/progress.html
```
Expected: a number ≥ 13 (one per course in the JS array, plus possibly more in comments).

```bash
# Open in browser; visual check that the tracker renders, theme toggle works,
# and DSGN 312 shows stage 1, DSGN 410 shows stage 4.
open course-design/progress.html
```

- [ ] **Step 3: Commit**

```bash
git add course-design/progress.html
git commit -m "Add progress.html: standalone tracker for course-design work"
```

---

### Task 8: Create `course-design/README.md`

**Files:**
- Create: `course-design/README.md`

- [ ] **Step 1: Write the file**

Write to `course-design/README.md`:

```markdown
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
| 5 — Author assignments | Per planned assignment, copy `assignments/00-template-copy.md` and fill it out | One MD per assignment |
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
│   └── authoring-plan-template.md
└── <course-slug>/             # one per course as work progresses
    ├── <course>-source-analysis.md
    ├── <course>-existing-materials-analysis.md
    ├── <course>-authoring-plan.md
    └── assignments/
        ├── 00-template-copy.md  # fresh seed copy; not counted as a real assignment
        ├── 01-<slug>.md
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
```

- [ ] **Step 2: Verify**

```bash
test -f course-design/README.md && grep -c "^##" course-design/README.md
```
Expected: a small number (5–7 sections present).

- [ ] **Step 3: Commit**

```bash
git add course-design/README.md
git commit -m "Add course-design README: pipeline doc and how-to-use guide"
```

---

### Task 9: End-to-end smoke test

**Files:**
- (No new files; verifies the system works)

- [ ] **Step 1: Resolve the DSGN 312 ⚠ so the validator can pass on existing-materials check**

The DSGN 312 folder was created in Task 5 with no existing source materials. The validator currently fails because the ⚠ notice is still in place. For this smoke test, resolve it by editing the file.

```bash
# Replace the ⚠ paragraph with a "confirmed" line so we can see a clean validator pass
python3 - <<'PY'
import pathlib
p = pathlib.Path("course-design/dsgn-312/dsgn-312-existing-materials-analysis.md")
text = p.read_text()
needle = "⚠ **No existing source folder detected**"
if needle in text:
    # Replace the entire warning sentence with a one-line "Confirmed none"
    import re
    new = re.sub(
        r"⚠ \*\*No existing source folder detected\*\*[^\n]*",
        "**Existing materials:** Confirmed none on 2026-05-08 (smoke-test scaffolding).",
        text)
    p.write_text(new)
    print("resolved")
else:
    print("nothing to resolve")
PY
```

Expected: `resolved` (or `nothing to resolve` on a re-run).

- [ ] **Step 2: Run the validator on all courses**

```bash
./scripts/validate-course-design.sh
```

Expected output ends with: `=== Summary: 0 of 2 courses pass ===` and `Failures: dsgn-312 dsgn-410`.

The failures are expected: neither course has any real assignments authored yet, so the CLO coverage check fails for both. This is the correct behavior — the validator is designed for finished or near-finished courses.

- [ ] **Step 3: Verify progress.html opens**

```bash
open course-design/progress.html
```

Visual check:
- The page renders with dark theme by default
- 13 rows, one per course
- DSGN 312 shows stage "1 — scaffold" with the smoke-test note
- DSGN 410 shows stage "4 — authoring plan"
- Stats row: Total 13, Started 2, Validated 0, Assignments 0
- Theme toggle in nav switches dark/light

- [ ] **Step 4: Commit the smoke-test resolution**

```bash
git add course-design/dsgn-312/dsgn-312-existing-materials-analysis.md
git commit -m "Resolve DSGN 312 existing-materials warning (smoke-test scaffolding)"
```

---

## Self-review checklist

After all tasks complete:

- [ ] All four templates exist under `course-design/templates/` (3 new + 1 pre-existing).
- [ ] Both scripts are executable and run successfully on DSGN 410 and DSGN 312.
- [ ] `course-design/progress.html` renders with 13 courses and theme toggle works.
- [ ] `course-design/README.md` documents pipeline, layout, templates, validation.
- [ ] `.gitignore` excludes `.DS_Store` and `.cache/`.
- [ ] No spec section without a task. Spec sections covered:
  - Folder/templates → Tasks 2, 3, 4
  - Scaffold script → Task 5
  - Validation script → Task 6
  - README → Task 8
  - progress.html → Task 7
  - .cache/ gitignore → Task 1
- [ ] Existing files NOT modified by this work: `program-overview.html`, `index.html`, `source/program-data.md`, `source/<existing folders>`, `course-design/dsgn-410/*` (except possibly the existing-materials file if it had a ⚠; check).
- [ ] `git log --oneline` shows ~9 commits, one per task, with informative messages.

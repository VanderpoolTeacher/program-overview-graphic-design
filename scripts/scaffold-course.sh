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
  local tpl="$1" dest="$2"
  if [ -e "$dest" ]; then
    note "skip (exists): $dest"
    return
  fi
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

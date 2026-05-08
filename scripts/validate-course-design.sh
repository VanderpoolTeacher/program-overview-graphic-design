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

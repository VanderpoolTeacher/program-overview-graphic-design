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

# 3. Find/replace residue: 'MLO' followed by a lowercase letter that isn't 's'
# (catches exMLOre, emMLOyment, etc., but allows 'MLOs' plural).
if grep -nE 'MLO[a-rt-z]' "$FILE" > /tmp/mlo-residue.txt; then
  cat /tmp/mlo-residue.txt
  rm -f /tmp/mlo-residue.txt
  fail "find/replace residue (MLO inside a word) detected"
fi
rm -f /tmp/mlo-residue.txt
pass "no find/replace residue"

# 4. Critical: DSGN 205 has MLO 5 in its course-level mlos
sed -n '/^## DSGN 205 /,/^## /p' "$FILE" | grep -m1 "^mlos:" | grep -q "5" \
  || fail "DSGN 205 must include MLO 5 in its course-level mlos"
pass "DSGN 205 includes MLO 5"

# 5. Critical: DSGN 310 CLO 3 has MLO 5
clo3_line=$(sed -n '/^## DSGN 310 /,/^## /p' "$FILE" \
  | sed -n '/^3\. Design brand collateral/{n;p;}')
echo "$clo3_line" | grep -q "5" \
  || fail "DSGN 310 CLO 3 must include MLO 5 (got: $clo3_line)"
pass "DSGN 310 CLO 3 includes MLO 5"

# 6. Plan total credits == 120 (portable: extract numbers from semester headings, sum with awk)
total=$(grep "^### " "$FILE" \
  | grep -oE '\([0-9]+ cr\)' \
  | grep -oE '[0-9]+' \
  | awk '{s += $1} END {print s+0}')
[ "$total" -eq 120 ] || fail "plan total credits expected 120, got $total"
pass "plan totals 120 credits"

# 7. Every CLO arrow line has 3-space indent (no more, no less)
bad_indent=$(grep -nE "→ MLOs:" "$FILE" | grep -vE "^[0-9]+:   →" || true)
if [ -n "$bad_indent" ]; then
  echo "$bad_indent"
  fail "CLO arrow lines must have exactly 3-space indent"
fi
pass "CLO indent is 3 spaces"

echo "All checks passed."

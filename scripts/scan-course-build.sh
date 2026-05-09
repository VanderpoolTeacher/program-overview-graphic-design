#!/usr/bin/env bash
# Scans a course's build state and emits JSON consumed by the
# per-course build-status HTML dashboard.
#
# Reads:    course-design/<slug>/build-manifest.yml
# Checks:   filesystem (does the file exist?), git log (last modified),
#           GitHub issue state via `gh` CLI (when manifest entries
#           include an `issue:` field)
# Writes:   course-design/<slug>/<slug>-build-status.json
#
# Usage:
#   ./scripts/scan-course-build.sh DSGN410
#   ./scripts/scan-course-build.sh "DSGN 410"

set -euo pipefail

[ $# -eq 1 ] || { echo "Usage: $0 <COURSE_CODE>"; exit 1; }
NUM=$(printf '%s' "$1" | grep -oE '[0-9]+' | head -1)
[ -n "$NUM" ] || { echo "ERROR: could not extract course number from '$1'"; exit 1; }
SLUG="dsgn-$NUM"

MANIFEST="course-design/$SLUG/build-manifest.yml"
OUT="course-design/$SLUG/$SLUG-build-status.json"

test -f "$MANIFEST" || { echo "ERROR: $MANIFEST not found"; exit 1; }
command -v python3 >/dev/null || { echo "ERROR: python3 required"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "ERROR: PyYAML required (pip3 install pyyaml)"; exit 1; }

# `gh` CLI is optional — if missing, issue state queries are skipped.
HAS_GH=$(command -v gh >/dev/null 2>&1 && echo 1 || echo 0)

python3 - "$SLUG" "$MANIFEST" "$OUT" "$HAS_GH" <<'PY'
import sys, json, subprocess, pathlib, datetime, yaml

slug, manifest_path, out_path, has_gh_str = sys.argv[1:5]
has_gh = has_gh_str == "1"
course_dir = f"course-design/{slug}"

manifest = yaml.safe_load(pathlib.Path(manifest_path).read_text())

def file_exists(rel):
    return bool(rel) and pathlib.Path(course_dir + "/" + rel).is_file()

def git_last_modified(rel):
    if not rel:
        return None
    try:
        out = subprocess.check_output(
            ["git", "log", "-1", "--format=%aI", "--", course_dir + "/" + rel],
            stderr=subprocess.DEVNULL).decode().strip()
        return out or None
    except Exception:
        return None

# Cache issue lookups so we only hit GitHub once per issue
_issue_cache = {}
def issue_data(num):
    if not num or not has_gh:
        return None
    if num in _issue_cache:
        return _issue_cache[num]
    try:
        out = subprocess.check_output(
            ["gh", "issue", "view", str(num), "--json", "state,labels,title,url"],
            stderr=subprocess.DEVNULL).decode()
        data = json.loads(out)
    except Exception:
        data = None
    _issue_cache[num] = data
    return data

categories_in = manifest.get("categories", []) or []
categories_out = []

for cat in categories_in:
    if not isinstance(cat, dict):
        continue
    name = cat.get("name")
    if not name:
        continue
    artifacts_in = cat.get("artifacts", []) or []
    artifacts_out = []
    for a in artifacts_in:
        if not isinstance(a, dict):
            continue
        rel = a.get("file") or ""
        exists = file_exists(rel)
        last_mod = git_last_modified(rel) if exists else None
        issue_num = a.get("issue")
        iss = issue_data(issue_num)
        manual_state = a.get("state")

        if manual_state:
            state = manual_state
        elif exists:
            state = "done"
        elif iss:
            if str(iss.get("state", "")).upper() == "OPEN":
                labels = [l.get("name", "") for l in (iss.get("labels") or [])]
                state = "blocked" if "blocked" in labels else "in-progress"
            else:
                state = "not-started"
        else:
            state = "not-started"

        artifacts_out.append({
            "name": a.get("name", "(unnamed)"),
            "file": rel,
            "exists": exists,
            "last_modified": last_mod,
            "issue": issue_num,
            "issue_state": (iss.get("state").lower() if iss and iss.get("state") else None),
            "issue_url": (iss.get("url") if iss else None),
            "state": state,
            "notes": a.get("notes", "") or ""
        })
    categories_out.append({"name": name, "artifacts": artifacts_out})

# Compute totals
all_arts = [a for c in categories_out for a in c["artifacts"]]
counts = {s: 0 for s in ("done", "in-progress", "not-started", "blocked", "iterated")}
for a in all_arts:
    counts[a["state"]] = counts.get(a["state"], 0) + 1

result = {
    "course": manifest.get("course") or slug.upper(),
    "slug": slug,
    "first_run": manifest.get("first_run") or "",
    "program_stage": manifest.get("program_stage"),
    "scanned_at": datetime.datetime.now().astimezone().isoformat(),
    "gh_available": has_gh,
    "totals": {"artifacts": len(all_arts), **counts},
    "categories": categories_out
}

pathlib.Path(out_path).write_text(json.dumps(result, indent=2))
print(f"Wrote {out_path}  ({len(all_arts)} artifacts; "
      f"{counts['done']} done, {counts['in-progress']} in-progress, "
      f"{counts['not-started']} not-started, {counts['blocked']} blocked)")
PY

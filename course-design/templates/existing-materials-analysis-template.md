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

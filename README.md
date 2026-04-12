# DC Graphic Design Program Overview

Interactive single-page presentation for the Defiance College Graphic Design major. Built as a standalone HTML/CSS/JS file with no framework dependencies.

## Views

| Tab | Description |
|-----|-------------|
| **Overview** | Program stats (8 MLOs, 13 courses, 78 CLOs, 0 gaps), domain descriptions, and key design highlights |
| **Program MLOs** | 8 Bloom-aligned Major Learning Outcomes across 4 domains — click any MLO to see which courses address it |
| **Courses** | 13 core courses with expandable CLO details and MLO mapping, filterable by level (Foundational, Intermediate, Advanced, Capstone) |
| **Alignment Matrix** | Full course-to-MLO alignment grid with hover highlighting and domain legend |
| **Plan of Study** | Four-year, 120-credit degree plan (Catalog 2025-26) with semester-by-semester course layout |

## Domains

| Domain | Icon | MLOs | Color |
|--------|------|------|-------|
| Conceptual | `fa-lightbulb` | 1, 3 | Purple |
| Technical | `fa-laptop-code` | 2, 4 | Blue |
| Applied | `fa-chart-column` | 5 | Orange |
| Professional | `fa-briefcase` | 6, 7, 8 | Green |

## Features

- Dark and light mode toggle (defaults to dark)
- Font Awesome 6.5.1 domain icons
- Color-coded domains with distinct dark-mode and light-mode palettes
- Responsive layout for mobile and desktop
- Accessible typography (12pt minimum, 1.5 line height)
- Animated tab transitions

## Color Palette

| Name | Hex | Role |
|------|-----|------|
| Indigo Velvet | `#4F2683` | Primary brand, light-mode accent |
| Dark Amethyst | `#221338` | Light-mode body text |
| Tech Blue | `#2F61AE` | Light-mode Technical domain color |
| Lavender Grey | `#7F8EAA` | UI chrome |
| Pale Oak | `#CCC4A8` | Dark-mode accent, secondary text |

## Files

| File | Purpose |
|------|---------|
| `program-overview.html` | Main application (all HTML, CSS, and JS in one file) |
| `index.html` | Redirect to `program-overview.html` |

## Usage

Open `index.html` in a browser. No build step or server required.

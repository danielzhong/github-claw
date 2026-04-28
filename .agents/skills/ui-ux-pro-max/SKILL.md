# Skill: ui-ux-pro-max

## Overview

A comprehensive UI/UX design system skill pack. Generate high-quality interface designs using 50+ visual styles, 161 color schemes, and 57 curated font pairings.

## Capabilities

- Generate full-page UI layouts from a natural language description
- Apply predefined visual styles (minimal, glassmorphism, brutalist, neomorphism, etc.)
- Suggest and apply color palettes based on brand or mood
- Pair typography for headings, body text, and UI labels
- Produce HTML + CSS + JS static output ready for deployment

## How to Invoke

Tell the AI assistant:

```
Use the ui-ux-pro-max skill to design [describe your page or component].
```

The assistant will read this file, apply the design system rules, and produce output.

## Style Catalogue (sample)

| Category | Examples |
|----------|---------|
| Layout | Card grid, hero + features, sidebar dashboard, landing page |
| Visual style | Minimal, glassmorphism, brutalist, dark mode, pastel |
| Color schemes | 161 palettes covering warm, cool, neutral, high-contrast, brand-safe |
| Font pairings | 57 combinations (serif + sans, display + body, mono + humanist) |

## Output Format

- Single-file `index.html` with embedded CSS and optional vanilla JS
- Responsive by default (mobile-first)
- No external build tools required

## Notes

- Prefer Tailwind CDN for utility classes when styling complexity is low
- For complex layouts, write raw CSS in a `<style>` block
- Always include a `meta viewport` tag and sensible base font size

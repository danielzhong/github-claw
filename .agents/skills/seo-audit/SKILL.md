# Skill: seo-audit

## Overview

An SEO audit and optimization skill pack. Automatically analyzes page structure, keyword density, meta tags, and technical SEO signals, then produces an actionable report with recommendations.

## Capabilities

- Audit HTML pages for on-page SEO issues
- Check meta tags: title, description, Open Graph, canonical
- Analyze heading hierarchy (H1–H6) and keyword usage
- Detect missing alt text on images
- Flag slow-loading resources (large images, render-blocking scripts)
- Suggest internal linking improvements
- Generate a structured SEO report in Markdown

## How to Invoke

Tell the AI assistant:

```
Use the seo-audit skill to audit [URL or file path].
```

Provide: the target URL or HTML file, the primary keyword(s) to optimize for, and any competitor URLs for comparison (optional).

## Audit Checklist

| Category | Checks |
|----------|--------|
| Meta | Title length (50–60 chars), description length (150–160 chars), canonical tag |
| Content | H1 presence, keyword in H1, keyword density (1–3%), readability |
| Images | Alt text present, file size < 200 KB, descriptive filenames |
| Technical | HTTPS, mobile viewport, robots meta, structured data (JSON-LD) |
| Performance | Render-blocking resources, image lazy loading, Core Web Vitals hints |

## Output Format

A Markdown report with:
1. **Summary score** (0–100)
2. **Critical issues** (must fix)
3. **Warnings** (should fix)
4. **Suggestions** (nice to have)
5. **Rewritten meta tags** ready to copy-paste

## Notes

- For live URL audits the assistant will fetch the page HTML via `fetch()`
- For local files pass the absolute path to the HTML file
- Keyword density targets are guidelines; adjust for content type

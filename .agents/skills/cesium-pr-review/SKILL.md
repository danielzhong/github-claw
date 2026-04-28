# Skill: cesium-pr-review

## Overview

A specialized Cesium pull request review skill. When invoked, it performs a thorough review of a CesiumGS/cesium PR against the official Coding Guide and Code Review Guide, posts structured feedback directly on the PR, and provides a live Sandcastle preview hosted from a Codespace so reviewers can interact with the changes instantly.

## Capabilities

- Review every changed file against the [Cesium Coding Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md) and [Code Review Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodeReviewGuide/README.md)
- Post a structured review comment on the PR with a checklist of findings; if a rule is violated and no comment already covers it, add the comment
- Extract or generate a Sandcastle demo from the PR description, code changes, or test files
- Download any test data files attached to the PR (e.g. glTF, 3D Tiles, images) and host them via `http-server ./ --cors=X-Correlation-Id` from the active Codespace
- Produce a ready-to-paste Sandcastle snippet that points at the hosted asset URL so reviewers can see a fully working demo with one copy-paste

## How to Invoke

```
Use the cesium-pr-review skill to review PR #<number> in CesiumGS/cesium.
```

Optional parameters:
- `codespace_host` — base URL of your running Codespace (e.g. `https://miniature-doodle-vg6gx5wvrrphwg57-8081.app.github.dev`). If omitted the skill will remind you to provide one.
- `port` — port used by http-server inside the Codespace (default: `8081`)

## Review Workflow

### Step 1 — Fetch the PR

1. Read the PR title, description, linked issue, and all changed files using the GitHub MCP tools.
2. Check for an existing Contributor License Agreement (CLA) for the author. If missing, note it in the review.
3. Identify which areas of CesiumJS are touched: rendering, scene, math, widgets, GLSL, documentation, tests, etc.

### Step 2 — Apply the Coding Guide rules

Read every changed `.js`, `.glsl`, and `.html` file and check for the following. For each violation, record the file path, line number (if determinable), violated rule, and a concrete suggestion.

| Category | Key rules to enforce |
|----------|----------------------|
| **Naming** | Directory names `PascalCase`; constructors `PascalCase`; functions/variables `camelCase`; private members prefixed with `_`; constants `UPPER_SNAKE_CASE`; no excessive abbreviations; files named after the identifier they export |
| **Formatting** | Code should be `prettier`-formatted; HTML uses double quotes; files end with a newline |
| **Linting** | No `alert`; no floating decimals (`.5` → `0.5`); no implicit globals; no `else` after `return`; single quotes in JS strings; no use-before-define |
| **Functions** | Options objects used for ≥ 3 parameters; defaults use `defaultValue()`; errors thrown via `DeveloperError` / `RuntimeError`; scratch `result` parameters used for allocations in hot paths |
| **Classes** | Constructor at top of file; `from` constructors are static; `to` functions return new instances; static constants use `Object.freeze()`; prototype functions on fundamental classes used sparingly |
| **Design** | Deprecation warnings added for any removed or renamed public API; `CHANGES.md` updated |
| **GLSL** | Naming matches JS conventions adapted for GLSL; no `#include` loops; prefer built-in functions; avoid texture fetches inside loops |
| **Tests** | New behaviour must have spec coverage; specs follow the pattern in `Specs/`; no hard-coded pixel counts without justification |
| **Documentation** | New public API has JSDoc (`@param`, `@returns`, `@exception`, `@example`); `@example` uses Sandcastle-compatible code |

### Step 3 — Apply the Code Review Guide rules

| Check | Action |
|-------|--------|
| PR has a clear description and links to an issue | Note if missing |
| New public API → `CHANGES.md` updated | Verify and flag if not |
| New public API → reference docs added | Verify and flag if not |
| Deprecated/breaking changes handled correctly | Verify against the deprecation pattern |
| All CI checks pass (GitHub Actions: build, ESLint, docs) | Report current status |
| Sandcastle example included or updated for user-visible changes | Generate one if absent (see Step 4) |
| Scope creep | Flag any changes unrelated to the stated goal |
| Tests run locally | Note that the reviewer should run `npm run test` |

### Step 4 — Sandcastle preview

1. **Find existing Sandcastle code**: search the PR description and comments for a Sandcastle snippet (look for `const viewer = new Cesium.Viewer` or `Sandcastle.addDefaultToolbarButton`).
2. **Extract test data URLs**: look for download links to `.glb`, `.gltf`, `.b3dm`, `.i3dm`, `.cmpt`, `.terrain`, `.jpg`, `.png`, `.kml`, `.czml` files in the PR description or linked issues.
3. **If test data files exist**:
   a. Download each file into a temporary directory (e.g. `/tmp/cesium-pr-<number>/`).
   b. Start `http-server` in that directory:
      ```bash
      npx http-server /tmp/cesium-pr-<number>/ --cors=X-Correlation-Id --port <port>
      ```
   c. Replace any relative or placeholder URLs in the Sandcastle snippet with the fully qualified Codespace URL:
      `https://<codespace_host>/<filename>`
4. **If no Sandcastle code exists**: generate a minimal working example based on the PR's changed API or feature using the pattern below.
5. **Produce the final Sandcastle snippet**: wrap the code so it is self-contained and directly paste-able into [Cesium Sandcastle](https://sandcastle.cesium.com/).

#### Sandcastle template

```javascript
// Auto-generated preview for PR #<number>: <PR title>
// Hosted assets: <codespace_host>
const viewer = new Cesium.Viewer("cesiumContainer");

// --- BEGIN PREVIEW CODE ---
// <insert feature-specific code here>
// --- END PREVIEW CODE ---
```

### Step 5 — Post the review comment

Compose a single GitHub PR comment with the following structure and post it using the GitHub MCP `create_review` or `add_comment` tool:

```markdown
## 🔍 Cesium PR Review — Automated

### Coding Guide Checklist
<!-- One line per finding; ✅ = passes, ⚠️ = suggestion, ❌ = violation -->
- [ ] ❌ **Naming** — `myFunction_` should be `_myFunction` (private member prefix) — `Source/Scene/Foo.js:42`
- [ ] ✅ Formatting — prettier-compatible
- [ ] ⚠️ **CHANGES.md** — new public method `Bar.fromValue()` is not listed
...

### Code Review Guide Checklist
- [ ] ✅ PR description is clear
- [ ] ❌ **Reference docs** — `Bar.fromValue()` has no JSDoc `@param` or `@returns`
- [ ] ✅ CI checks pass
...

### 🚀 Sandcastle Preview

Paste the snippet below into [Cesium Sandcastle](https://sandcastle.cesium.com/) to preview this PR:

\`\`\`javascript
<generated or extracted snippet>
\`\`\`

**Hosted assets** (served from Codespace):
- `<codespace_host>/<file1>` — <description>

> Preview hosted via `http-server` on `<codespace_host>`.
> Re-run the skill after each push to get an updated snippet.

---
*Generated by the `cesium-pr-review` skill. Rules sourced from the [Coding Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md) and [Code Review Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodeReviewGuide/README.md).*
```

If a previous review comment from this skill already exists on the PR, **edit it** (update in place) rather than adding a duplicate.

## Hosting Setup (Codespace)

The skill assumes you have a Codespace (or any GitHub-forwarded port) with `http-server` available. To prepare your environment once:

```bash
# Inside your Cesium Codespace terminal
npm install -g http-server

# Serve the temp directory for a specific PR
npx http-server /tmp/cesium-pr-<number>/ --cors=X-Correlation-Id --port 8081
```

The forwarded URL will be in the form:
`https://<codespace-name>-8081.app.github.dev/`

Provide this URL to the skill via the `codespace_host` parameter so it can construct the correct asset links inside the Sandcastle snippet.

## Output Summary

| Output | Description |
|--------|-------------|
| PR review comment | Posted/updated on the GitHub PR with a checklist of Coding Guide + Code Review Guide findings |
| Sandcastle snippet | Ready-to-paste JavaScript that renders the feature/fix with hosted assets |
| Asset server command | `http-server` command to run in your Codespace for any downloadable test files |
| Preview link | Direct Sandcastle link with the snippet pre-filled (if the Sandcastle URL API is available) |

## Notes

- Rules are sourced **exclusively** from the official guides:
  - [Coding Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md)
  - [Code Review Guide](https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodeReviewGuide/README.md)
- The skill does **not** override CI; it complements it. Always ensure GitHub Actions checks pass before merging.
- For very large PRs (>50 changed files) the skill will focus on the most impactful files (new public API, new shaders, changed spec files) and note that a full file-by-file review was not performed.
- Sandcastle snippets are generated in good faith. They may need manual tweaking for complex features.

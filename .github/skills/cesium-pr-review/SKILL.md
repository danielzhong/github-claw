# Cesium PR Review Skill

## Purpose

Review pull requests in the [CesiumGS/cesium](https://github.com/CesiumGS/cesium) repository against official Cesium coding and review guidelines, then provide a live-preview environment so the user can immediately see and test the changes.

## When to Invoke

Invoke this skill when the user asks to review a Cesium PR, e.g.:

```
Use the cesium-pr-review skill to review https://github.com/CesiumGS/cesium/pull/NNNNN.
```

---

## Mandatory Steps (ALL are required)

Every invocation MUST execute **all seven steps below in order**. If any step cannot be completed, the agent MUST add a **"Blocked / Not Completed"** section at the end explaining exactly why, what was attempted, and what the user can do to unblock it.

### Step 1 — Fetch the Cesium Guidelines

Read **both** documents in full before reviewing any code:

1. **Coding Guide**: <https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodingGuide/README.md>
2. **Code Review Guide**: <https://github.com/CesiumGS/cesium/blob/main/Documentation/Contributors/CodeReviewGuide/README.md>

Use the GitHub MCP `get_file_contents` tool or `web_fetch` to retrieve these. Do NOT skip or summarise from memory — always fetch the latest version.

### Step 2 — Fetch the PR

Retrieve the PR metadata, diff, description, comments, and changed files using GitHub MCP tools:

- `pull_request_read` with methods: `get`, `get_diff`, `get_files`, `get_comments`, `get_review_comments`

Record:
- PR title, author, description body
- All changed files and their diffs
- Any Sandcastle code snippets mentioned in the description or comments
- Any downloadable test asset URLs (`.glb`, `.gltf`, `.3dtiles`, `.b3dm`, `.json`, etc.)

### Step 3 — Review Against Guidelines

Compare every changed file / diff hunk against the Coding Guide and Code Review Guide. For each violation found, prepare a review comment with:

- **File & line reference**
- **Rule violated** (quote the relevant guideline section)
- **Suggested fix**

If no violations are found, state that explicitly.

### Step 4 — Post or Prepare Review Comments

Post the review comments on the PR (if the agent has write access), **or** output them in a ready-to-paste format so the user can post them manually.

### Step 5 — Obtain Sandcastle Code

1. **First**, look for Sandcastle code in the PR description, PR comments, or changed test files.
2. If found, extract it verbatim.
3. If **not** found, generate a minimal but functional Sandcastle example that exercises the feature or fix introduced by the PR. The code must be copy-paste ready for <https://sandcastle.cesium.com/>.

### Step 6 — Download Test Assets & Start Preview Server

This step is **MANDATORY**. The agent MUST attempt to start a server.

1. Create a temporary working directory:
   ```bash
   PREVIEW_DIR=$(mktemp -d)
   cd "$PREVIEW_DIR"
   ```

2. Download any test assets referenced in the PR (model files, tilesets, etc.):
   ```bash
   # Example — adapt URLs to the actual PR
   curl -L -O "https://example.com/asset.glb"
   ```

3. Start the preview server on port **8081**:
   ```bash
   npx http-server ./ --cors=X-Correlation-Id -p 8081 &
   SERVER_PID=$!
   sleep 3
   # Verify it started
   curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/ || echo "SERVER FAILED TO START"
   ```

4. If the server fails to start, report the exact error in the **Blocked / Not Completed** section. Do NOT silently skip.

### Step 7 — Return Hosted URLs & Sandcastle Code

Construct and return:

1. **Codespaces preview base URL** (the user's Codespaces forwarded port):
   ```
   https://miniature-doodle-vg6gx5wvrrphwg57-8081.app.github.dev/
   ```

2. **Full hosted asset URLs**, e.g.:
   ```
   https://miniature-doodle-vg6gx5wvrrphwg57-8081.app.github.dev/asset.glb
   ```

3. **Ready-to-paste Sandcastle code** that references the hosted URLs above so the user can paste it directly into Sandcastle and see the demo without modification.

---

## Output Format

The final response MUST include these sections (use these exact headings):

```markdown
## PR Summary
<PR number, title, author, one-line description>

## Guideline Violations
<Table or list of violations, or "None found">

## Review Comments
<Ready-to-post comments, or confirmation they were posted>

## Sandcastle Code
<Copy-paste-ready code block>

## Hosted Preview
- Server status: running / failed
- Base URL: https://miniature-doodle-vg6gx5wvrrphwg57-8081.app.github.dev/
- Asset URLs:
  - <list each hosted file>

## Blocked / Not Completed
<If ALL steps succeeded, write "All steps completed successfully.">
<Otherwise, explain each incomplete step, what was tried, and how to unblock.>
```

---

## Helper Script

A convenience script `prepare-preview.sh` is provided in this skill folder. The agent MAY use it, but completing the steps above is mandatory regardless of whether the script is used.

Usage:
```bash
bash .github/skills/cesium-pr-review/prepare-preview.sh <PR_NUMBER> [PORT]
```

---

## Important Notes

- **Never skip the server step.** Even if there are no downloadable assets, start the server with at least an empty directory or a generated HTML file so the user always gets a working preview URL.
- **Always use the exact Codespaces host URL** provided above unless the user specifies a different one. The default `miniature-doodle-vg6gx5wvrrphwg57` is the owner's current Codespace name; update it in this file if the Codespace is recreated.
- **Always fetch the latest guidelines** — do not rely on cached or memorised versions.
- **The Sandcastle code must reference hosted URLs**, not local paths, so it works when pasted into sandcastle.cesium.com.

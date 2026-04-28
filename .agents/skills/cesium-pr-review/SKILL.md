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

### Step 6 — Find the Deployment Preview Link from the PR

This step is **MANDATORY**. The agent MUST attempt to find the deployment link.

The CesiumGS/cesium repository has a GitHub Actions workflow that deploys a preview for each PR. The deployment shows up as a check/status on the PR, typically named something like:

- `deploy / artifact: deployment`
- `deploy / artifact: deployment — Deployed`

To find the deployment URL:

1. Use the GitHub MCP `pull_request_read` tool with method `get_check_runs` to list the check runs / statuses on the PR's head commit.
2. Look for a check run or deployment status whose name contains **"deploy"** or **"deployment"**.
3. Extract the **deployment URL** from the check run's `details_url`, or from the deployment environment URL. This is the live preview link that users normally click in the PR UI.
4. If no deployment is found or the deployment has not completed yet, report this in the **Blocked / Not Completed** section. Do NOT silently skip.

### Step 7 — Return Deployment URL & Sandcastle Code

Construct and return:

1. **Deployment preview URL** — the link extracted from the PR's deployment status in Step 6.

2. **Ready-to-paste Sandcastle code** that references the deployment preview URL (and any hosted asset paths) so the user can paste it directly into Sandcastle and see the demo without modification.

3. If test assets are referenced in the PR, construct the full asset URLs relative to the deployment preview URL.

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

## Deployment Preview
- Deployment status: deployed / pending / not found
- Preview URL: <deployment URL from PR checks>
- Asset URLs (if applicable):
  - <list each hosted file relative to the deployment URL>

## Blocked / Not Completed
<If ALL steps succeeded, write "All steps completed successfully.">
<Otherwise, explain each incomplete step, what was tried, and how to unblock.>
```

---

## Important Notes

- **Never skip the deployment link step.** Always attempt to find the deployment URL from the PR's GitHub Actions checks. If the deployment is not found or not yet ready, report this clearly.
- **Always fetch the latest guidelines** — do not rely on cached or memorised versions.
- **The Sandcastle code must reference the deployment preview URL**, not local paths, so it works when pasted into sandcastle.cesium.com.

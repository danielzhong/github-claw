# memory/log.md — Task Log

_Rolling log of completed tasks. Oldest entries are pruned once they are no longer actionable. For persistent facts, see `MEMORY.md`._

---

## 2026-05-11 — Pause Cesium Daily PR Digest bot

- Commented out the cron schedule in `.github/workflows/cesium-daily-pr.yml`
- The workflow can still be triggered manually via `workflow_dispatch`
- Outcome: No more automatic daily issues; re-enable by uncommenting the schedule block

## 2026-04-28 — Update cesium-pr-review deploy link to use PR deployment status

- Changed Step 6 from "Download Test Assets & Start Preview Server" (local http-server on port 8081) to "Find the Deployment Preview Link from the PR" (extract deployment URL from PR's GitHub Actions checks)
- Changed Step 7 from hardcoded Codespaces URL to dynamic deployment preview URL
- Updated output format section to show "Deployment Preview" instead of "Hosted Preview"
- Updated Important Notes to remove Codespaces-specific references
- Updated MEMORY.md skills section to reflect new approach
- Outcome: Skill now instructs agent to find deployment link from PR checks (e.g. "deploy / artifact: deployment") instead of spinning up a local server

## 2026-04-28 — Rebuild cesium-pr-review skill (v2, mandatory enforcement)

- Moved skill from `.agents/skills/` to `.github/skills/cesium-pr-review/SKILL.md` (GitHub recommended location)
- Rewrote SKILL.md with 7 mandatory steps — agent MUST execute all or explain failures in a "Blocked / Not Completed" section
- Added `prepare-preview.sh` helper script for asset download + http-server startup
- Key improvements over v1: server start is mandatory (not optional), exact output format enforced, Sandcastle code must use hosted URLs, guidelines must be fetched fresh every time
- Outcome: skill ready; invoke with `Use the cesium-pr-review skill to review <PR URL>`

## 2026-04-28 — Build full repo structure in English

- Rewrote README.md in English: mirrors liyupi/github-claw structure, excludes "AI-produced sub-projects" section, references Cesium PR digest instead of AI tech digest
- Created LICENSE (MIT)
- Created memory/tasks.md
- Created .agents/skills/ with three skill packs: ui-ux-pro-max, ai-image-generation, seo-audit (each with SKILL.md)
- Created .github/workflows/: cesium-daily-pr.yml, issue-handler.yml, deploy-pages.yml
- Updated MEMORY.md: recorded English-only preference
- Outcome: repository structure fully matches reference; all content in English

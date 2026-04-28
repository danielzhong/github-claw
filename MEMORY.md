# MEMORY.md — Long-Term Memory

_This file is Claw's persistent memory. It is updated after tasks when durable facts are learned. Short-term and task-specific notes go in `memory/log.md`._

---

## About the Owner

- Repository: `danielzhong/github-claw`
- Goal: long-term personal AI assistant workspace operating through GitHub Copilot

## Workspace Context

- Initialized: 2026-04-28
- Primary interface: GitHub Copilot web / coding-agent
- Language/stack: not yet established (repository is new)

## Preferences & Patterns

- **Language**: English only — all files, comments, commit messages, and AI responses must be in English

## Key Decisions

- Workspace design follows a lightweight, file-based memory model (no external databases required)
- `AGENTS.md` is the single source of truth for agent behaviour and workflow rules

## Skills

- **cesium-pr-review** (`.agents/skills/cesium-pr-review/SKILL.md`): Reviews CesiumGS/cesium PRs against official Coding Guide & Code Review Guide, finds the deployment preview URL from the PR's GitHub Actions deployment status, and returns ready-to-paste Sandcastle code with the deployment preview URL.

## Open Threads

_(Ongoing topics or questions that span multiple sessions)_

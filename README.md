# github-claw

A ready-to-use **AI Agent workspace template**: built on a GitHub repository, integrating long-term memory, reusable AI skill packs, GitHub Actions automation, and the Copilot coding agent — making AI your long-term collaborative partner.

[![AI Agent](https://img.shields.io/badge/AI%20Agent-Claw-6366f1?style=flat-square)](./AGENTS.md) [![License](https://img.shields.io/badge/license-MIT-22c55e?style=flat-square)](./LICENSE) [![GitHub Actions](https://img.shields.io/github/actions/workflow/status/danielzhong/github-claw/deploy-pages.yml?style=flat-square&label=AI%20Automation)](https://github.com/danielzhong/github-claw/actions)

---

## What Is This

**github-claw** demonstrates how to turn a GitHub repository into an **AI agent with persistent memory, reusable skills, and full automation**. The core is not a specific product — it is a mechanism that keeps AI working continuously:

- 🧠 **Files as Memory**: Preserve AI Agent context across conversations using repository files, achieving true long-term memory beyond the single-session limit.
- 🔧 **AI Skill Packs (Agent Skills)**: Encapsulate capabilities like UI/UX design, AI image generation, and SEO auditing into standardized skill packs that the AI assistant can invoke directly and anyone can reuse.
- ⚡ **GitHub Actions-Driven AI Automation**: Use GitHub Actions to run a daily tracker of new Pull Requests in the [CesiumGS/cesium](https://github.com/CesiumGS/cesium) project, handle Issue triage, auto-assign the Copilot coding agent — all without human intervention.
- 🚀 **Vibe Coding in Practice**: Describe requirements in natural language; the AI Agent handles coding, testing, and deployment automatically.

---

## Quick Start

When starting a new Copilot conversation, tell the assistant:

```
Please read AGENTS.md and MEMORY.md, restore your identity and work state, then continue our work.
```

This lets the AI assistant Claw restore its identity, load long-term memory, and resume from where things left off.

---

## AI Skill Packs

A Skill Pack (Agent Skill) is the core mechanism of this repository — it encapsulates reusable AI capabilities as standard units stored under `.agents/skills/<skill-name>/`, with `SKILL.md` as the main entry point. The AI assistant can invoke any skill directly when given a task.

**Built-in skill packs:**

| Skill Pack | Description |
|------------|-------------|
| `ui-ux-pro-max` | UI/UX design system: 50+ visual styles, 161 color schemes, 57 font pairings — generate high-quality interfaces instantly |
| `ai-image-generation` | Multi-model AI image generation (FLUX, Gemini, Grok, etc.) — text-to-image, image-to-image, LoRA, and more |
| `seo-audit` | SEO audit and optimization suggestions — auto-analyze page structure, keyword density, and technical SEO issues |

**Skill workflow:**

1. Receive a task → check local `.agents/skills/` first, reuse existing skill packs when available
2. No suitable local skill → search GitHub open-source repos or Skills.sh
3. After installing, store under `.agents/skills/<skill-name>/` and update the index

---

## AI Long-Term Memory System

| Level | File Location | Content |
|-------|--------------|---------|
| Long-term memory | `MEMORY.md` | User preferences, project goals, persistent agreements |
| Daily log | `memory/YYYY-MM-DD.md` | AI work records, decisions, and notes for the day |
| Task tracking | `memory/tasks.md` | Cross-session to-dos and progress |
| Skill assets | `.agents/skills/` | Installed, callable AI Agent skill packs |

---

## GitHub Actions AI Automation Workflows

| Workflow | Trigger | AI Capability |
|----------|---------|---------------|
| `cesium-daily-pr.yml` | Daily at 13:00 Beijing time | Automatically fetches new PRs opened in [CesiumGS/cesium](https://github.com/CesiumGS/cesium) that day and publishes a summary Issue |
| `issue-handler.yml` | New Issue created | Auto-replies, detects bug Issues, and assigns them to the Copilot coding agent for automatic fixing |
| `deploy-pages.yml` | Push to `main` touching `site/**` | Automatically deploys the AI-generated static site to GitHub Pages |

---

## Repository Structure

```
github-claw/
├── AGENTS.md                  # AI Agent identity definition and behaviour rules (entry point for every session)
├── MEMORY.md                  # AI long-term memory: user preferences, project background, persistent agreements
├── memory/
│   ├── tasks.md               # AI task tracking (to-do / in-progress / done)
│   └── YYYY-MM-DD.md          # Daily AI work log
├── .agents/
│   └── skills/                # AI Agent skill pack library (discoverable, installable, reusable)
│       ├── ui-ux-pro-max/     # UI/UX design system skill pack
│       ├── ai-image-generation/ # AI image generation skill pack
│       └── seo-audit/         # SEO audit skill pack
└── .github/
    └── workflows/             # AI automation workflows (Cesium PR daily digest, Pages deploy, Issue handling)
```

---

## License

[MIT](./LICENSE)

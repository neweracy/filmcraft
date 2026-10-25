# Kiro setup (fork notes)

Personal setup for driving this FilmCraft fork from [Kiro](https://kiro.dev). These files live
only in this fork (`neweracy/filmcraft`); they are not part of upstream FilmCraft.

## What's configured

### 1. MCP server (drive FilmCraft from Kiro)

The FilmCraft MCP server is registered in two places:

- **This repo** — `.kiro/settings/mcp.json` (workspace-level)
- **Globally** — `~/.kiro/settings/mcp.json` (works in every Kiro project)

Two servers:

| Server | Mode | When it runs |
|---|---|---|
| `filmcraft-headless` | `mcp --demo` | standalone, no app window needed |
| `filmcraft` | `mcp --bridge 127.0.0.1:9876` | the running desktop app (disabled by default) |

Both point at the built binary: `target/release/filmcraft-cli.exe`.

A `web-search` server (DuckDuckGo) is registered alongside so the agent can research editing
techniques. The read-only and composing tools are auto-approved; UI edits still prompt.

### 2. AI editor steering

`.kiro/steering/ai-editor-agent.md` tells the agent how to work:

- **Compose, never download.** Build looks from FilmCraft's own built-in effects and save them
  with `presets.save`. Never download third-party presets, LUTs or transitions (AGENTS.md §1).
- Research technique on the web, then recreate it with the engine, verify with `render_frame`,
  and save the recipe as a preset.

### 3. Auto-update

`scripts/auto-update.sh` fetches upstream, merges `upstream/main`, and rebuilds the CLI. It skips
a dirty tree, aborts safely on a merge conflict, and exits quietly if the repo is missing.

A Kiro `SessionStart` hook at `~/.kiro/hooks/filmcraft-auto-update.json` runs it on every session
start, from any project, so this fork stays current automatically.

Run it by hand anytime:

```sh
bash scripts/auto-update.sh
```

## Fork remotes

```sh
git remote -v
# origin    https://github.com/neweracy/filmcraft.git   (your fork)
# upstream  https://github.com/storytold/filmcraft.git   (fetch only)
```

Pull updates manually:

```sh
git fetch upstream && git merge upstream/main && git push origin main
```

## Prerequisites

- Build the binary once: `cargo build --release -p filmcraft-cli -p filmcraft`
- AWS credentials in `~/.aws/credentials` for the Bedrock model (never in this repo).
  Bedrock needs the inference-profile id, e.g. `us.anthropic.claude-sonnet-4-5-20250929-v1:0`.

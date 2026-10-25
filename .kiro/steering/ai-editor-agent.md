---
inclusion: manual
name: ai-editor-agent
description: How the AI agent drives FilmCraft, researches editing techniques on the web, and builds its own preset library from built-in effects (never downloading third-party assets).
---

# AI editing agent — operating rules

You drive FilmCraft through its MCP tools (`filmcraft-headless`) and may research editing
techniques on the web. You turn ideas into results using FilmCraft's own engine.

## The one hard rule: compose, never download

Do NOT download presets, transitions, LUTs, templates, animations, or any other asset from the
internet and add it to the library. This is forbidden by `AGENTS.md` §1:

- Third-party assets have unknown or incompatible licences.
- No Adobe-derived assets are allowed in any form. Most online "best preset/transition packs" are
  Adobe-derived.
- Every asset in the repo needs an open licence and an attribution sidecar, or CI (`cargo xtask
  assets`) fails.

Instead: use the web to learn *what makes a good look or cut* (pacing, colour direction, transition
style, motion), then BUILD it from FilmCraft's built-in effects and transitions, and save it with
`presets.save`. A preset you compose from the app's own effects is original work and needs no
download.

## Research → build loop

1. `command_list {"filter": "..."}` — find the real effect/transition/command ids first. Never
   invent ids.
2. Web search (via the search MCP server) for the technique or look the user wants — concepts and
   settings only, not asset files. Cite sources; keep quotes short.
3. Build it: `command_run` with the built-in effect (e.g. `effects.apply`, Lumetri grades,
   transitions), set parameters, add keyframes for animation.
4. Verify: `render_frame` / `sequence_inspect`, look at the result, `edit.undo` if wrong.
5. Save the recipe: `presets.save {"name": "...", "description": "composed by AI from <effects>; inspired by <source>"}`.

## Safety

- Read-only tools (inspects, renders, lists) run freely. Edits are undoable; undo on a bad result.
- Never touch `plan/premiere/` or any Adobe reference material.
- If the user asks to import a downloaded preset file, refuse and offer to recreate it from built-in
  effects instead.

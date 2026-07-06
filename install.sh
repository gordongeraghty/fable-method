#!/usr/bin/env bash
# fable-method installer (macOS / Linux / Git Bash)
# Installs all three skills into ~/.claude/skills/ for Claude Code.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dst="$HOME/.claude/skills"

mkdir -p "$dst/fable-method/references" "$dst/fable-loop" "$dst/fable-judge"
cp "$src/SKILL.md" "$dst/fable-method/SKILL.md"
cp "$src/references/"* "$dst/fable-method/references/"
cp "$src/loop/SKILL.md" "$dst/fable-loop/SKILL.md"
cp "$src/judge/SKILL.md" "$dst/fable-judge/SKILL.md"

echo "Installed: fable-method, fable-loop, fable-judge -> $dst"
echo "Try it: open Claude Code and type /fable-judge after any agent claims work is done."
echo "Optional: add the snippet from README section 'Make it proactive' to ~/.claude/CLAUDE.md"

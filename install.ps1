# fable-method installer (Windows PowerShell)
# Installs all three skills into ~/.claude/skills/ for Claude Code.
$ErrorActionPreference = "Stop"
$src = $PSScriptRoot
$dst = Join-Path $HOME ".claude\skills"

New-Item -ItemType Directory -Force -Path (Join-Path $dst "fable-method") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $dst "fable-method\references") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $dst "fable-loop") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $dst "fable-judge") | Out-Null

Copy-Item (Join-Path $src "SKILL.md") (Join-Path $dst "fable-method\SKILL.md") -Force
Copy-Item (Join-Path $src "references\*") (Join-Path $dst "fable-method\references\") -Force
Copy-Item (Join-Path $src "loop\SKILL.md") (Join-Path $dst "fable-loop\SKILL.md") -Force
Copy-Item (Join-Path $src "judge\SKILL.md") (Join-Path $dst "fable-judge\SKILL.md") -Force

Write-Host "Installed: fable-method, fable-loop, fable-judge -> $dst"
Write-Host "Try it: open Claude Code and type /fable-judge after any agent claims work is done."
Write-Host "Optional: add the snippet from README section 'Make it proactive' to ~/.claude/CLAUDE.md"

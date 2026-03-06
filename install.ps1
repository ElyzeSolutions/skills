# AI Agent Skills Installation Script (Windows PowerShell)
# This script sets up the local environment for agents (Gemini CLI, Claude, Codex, etc.)

$skillsDir = Join-Path $HOME ".agents\skills"
$repoUrl = "https://github.com/ElyzeSolutions/skills.git"

Write-Host "🚀 Setting up AI Agent Skills..." -ForegroundColor Cyan

# Ensure the .agents/skills directory exists
$parentDir = Split-Path $skillsDir
if (!(Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force
}

if (Test-Path $skillsDir) {
    Write-Host "📂 Skills directory already exists at $skillsDir" -ForegroundColor Yellow
    Write-Host "🔄 Updating existing skills..." -ForegroundColor Cyan
    Set-Location $skillsDir
    git pull
} else {
    Write-Host "📥 Cloning skills repository to $skillsDir..." -ForegroundColor Cyan
    git clone $repoUrl $skillsDir
}

Write-Host "✅ Setup complete! AI agents will now automatically discover and use these skills." -ForegroundColor Green
Write-Host "💡 To use in a non-native project: New-Item -ItemType SymbolicLink -Path .claude -Target $skillsDir"

# Install or update the public skills repository in ~/.agents/skills.

$skillsDir = Join-Path $HOME ".agents\skills"
$repoUrl = "https://github.com/ElyzeSolutions/skills-new.git"

Write-Host "Setting up AI Agent Skills..." -ForegroundColor Cyan

$parentDir = Split-Path $skillsDir
if (!(Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force
}

if (Test-Path (Join-Path $skillsDir ".git")) {
    Write-Host "Skills directory already exists at $skillsDir" -ForegroundColor Yellow
    Write-Host "Updating existing skills checkout..." -ForegroundColor Cyan
    git -C $skillsDir remote get-url origin *> $null
    if ($LASTEXITCODE -eq 0) {
        git -C $skillsDir remote set-url origin $repoUrl
    } else {
        git -C $skillsDir remote add origin $repoUrl
    }
    git -C $skillsDir fetch origin
    git -C $skillsDir show-ref --verify --quiet refs/heads/main *> $null
    if ($LASTEXITCODE -eq 0) {
        git -C $skillsDir checkout main
    } else {
        git -C $skillsDir checkout -b main --track origin/main
    }
    git -C $skillsDir pull --ff-only origin main
} elseif (Test-Path $skillsDir) {
    Write-Host "Error: $skillsDir exists but is not a git repository." -ForegroundColor Red
    Write-Host "Move it aside or remove it, then run this installer again." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Cloning skills repository to $skillsDir..." -ForegroundColor Cyan
    git clone --depth 1 $repoUrl $skillsDir
}

Write-Host "Setup complete." -ForegroundColor Green
Write-Host "To expose a specific skill in a project, you can create a symlink into a local folder." -ForegroundColor Green
Write-Host 'Example: New-Item -ItemType SymbolicLink -Path .claude\zustand -Target "$HOME\.agents\skills\zustand-state-management"'

#!/usr/bin/env bash

# Install or update the public skills repository in ~/.agents/skills.

set -e

SKILLS_DIR="$HOME/.agents/skills"
REPO_URL="https://github.com/ElyzeSolutions/skills-new.git"

echo "Setting up AI Agent Skills..."

mkdir -p "$(dirname "$SKILLS_DIR")"

if [ -d "$SKILLS_DIR/.git" ]; then
    echo "Skills directory already exists at $SKILLS_DIR"
    echo "Updating existing skills checkout..."
    if git -C "$SKILLS_DIR" remote get-url origin >/dev/null 2>&1; then
        git -C "$SKILLS_DIR" remote set-url origin "$REPO_URL"
    else
        git -C "$SKILLS_DIR" remote add origin "$REPO_URL"
    fi
    git -C "$SKILLS_DIR" fetch origin
    if git -C "$SKILLS_DIR" show-ref --verify --quiet refs/heads/main; then
        git -C "$SKILLS_DIR" checkout main
    else
        git -C "$SKILLS_DIR" checkout -b main --track origin/main
    fi
    git -C "$SKILLS_DIR" pull --ff-only origin main
elif [ -d "$SKILLS_DIR" ]; then
    echo "Error: $SKILLS_DIR exists but is not a git repository."
    echo "Move it aside or remove it, then run this installer again."
    exit 1
else
    echo "Cloning skills repository to $SKILLS_DIR..."
    git clone --depth 1 "$REPO_URL" "$SKILLS_DIR"
fi

echo "Setup complete."
echo "To expose a specific skill in a project, you can symlink it into a local folder:"
echo "  mkdir -p .claude && ln -s \"$SKILLS_DIR/<skill-name>\" .claude/"

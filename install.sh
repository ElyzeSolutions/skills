#!/usr/bin/env bash

# AI Agent Skills Installation Script (macOS/Linux)
# This script sets up the local environment for agents (Gemini CLI, Claude, Codex, etc.)

set -e

SKILLS_DIR="$HOME/.agents/skills"
REPO_URL="https://github.com/ElyzeSolutions/skills.git"

echo "🚀 Setting up AI Agent Skills..."

# Ensure the .agents/skills directory exists
mkdir -p "$(dirname "$SKILLS_DIR")"

if [ -d "$SKILLS_DIR" ]; then
    echo "📂 Skills directory already exists at $SKILLS_DIR"
    echo "🔄 Updating existing skills..."
    cd "$SKILLS_DIR" && git pull
else
    echo "📥 Cloning skills repository to $SKILLS_DIR..."
    git clone "$REPO_URL" "$SKILLS_DIR"
fi

echo "✅ Setup complete! AI agents will now automatically discover and use these skills."
echo "💡 To use in a non-native project: mkdir -p .claude && ln -s $SKILLS_DIR/<skill-name> .claude/"

#!/bin/bash

LOG=$HOME/.var/log/automount/$(date '+%d-%m-%Y').log

# Navigate to the repository path, if provided as argument
if [ -n "$1" ]; then
  cd "$1" || { echo "[ automount ] Repository path '$1' not found." >> LOG; exit 1; }
fi

# Check if current directory is a git repository
if [ ! -d .git ]; then
  echo "[ automount ] $1 not a git repository." >> LOG
  exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  echo "Uncommitted changes found."

  # Add all changes
  git add -A

  # Create a timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Commit with timestamp message
  git commit -m "Auto-commit: $timestamp"

  # Push to the current branch
  branch=$(git symbolic-ref --short HEAD)
  git push origin "$branch"

  echo "Changes committed and pushed to branch '$branch'."
else
  echo "No uncommitted changes."
fi


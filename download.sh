#!/bin/bash

# Navigate to the repository path, if provided
if [ -n "$1" ]; then
  cd "$1" || { echo "Repository path '$1' not found."; exit 1; }
fi

# Check if current directory is a git repository
if [ ! -d .git ]; then
  echo "Not a git repository."
  exit 1
fi

# Fetch latest changes from origin
git fetch

# Get current branch name
branch=$(git symbolic-ref --short HEAD)

# Compare local and remote branches
behind=$(git rev-list --count HEAD..origin/$branch)

if [ "$behind" -gt 0 ]; then
  echo "Repository is behind origin/$branch by $behind commit(s). Pulling changes..."
  git pull
else
  echo "Repository is up to date with origin/$branch."
fi


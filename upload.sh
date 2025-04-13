#!/bin/bash

LOG=$HOME/.var/log/autogit/$(date '+%d-%m-%Y').log

# Navigate to the repository path, if provided as argument
if [ -n "$1" ]; then
  cd "$1" || { echo "[ autogit ] $1: Repository path '$1' not found." >> LOG; exit 1; }
fi

# Check if current directory is a git repository
if [ ! -d .git ]; then
  echo "[ autogit ] $1: $1 not a git repository." >> LOG
  exit 1
fi

# check remote information
git fetch
if [ $? -ne 0 ]; then
  echo "[ autogit ] $1: fetching remote repository information failed." >> LOG
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  echo "[ autogit ] $1: Uncommitted changes found."

  # Add all changes
  git add -A

  # Create a timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Commit with timestamp message
  git commit -m "Auto-commit: $timestamp"

  echo "[ autogit ] $1: Changes commited."
else
  echo "[ autogit ] $1: No uncommitted changes."
fi

git status -sb | grep "ahead" --quiet
if [[ $? -eq 0 ]]; then
  # Push to the current branch
  branch=$(git symbolic-ref --short HEAD)
  git push origin "$branch"

  echo "[ autogit ] $1: Changes pushed to branch '$branch'."
else
  echo "[ autogit ] $1: Nothing to push."
fi


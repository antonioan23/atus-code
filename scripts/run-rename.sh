#!/bin/bash
# Wrapper to run the rename script in a controlled way.
# - Touches only the right file types
# - Skips node_modules, .git, dist, build output, lockfile
# - Commits before and after each phase
set -e

cd "$(git rev-parse --show-toplevel)"

# Ensure we have a git checkpoint
git add -A 2>/dev/null || true
git -c user.email=atus@local -c user.name=atus commit -m "checkpoint: before atus-code rename" --allow-empty 2>/dev/null || true

# Find all the files we want to process
mapfile -t files < <(find . \
    -path ./node_modules -prune -o \
    -path ./.git -prune -o \
    -path ./dist -prune -o \
    -name 'package-lock.json' -prune -o \
    -type f \
    \( \
        -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.mjs' -o \
        -name '*.json' -o -name '*.md' -o -name '*.yml' -o -name '*.yaml' -o \
        -name '*.toml' -o -name '*.sh' -o -name '*.ps1' -o \
        -name 'Dockerfile' -o -name 'Makefile' -o \
        -name '.npmrc' -o -name '.nvmrc' -o -name '.gitignore' -o -name '.gitattributes' \
    \) -print)

echo "Files to process: ${#files[@]}"
echo "Sample (first 10):"
printf '  %s\n' "${files[@]:0:10}"

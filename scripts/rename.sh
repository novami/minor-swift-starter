#!/bin/zsh
# Turns the template into a concrete app.
# Usage: scripts/rename.sh <AppName> <bundle.id> <owner/repo>
# Example: scripts/rename.sh MinorDLNA cz.example.minordlna novami/MinorDLNA
set -euo pipefail

[[ $# -eq 3 ]] || { echo "Usage: $0 <AppName> <bundle.id> <owner/repo>"; exit 1; }
name=$1 bundle=$2 repo=$3
[[ $name =~ ^[A-Za-z][A-Za-z0-9]*$ ]] || { echo "AppName must be alphanumeric"; exit 1; }
[[ $repo == */* ]] || { echo "Repository must be owner/repo"; exit 1; }

cd "${0:A:h}/.."
old=MinorSwiftStarter

sed -i '' \
  -e "s|^APP_BUNDLE_IDENTIFIER = .*|APP_BUNDLE_IDENTIFIER = $bundle|" \
  -e "s|^UPDATE_REPOSITORY = .*|UPDATE_REPOSITORY = $repo|" \
  Config/App.xcconfig

# Text replace in tracked files (not in this script), then rename paths.
git ls-files | grep -v '^scripts/rename.sh$' | while read -r file; do
  if grep -Iq "$old" "$file" 2>/dev/null; then sed -i '' "s/$old/$name/g" "$file"; fi
done
# -depth lists children before their parents, so renames never invalidate later paths.
find . -depth -name "*$old*" -not -path './.git/*' | while read -r item; do
  git mv "$item" "${item:h}/${${item:t}//$old/$name}"
done

echo "Done. Next: set DEVELOPMENT_TEAM in Config/App.xcconfig, add an AppIcon, add GitHub secrets, commit."

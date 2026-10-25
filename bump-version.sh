#!/bin/sh
# Run this before committing. Bumps the version to match the commit
# count your commit is about to produce (current count + 1), so once
# committed, the version in these files is exactly correct.
# Usage: ./bump-version.sh
set -eu

MAJOR=0
COUNT="$(($(git rev-list --count HEAD) + 1))"
VERSION="$MAJOR.$COUNT"

sed -i "s/^version = .*/version = \"$VERSION\"/" pip/pyproject.toml
sed -i "s/^Version: .*/Version: $VERSION/" debian/control

echo "Bumped to $VERSION"
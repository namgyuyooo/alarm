#!/bin/bash

# Script to bump version numbers across all targets
# Usage: ./bump_version.sh [major|minor|patch]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 [major|minor|patch]"
    exit 1
fi

BUMP_TYPE=$1
CURRENT_VERSION=$(grep "MARKETING_VERSION" Config/Prod.xcconfig | cut -d' ' -f3)
echo "Current version: $CURRENT_VERSION"

# Parse version
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Bump version
case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Invalid bump type: $BUMP_TYPE"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# Update all xcconfig files
for config in Config/*.xcconfig; do
    sed -i '' "s/MARKETING_VERSION = .*/MARKETING_VERSION = $NEW_VERSION/" "$config"
    echo "Updated $config"
done

# Update Info.plist files (if they exist)
find . -name "Info.plist" -exec sed -i '' "s/CFBundleShortVersionString.*<string>.*<\/string>/CFBundleShortVersionString<\/key><string>$NEW_VERSION<\/string>/" {} \;

echo "Version bumped to $NEW_VERSION"
echo "Don't forget to:"
echo "1. Update CHANGELOG.md"
echo "2. Commit changes"
echo "3. Create git tag: git tag v$NEW_VERSION"
echo "4. Push tag: git push origin v$NEW_VERSION"
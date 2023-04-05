#!/bin/bash

# Get the source branch name from the environment variable
source_branch=$SOURCE_BRANCH

# Get the pull request description from the environment variable
pr_description=$PR_DESCRIPTION

# Get the latest tag
latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1))

# Get the major, minor, and patch numbers
major=$(echo $latest_tag | cut -d. -f1)
minor=$(echo $latest_tag | cut -d. -f2)
patch=$(echo $latest_tag | cut -d. -f3)

# Bump the version based on the source branch name
if [[ $source_branch == *"feature"* ]]; then
    minor=$((minor + 1))
    patch=0
elif [[ $source_branch == *"hotfix"* ]]; then
    patch=$((patch + 1))
fi

# Create a new tag
new_tag="$major.$minor.$patch"

# Append the new tag and pull request description to the CHANGELOG file
echo -e "## $new_tag\n\n$pr_description\n\n" >> CHANGELOG.md

# Commit the updated CHANGELOG file and create a new tag
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add CHANGELOG.md
git commit -m "chore: update CHANGELOG for version $new_tag"
git tag "$new_tag"

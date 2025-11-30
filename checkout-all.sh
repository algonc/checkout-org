#!/usr/bin/env bash
# Copyright (c) 2025 André Gonçalves
set -e

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <github-org-url> <target-path> [--all-branches]"
    echo "Example: $0 https://github.com/my-org /home/user/git/my-org"
    exit 1
fi

ORG_URL="$1"
TARGET_DIR="$2"
FLAG="$3"

# Behavior flag
ONLY_TRUNK=true
if [[ "$FLAG" == "--all-branches" ]]; then
    ONLY_TRUNK=false
fi

# Define trunk-like branches
TRUNK_BRANCHES=("main" "master" "dev" "develop" "development")

# Extract the org name from the URL
ORG_NAME=$(basename "$ORG_URL")

# Ensure gh CLI is installed
if ! command -v gh >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is required but not installed."
    echo "Install it: https://cli.github.com/"
    exit 1
fi

echo "Fetching repositories for GitHub org: $ORG_NAME"

# Create the base directory if needed
mkdir -p "$TARGET_DIR"

# Fetch the list of repos via GitHub CLI
REPOS=$(gh repo list "$ORG_NAME" --limit 500 --json name --jq '.[].name')

cd "$TARGET_DIR"

for REPO in $REPOS; do
    echo "----------------------------------------------"
    echo "Processing repository: $REPO"

    if [ -d "$REPO" ]; then
        echo "Repo exists. Updating…"
        cd "$REPO"

        git fetch --all --prune

        # ------------------------------------------
        # Trunk-only branches mode
        # ------------------------------------------
        if [ "$ONLY_TRUNK" = true ]; then
            echo "Updating only trunk branches…"
            REMOTE_BRANCHES=$(git branch -r --format="%(refname:short)")

            for TRUNK in "${TRUNK_BRANCHES[@]}"; do
                REMOTE_BRANCH="origin/$TRUNK"

                if echo "$REMOTE_BRANCHES" | grep -q "^$REMOTE_BRANCH$"; then
                    echo "Updating trunk branch: $TRUNK"
					
					# Always discard local changes before switching
					git reset --hard

                    if ! git rev-parse --verify "$TRUNK" >/dev/null 2>&1; then
                        git checkout -b "$TRUNK" "$REMOTE_BRANCH"
                    else
                        git checkout "$TRUNK"
                        git reset --hard "$REMOTE_BRANCH"
                    fi
                fi
            done

        # ------------------------------------------
        # ALL branches mode
        # ------------------------------------------
        else
            echo "Updating ALL branches…"

            for BRANCH in $(git branch -r --format="%(refname:short)" | grep -vE "^origin$"); do
                REMOTE_BRANCH="$BRANCH"
                LOCAL_BRANCH="${BRANCH#origin/}"

                echo "Updating branch: $LOCAL_BRANCH"
				
				# Always discard local changes before switching
				git reset --hard

                if ! git rev-parse --verify "$LOCAL_BRANCH" >/dev/null 2>&1; then
                    git checkout -b "$LOCAL_BRANCH" "$REMOTE_BRANCH"
                else
                    git checkout "$LOCAL_BRANCH"
                    git reset --hard "$REMOTE_BRANCH"
                fi
            done
        fi

        cd ..
    else
        echo "Cloning new repository…"
        gh repo clone "$ORG_NAME/$REPO" "$REPO"

        cd "$REPO"

        git fetch --all

        cd ..
    fi
done

echo "----------------------------------------------"
echo "Done! All repositories processed."
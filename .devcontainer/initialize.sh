#!/usr/bin/env bash

echo 'running initialization command'

if ! command -v gh &> /dev/null; then
    echo 'Error: gh CLI is not installed. Please install it in your WSL instance from https://cli.github.com/' >&2
    exit 1
fi
if gh auth status --json hosts --jq '.hosts["github.com"][0].scopes' 2>/dev/null | grep -q 'read:packages'; then 
    echo 'gh auth already has read:packages scope'
else 
    gh auth login --web --scopes read:packages
fi

echo "Authenticating to ghcr.io with gh CLI credentials..."
GH_TOKEN=$(gh auth token)
GITHUB_USERNAME=$(gh api user --jq '.login')

echo "$GH_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin

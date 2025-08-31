#!/bin/bash
set -euo pipefail

# Install dependencies
command -v jq >/dev/null 2>&1 || { sudo apt-get update -y && sudo apt-get install -y jq; }

TAG=""

# Try to get tag from release event
if [ "${GITHUB_EVENT_NAME:-}" = 'release' ]; then 
    TAG="${RELEASE_TAG_NAME:-}"
    echo "Got tag from release event: $TAG"
fi

# Try to get tag from repository_dispatch event (CLIENT_PAYLOAD)
if [ -z "$TAG" ] && [ "${GITHUB_EVENT_NAME:-}" = 'repository_dispatch' ]; then
    if [ -n "${CLIENT_PAYLOAD:-}" ] && [ "$CLIENT_PAYLOAD" != "null" ]; then
        TAG=$(echo "$CLIENT_PAYLOAD" | jq -r '.tag_name // empty' || true)
        if [ -n "$TAG" ] && [ "$TAG" != "null" ]; then
            echo "Got tag from repository_dispatch payload: $TAG"
        fi
    fi
fi

# Fallback to latest release
if [ -z "$TAG" ]; then
    echo "Query latest release via API..." >&2
    TAG=$(curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H 'Accept: application/vnd.github+json' \
        "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest" | jq -r .tag_name || true)
    [ "$TAG" = "null" ] && TAG=""
fi

# Fallback to tags list
if [ -z "$TAG" ]; then
    echo "No releases; fallback to tags list..." >&2
    TAG=$(curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H 'Accept: application/vnd.github+json' \
        "https://api.github.com/repos/$GITHUB_REPOSITORY/tags?per_page=100" \
        | jq -r '.[].name' | grep -E '^[vV]?[0-9]' | sed 's/^v//' | sort -V | tail -n1)
    [ -n "$TAG" ] && TAG="v$TAG"
fi

if [ -z "$TAG" ]; then 
    echo "ERROR: Unable to determine tag automatically" >&2
    exit 1
fi

PKGVER=${TAG#v}
echo "Resolved tag=$TAG pkgver=$PKGVER"

# Output to GitHub Actions
echo "tag=$TAG" >> "$GITHUB_OUTPUT"
echo "pkgver=$PKGVER" >> "$GITHUB_OUTPUT"

#!/bin/bash
set -euo pipefail

# Install dependencies
command -v jq >/dev/null 2>&1 || { sudo apt-get update -y && sudo apt-get install -y jq; }

TAG=""

normalize_tag() {
    local raw_tag="$1"

    if [ -z "$raw_tag" ] || [ "$raw_tag" = "null" ]; then
        return 0
    fi

    if [[ "$raw_tag" =~ ^[0-9] ]]; then
        printf 'v%s\n' "$raw_tag"
    else
        printf '%s\n' "$raw_tag"
    fi
}

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

# Try to get tag from workflow_dispatch input
if [ -z "$TAG" ] && [ "${GITHUB_EVENT_NAME:-}" = 'workflow_dispatch' ]; then
    TAG=$(normalize_tag "${MANUAL_TAG_NAME:-}")
    if [ -n "$TAG" ]; then
        echo "Got tag from workflow_dispatch input: $TAG"
    fi
fi

if [ -z "$TAG" ]; then 
    echo "ERROR: Unable to determine tag." >&2
    echo "release events must provide RELEASE_TAG_NAME, repository_dispatch must provide client_payload.tag_name, and workflow_dispatch must provide MANUAL_TAG_NAME." >&2
    exit 1
fi

PKGVER=${TAG#v}
# Handle cases where tag might have multiple 'v' prefixes (e.g., vv1.520)
while [[ "$PKGVER" =~ ^v ]]; do
    PKGVER=${PKGVER#v}
done
echo "Resolved tag=$TAG pkgver=$PKGVER"

# Output to GitHub Actions
echo "tag=$TAG" >> "$GITHUB_OUTPUT"
echo "pkgver=$PKGVER" >> "$GITHUB_OUTPUT"

#!/bin/bash
set -euo pipefail

# 安装依赖
command -v jq >/dev/null 2>&1 || { sudo apt-get update -y && sudo apt-get install -y jq; }

TAG=""

# 尝试从release事件获取tag
if [ "${GITHUB_EVENT_NAME:-}" = 'release' ]; then 
    TAG="${RELEASE_TAG_NAME:-}"
    echo "Got tag from release event: $TAG"
fi

# 回退到最新release
if [ -z "$TAG" ]; then
    echo "Query latest release via API..." >&2
    TAG=$(curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H 'Accept: application/vnd.github+json' \
        "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest" | jq -r .tag_name || true)
    [ "$TAG" = "null" ] && TAG=""
fi

# 回退到tags列表
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

# 输出到GitHub Actions
echo "tag=$TAG" >> "$GITHUB_OUTPUT"
echo "pkgver=$PKGVER" >> "$GITHUB_OUTPUT"

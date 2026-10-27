#!/usr/bin/env bash
set -euo pipefail
priva_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
priva_flutter="${PRIVA_FLUTTER_ROOT:-/workspace/.tools/flutter}"
priva_pub="${PUB_CACHE:-/workspace/.cache/pub}"
docker run --rm --network none \
  -v "$priva_root:$priva_root" \
  -v "$priva_flutter:$priva_flutter" \
  -v "$priva_pub:$priva_pub" \
  -w "$priva_root/mobile" \
  -e CI=true -e DASH__SUPPRESS_ANALYTICS=true -e "PUB_CACHE=$priva_pub" \
  ubuntu@sha256:24737cef17f4e22b1977df7d9a05e77c4e28b7da5b8911f8d8ccda136bf3573c \
  "$priva_flutter/bin/cache/dart-sdk/bin/dart" analyze --fatal-infos

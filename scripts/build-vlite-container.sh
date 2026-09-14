#!/usr/bin/env bash

set -euo pipefail

readonly VERSION="3.1910.2"
readonly IMAGE="localhost/visionary-vlite:${VERSION}"
readonly JAR_RELATIVE_PATH="VLite-${VERSION}_Software__Release-Notes/VLite-${VERSION}_Software_&_Release-Notes/VLite_5K_${VERSION//./_}.jar"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
jar_path="${repo_root}/${JAR_RELATIVE_PATH}"

if ! command -v podman >/dev/null 2>&1; then
  echo "Error: install Podman before building the VLite image." >&2
  exit 1
fi

if [[ ! -f "${jar_path}" ]]; then
  echo "Error: VLite JAR not found at ${jar_path}." >&2
  echo "Run ./scripts/download-vlite.sh first." >&2
  exit 1
fi

podman build \
  --file "${repo_root}/Containerfile" \
  --tag "${IMAGE}" \
  --build-arg "VLITE_JAR=${JAR_RELATIVE_PATH}" \
  "${repo_root}"

echo "Built ${IMAGE}. Start it with ./scripts/run-vlite-container.sh."

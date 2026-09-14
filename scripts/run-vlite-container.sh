#!/usr/bin/env bash

set -euo pipefail

readonly VERSION="3.1910.2"
readonly IMAGE="localhost/visionary-vlite:${VERSION}"
readonly CONTAINER_NAME="visionary-vlite"
readonly DEFAULT_PORT="8080"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
data_dir="${VLITE_DATA_DIR:-${repo_root}/vlite-data}"
xauthority_path="${XAUTHORITY:-${HOME}/.Xauthority}"

if ! command -v podman >/dev/null 2>&1; then
  echo "Error: install Podman before running VLite." >&2
  exit 1
fi

if ! podman image exists "${IMAGE}"; then
  echo "Error: ${IMAGE} has not been built." >&2
  echo "Run ./scripts/build-vlite-container.sh first." >&2
  exit 1
fi

if [[ -z "${DISPLAY:-}" ]]; then
  echo "Error: DISPLAY is unset. Run this from an X11-compatible desktop session." >&2
  exit 1
fi

display_number="${DISPLAY#*:}"
display_number="${display_number%%.*}"

if [[ ! -S "/tmp/.X11-unix/X${display_number}" ]]; then
  echo "Error: no X11 socket was found for DISPLAY=${DISPLAY}." >&2
  exit 1
fi

if [[ ! -r "${xauthority_path}" ]]; then
  echo "Error: Xauthority file is not readable: ${xauthority_path}" >&2
  exit 1
fi

if command -v ss >/dev/null 2>&1 && ss -H -ltn "sport = :${DEFAULT_PORT}" | grep -q .; then
  echo "Error: port ${DEFAULT_PORT} is already in use." >&2
  echo "Stop the conflicting service, or change VLite's port in its settings before running it again." >&2
  exit 1
fi

mkdir -p "${data_dir}"
mkdir -p "${data_dir}/Presets"

if [[ ! -f "${data_dir}/Presets/port.txt" ]]; then
  printf '%s' "${DEFAULT_PORT}" > "${data_dir}/Presets/port.txt"
fi

if [[ ! -f "${data_dir}/Presets/password.txt" ]]; then
  printf '%s' "admin" > "${data_dir}/Presets/password.txt"
fi

exec podman run \
  --rm \
  --name "${CONTAINER_NAME}" \
  --network host \
  --userns keep-id \
  --user "$(id --user):$(id --group)" \
  --cap-drop all \
  --security-opt no-new-privileges \
  --env DISPLAY \
  --env HOME=/var/lib/vlite \
  --env XAUTHORITY=/tmp/.Xauthority \
  --volume "${data_dir}:/var/lib/vlite:rw" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --volume "${xauthority_path}:/tmp/.Xauthority:ro" \
  "${IMAGE}"

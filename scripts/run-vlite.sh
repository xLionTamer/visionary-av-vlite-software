#!/usr/bin/env bash

set -euo pipefail

readonly VERSION="3.1910.2"
readonly DEFAULT_PORT="8080"
readonly JAR_RELATIVE_PATH="VLite-${VERSION}_Software__Release-Notes/VLite-${VERSION}_Software_&_Release-Notes/VLite_5K_${VERSION//./_}.jar"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
jar_path="${repo_root}/${JAR_RELATIVE_PATH}"
data_dir="${VLITE_DATA_DIR:-${repo_root}/vlite-data}"

if ! command -v mise >/dev/null 2>&1; then
  echo "Error: install mise before running VLite." >&2
  exit 1
fi

if [[ ! -f "${jar_path}" ]]; then
  echo "Error: VLite JAR not found at ${jar_path}." >&2
  echo "Run ./scripts/download-vlite.sh first." >&2
  exit 1
fi

mkdir -p "${data_dir}/Presets"

if [[ ! -f "${data_dir}/Presets/port.txt" ]]; then
  printf '%s' "${DEFAULT_PORT}" > "${data_dir}/Presets/port.txt"
fi

configured_port="$(<"${data_dir}/Presets/port.txt")"

if [[ ! "${configured_port}" =~ ^[0-9]+$ ]] ||
  (( ${#configured_port} > 5 )) ||
  (( 10#${configured_port} < 1 || 10#${configured_port} > 65535 )); then
  echo "Error: invalid port '${configured_port}' in ${data_dir}/Presets/port.txt." >&2
  exit 1
fi

if command -v ss >/dev/null 2>&1 && ss -H -ltn "sport = :${configured_port}" | grep -q .; then
  echo "Error: port ${configured_port} is already in use." >&2
  echo "Stop the conflicting service, or change VLite's port in its settings before running it again." >&2
  exit 1
fi

if [[ ! -f "${data_dir}/Presets/password.txt" ]]; then
  printf '%s' "admin" > "${data_dir}/Presets/password.txt"
fi

java_path="$(mise -C "${repo_root}" which java)"

cd "${data_dir}"
exec "${java_path}" -jar "${jar_path}"

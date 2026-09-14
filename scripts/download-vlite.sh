#!/usr/bin/env bash

set -euo pipefail

readonly VERSION="3.1910.2"
readonly ARCHIVE="VLite-${VERSION}_Software__Release-Notes.zip"
readonly URL="https://visionary-av.com/wp-content/uploads/2026/08/${ARCHIVE}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
archive_path="${repo_root}/${ARCHIVE}"
extract_dir="${repo_root}/${ARCHIVE%.zip}"
temp_archive="${archive_path}.tmp"
temp_extract_dir="${extract_dir}.tmp"

download() {
  if command -v curl >/dev/null 2>&1; then
    curl --fail --location --retry 3 --output "${temp_archive}" "${URL}"
  elif command -v wget >/dev/null 2>&1; then
    wget --output-document="${temp_archive}" "${URL}"
  else
    echo "Error: install curl or wget to download VLite." >&2
    exit 1
  fi
}

if ! command -v unzip >/dev/null 2>&1; then
  echo "Error: install unzip to extract VLite." >&2
  exit 1
fi

trap 'rm -f "${temp_archive}"; rm -rf "${temp_extract_dir}"' EXIT

echo "Downloading VLite ${VERSION}..."
download

mkdir "${temp_extract_dir}"
echo "Extracting to ${extract_dir}..."
unzip -q "${temp_archive}" -d "${temp_extract_dir}"

rm -rf "${extract_dir}"
mv "${temp_extract_dir}" "${extract_dir}"
mv "${temp_archive}" "${archive_path}"

echo "VLite ${VERSION} is available in ${extract_dir}."

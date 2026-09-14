# Visionary AV Vlite

This repository hold files for interacting with the Visionary AV Vlite software.

## Download the VLite software

On Linux, download and extract the VLite 3.1910.2 release with:

```sh
./scripts/download-vlite.sh
```

The script requires `curl` (or `wget`) and `unzip`. It stores the release archive
and extracted files at the repository root; both are ignored by Git. Re-run it to
replace the extracted release with a fresh copy.

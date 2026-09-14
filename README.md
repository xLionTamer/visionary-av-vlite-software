# Visionary AV Vlite

This repository holds files for interacting with the Visionary AV VLite software.

## Download the VLite software

On Linux, download and extract the VLite 3.1910.2 release with:

```sh
./scripts/download-vlite.sh
```

The script requires `curl` (or `wget`) and `unzip`. It stores the release archive
and extracted files at the repository root; both are ignored by Git. Re-run it to
replace the extracted release with a fresh copy.

## Run VLite with mise

VLite runs with the project-managed Temurin Java 8 installation supplied by
[mise](https://mise.jdx.dev/). Install the locked tool and launch VLite with:

```sh
mise trust
mise install --locked
./scripts/run-vlite.sh
```

The application runs directly on the host, so it can use the physical network
interfaces and multicast discovery without container networking. VLite's web
interface is normally available in Chrome at [http://127.0.0.1:8080](http://127.0.0.1:8080).

Persistent VLite state, including presets and the selected network interface, is
stored in `vlite-data/` and is ignored by Git. The helper exits if VLite's
configured port is already in use; choose a free port in VLite's settings before
its next launch if you need to change it. On the first launch it creates the
VLite defaults: port `8080` and web-interface password `admin`.

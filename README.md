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

## Run VLite with Podman

VLite requires Java 8, but it can run in a rootless Podman container so no Java
runtime is installed on the host. The container displays the Swing application
through the host X11 display (including XWayland on a Wayland desktop), while
Chrome continues to run on the host.

Build the local image after downloading the software:

```sh
./scripts/build-vlite-container.sh
```

Start VLite with:

```sh
./scripts/run-vlite-container.sh
```

The run helper requires `podman`, an active X11-compatible desktop session, and
an Xauthority cookie. It uses host networking because VLite discovers endpoints
with multicast and must enumerate the physical network interfaces. VLite's web
interface is normally available in Chrome at [http://127.0.0.1:8080](http://127.0.0.1:8080).

Persistent VLite state, including presets and the selected network interface, is
stored in `vlite-data/` and is ignored by Git. The helper exits if port 8080 is
already in use; choose a free port in VLite's settings before its next launch if
you need to change it. On the first launch it creates the VLite defaults: port
`8080` and web-interface password `admin`.

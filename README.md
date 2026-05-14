# token-buy

Flutter starter project for `windows`, `ios`, `macos`, and `web`.

## Project Baseline

- Directory name: `token-buy`
- Flutter package name: `token_buy`
- Enabled platforms: `windows`, `ios`, `macos`, and `web`

## Asset Layout

- Runtime assets root: `assets/`
- Image assets directory: `assets/images/`
- Video assets directory: `assets/videos/`
- Path strategy: keep project assets under the workspace with relative paths; do not introduce machine-specific absolute paths

## Getting Started

```bash
cd token-buy
flutter run
```

## LAN Preview

Run the app as a local web server and open it from a phone on the same LAN:

```bash
./scripts/start_lan_preview.sh
```

The macOS launcher auto-selects the next available port when `8080` is busy and prints the final `Phone URL`.

On Windows you can use:

```bat
scripts\start_lan_preview.bat
```

The Windows script prints the exact `Phone URL` to open on the phone browser.
If `8080` is already in use, it automatically switches to the next available port and prints the final URL.

Or directly with Flutter:

```bash
fvm flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

## Windows Release Zip

Build a Windows-friendly LAN release zip that does not require Flutter on the target machine:

```bash
./scripts/package_windows_web_release.sh
```

The packaged zip contains a static web build plus `start_server.bat`, which starts a PowerShell LAN server and prints the `Phone URL` for same-network phones.
If the preferred port is occupied, the packaged server also auto-selects the next available port and reports it.
It also stops the previous release-folder server before starting a fresh one, so repeated launches do not accumulate stale processes.

## GitHub Pages

This project is configured for GitHub Pages automatic deployment from the `main` branch through GitHub Actions.

- Repository: `2297832974/2297832974.github.io`
- Live URL: `https://2297832974.github.io/`

Before pushing a web-facing change, run:

```bash
fvm flutter analyze
fvm flutter test
fvm flutter build web --release
```

## Documentation

- [TODO](docs/TODO.md)
- [LAN preview](docs/lan-preview.md)
- [GitHub Pages deployment](docs/github-pages.md)
- [Video UI restoration plan](docs/video-ui-restoration-plan.md)
- [Video UI gap audit](docs/video-ui-gap-audit.md)
- [Project baseline](docs/project-baseline.md)
- [Assets guide](docs/assets.md)

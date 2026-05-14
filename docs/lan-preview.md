# LAN Preview

## Goal

Run the app as a LAN-accessible web server on a computer, then open it from a phone browser on the same network.

## Supported Flow

- The project now includes the Flutter `web` platform.
- You can run the app with Flutter's `web-server` device and bind it to `0.0.0.0`.
- Any phone on the same LAN can open the app through the computer's LAN IP and chosen port.

## Start On macOS

```bash
./scripts/start_lan_preview.sh
```

The macOS script now auto-detects a nearby free port if `8080` is already occupied and prints the final `Phone URL` before Flutter starts.

Optional custom port:

```bash
PORT=9000 ./scripts/start_lan_preview.sh
```

## Start On Windows

```bat
scripts\start_lan_preview.bat
```

The script now prints the phone-ready LAN URL before Flutter starts, for example:

```text
Phone URL: http://192.168.0.106:8080
```

If `8080` is already occupied, the script automatically switches to the next available port and prints the final URL it chose.

Optional custom host and port:

```bat
scripts\start_lan_preview.bat 0.0.0.0 9000
```

## Direct Command

```bash
fvm flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

## Phone Access

1. Start the server on the computer.
2. Copy the `Phone URL` printed by the launcher script.
3. Open that URL on the phone browser.

## Notes

- The computer and phone must be on the same LAN.
- If the page cannot be reached, allow the chosen port through the computer firewall.
- This flow is for preview/demo use and avoids iOS packaging/signing blockers.
- When you are ready for App Store or direct iOS install packaging, the native iOS signing environment still needs to be completed separately.

## Windows Release Zip

For a Flutter-free Windows handoff, use:

```bash
./scripts/package_windows_web_release.sh
```

This creates:

- `dist/token-buy-windows-lan-release/`
- `dist/token-buy-windows-lan-release.zip`

The zip includes:

- prebuilt `web/` assets
- `start_server.bat`
- `serve_web.ps1`
- `README.txt`

The bundled PowerShell server uses a raw TCP listener instead of `HttpListener`, which avoids the common Windows URL reservation/admin issue on `http://+:port`.

After extracting on Windows, users only need to run:

```bat
start_server.bat
```

The terminal will print a phone-ready LAN URL such as:

```text
Phone URL: http://192.168.0.106:8080
```

If the preferred port is busy, the packaged server prints a fallback message such as `Preferred port 8080 was busy. Switched to 8081.` and then shows the final `Phone URL`.

The packaged Windows server is restart-oriented per release folder:

- each launch first checks `server_state.json`
- if the previous release-folder server is still running, it is stopped first
- stale state is cleared automatically
- a fresh server process is then started and the new `Phone URL` is printed

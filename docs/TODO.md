# Token Buy TODO

## Current Focus

- Gradually restore the video UI effect from `assets/videos/token.mp4` using extracted frames as ordered visual references.

## In Progress

- [x] Create `assets/` structure for images and videos
- [x] Extract `token.mp4` into curated keyframes
- [x] Document asset layout and keyframe strategy
- [x] Replace the default counter app with a video UI restoration baseline
- [x] Define page structure, component boundaries, and build order
- [x] Correct the target from a workflow analysis page to a video UI restoration baseline
- [x] Remove the frame viewer UI and make the app open directly into the restored interface
- [x] Extract dense `1fps` reference frames from `token.mp4`
- [x] Audit current implementation against the denser reference set
- [x] Add success toast and modal-hidden states
- [x] Add multiple users and search result variants
- [x] Remove the lower-right music playback card from the restored app surface
- [x] Make the Send Robux close button hide the dialog
- [x] Remove the top creator bubble and video caption overlay from the restored app surface
- [x] Remove the top phone status and recording strip from the restored app surface
- [x] Replace the lower-left generic Material icon with a custom frame-matched line icon
- [x] Replace the Robux currency icon with a custom double-hexagon mark closer to the reference frames
- [x] Make the restored app open on the Robux home page and show the Send Robux dialog only after tapping the top-right `Send` button
- [x] Change the Send Robux entry state from a floating card to a bottom-raised large sheet closer to the reference capture
- [x] Add a bottom-up entrance animation to the Send Robux sheet so it no longer appears instantly
- [x] Add built-in friends, blank-avatar non-friend search results, and right-click friend management
- [x] Add an editable Robux balance that can be right-click edited and decrements after each successful send
- [x] Disable `Send` when the shared Robux balance is insufficient and show the shortfall
- [x] Rework the Robux home background toward the referenced Roblox Robux page header, balance strip, hero, and package list
- [x] Rebuild the selected-user amount sheet to match the reference layout more closely
- [x] Remove avatar rendering from the Send Robux flow, friends list, and search results
- [x] Rework the Robux home hero and package pricing column while keeping the preferred light base theme
- [x] Add a LAN preview path through Flutter `web-server` so the app can be opened from phones on the same local network
- [x] Add a Windows release zip flow with a built-in PowerShell LAN server so the handoff no longer depends on Flutter being installed
- [x] Add GitHub Pages deployment so the current Flutter web build can be shared without a local server
- [x] Replace right-click-only editing with adaptive long-press actions for web/mobile while keeping desktop-app right-click support

## Next

- [ ] Refine the Send Robux modal size, typography, and state timing against dense frames
- [ ] Refine the Robux home page spacing, icons, avatar, and package rows against the latest screenshot and dense frames
- [ ] Add tests for restored state transitions and key visible video regions
- [ ] Add screenshot-based visual verification after the restoration stabilizes
- [ ] Verify the first public GitHub Pages publish against the current mobile web layout

## Notes

- The current UI is a baseline restoration scaffold, not the final polished product.
- The first milestone is visible composition parity with the video, then gradual frame-by-frame refinement.
- Current audit says the implementation is still rough and misses multiple visible states from the dense frame set.
- Current typography: the app uses the bundled `Montserrat` font family as a Gotham-like stand-in to reduce the font-shape gap vs the reference capture.
- Windows sync: the repo is shared to the Windows build machine via Syncthing folder id `token-buy-src` and uses `.stignore` to exclude generated artifacts and `.git/`.
- Current entry behavior: the app starts on the Robux home page; the custom Send Robux dialog is opened from the top-right `Send` button and closes back to the home page.
- Current search dialog layout: the friends/search entry now uses a centered compact card with a fixed scrollable results region instead of the earlier full-height sheet.
- Current friend behavior: the search sheet starts with built-in friends, unknown usernames render as blank-avatar non-friend results, and the friends area supports right-click add/edit/delete flows.
- Current search fallback: normal typing only matches saved friends, while pressing `Enter` generates a cached random result list of `1-20` items with the first item forced to be the current match.
- Current amount-stage behavior: after selecting a user, the sheet now switches to a centered avatar/name layout with a dedicated amount field, quick Robux chips, and a full-width primary `Next` button.
- Current quick amount chips: the amount stage now offers `1000 / 2000 / 5000 / 10000` presets with larger chip typography for easier tapping during demos.
- Current avatar rule: the Send Robux flow, friend rows, and search results now render without avatars.
- Current balance behavior: the home/header Robux balance is shared state, supports right-click editing, and drops by the sent amount after each successful send.
- Current guardrail: the confirm step disables `Send` when balance is insufficient and shows how much additional Robux is needed.
- Current home-page alignment: the home screen is back on the preferred light base theme, with the `3,625 / £34.99` package row highlighted by default and no extra lower-left package tag.
- Current hero heading: the `Enjoy up to 25% more Robux` title now uses platform-tuned sizing so Windows uses a slightly reduced 72px headline to preserve the intended two-line wrap, while macOS stays at a more natural 60px size.
- Current LAN preview: the project now includes `web` support plus `scripts/start_lan_preview.sh` and `scripts/start_lan_preview.bat`, so a computer can host the UI for phones on the same LAN via Flutter's `web-server` device.
- Current Windows startup UX: `scripts/start_lan_preview.bat` now auto-detects a LAN IPv4 address and prints a phone-ready `http://<ip>:<port>` URL before launching the Flutter web server.
- Current Windows handoff: `scripts/package_windows_web_release.sh` assembles `dist/token-buy-windows-lan-release.zip`, which bundles the built web app with a PowerShell static server and a double-click `start_server.bat` entrypoint.
- Current Windows server robustness: the packaged `serve_web.ps1` now uses a raw TCP listener instead of `HttpListener`, reducing the chance of admin-only URL reservation failures on end-user machines.
- Current port strategy: both Windows launch paths now prefer `8080` but automatically fall forward to the next available port when it is occupied, and they print the final phone-ready URL after the fallback.
- Current process strategy: the packaged Windows release launcher now keeps a `server_state.json` record, stops the previous release-folder server on each launch, clears stale state automatically, and then starts a fresh process.
- Current Win port probing: the packaged server now tests candidate ports with the same `IPAddress.Any` binding it later uses for the real listener, avoiding false positives when another process already occupies `0.0.0.0:8080`.
- Current mobile web layout: narrow viewports now bypass the centered `FittedBox` shell and let the restored app surface expand to the full safe viewport, removing the black side bars on phones.
- Current macOS launcher: `scripts/start_lan_preview.sh` now probes `0.0.0.0` ports directly, auto-falls forward when `8080` is busy, and prints a phone-ready LAN URL before launching Flutter's web server.
- Current narrow-screen responsiveness: the mobile web path now also scales down header spacing, hero typography, balance strip, and package card widths so the filled viewport no longer overflows after the black side bars were removed.
- Current mobile dialog spacing: narrow screens now add dedicated horizontal dialog inset padding so the Send Robux sheets no longer sit too tightly against the viewport edges.
- Current public deployment: the repository now includes `.github/workflows/deploy-pages.yml`, so pushes to `main` build Flutter web and publish the result to `https://2297832974.github.io/`.
- Current edit interaction: web now uses long-press for balance and friend management, while desktop app builds keep the same flows plus right-click as a shortcut.
- Current mobile toast behavior: the success toast now uses a compact-device width constraint instead of desktop-only side insets, so phones keep the full `You sent ... Robux` copy visible instead of collapsing to the check icon.
- Current keyboard avoidance: the Send Robux overlays now reduce their top offset against `MediaQuery.viewInsets.bottom`, so amount and search dialogs shift upward when a mobile keyboard opens instead of being covered.
- Current dialog placement: both Send Robux dialog variants now start vertically centered on narrow/mobile viewports and lift upward only when the keyboard would otherwise cover them.
- Current theme settings: the top-right Settings menu now lets users toggle between light and dark themes (persisted via `shared_preferences`), and the Robux home + send flows reuse a shared palette so both themes render correctly.
- Current success toast placement: the send-success toast is now centered vertically (instead of near the top), matching the latest reference.

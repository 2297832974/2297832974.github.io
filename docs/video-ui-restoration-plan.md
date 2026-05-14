# Video UI Restoration Plan

## Current Truth

- Goal: gradually restore the UI effect shown in `assets/videos/token.mp4`.
- Current reference set: `assets/images/token-frames/`.
- Current baseline frame count: `12`.
- Dense reference set: `assets/images/token-frames-dense/`.
- Dense frame count: `34`.
- The extracted images are ordered video references, not the final feature set.
- The first implementation target is the visible app interface: a Roblox Robux page imitation and Send Robux modal states.
- Reference frames are development material only; they must not appear as frame controls in the user-facing app.
- Current entry behavior: the app opens on the Robux home page. The Send Robux dialog is not visible until the user taps the top-right `Send` button.

## Restoration Strategy

- Use the 12 extracted frames as the first alignment anchors.
- Use the 34 dense frames to discover missed states and repeated cycles.
- Keep the app code structured around visual regions from the video.
- Add more frames later when a region needs finer timing, spacing, or state detail.
- Restore visible effects incrementally while keeping the app itself usable.

## Visual Regions

- Phone shell: vertical canvas, status bar, recording pill, bottom comment icon, and home indicator.
- Excluded overlay: the top creator bubble and video caption text are not part of the app feature and should not be restored.
- Excluded overlay: the lower-right music playback card from the source video is not part of the app feature and should not be restored.
- Background page: imitation of `https://www.roblox.com/upgrades/robux?ctx=navpopover`, including the Roblox-style top navigation, Robux balance strip, top-right `Send` action, product hero, and package rows.
- Send dialog: modal shell, search input, search results, selected account, amount input, confirmation buttons.
- Component boundary: the Robux home page background lives in `lib/features/token_flow/presentation/widgets/robux_home_page.dart`; the token flow page owns modal state and dialog flow.

## Current Build Order

1. Restore the overall vertical video composition.
2. Restore the Robux background page enough to match the visible context.
3. Restore the Send Robux modal states using the current 12 frames.
4. Add frame-by-frame refinements for spacing, font weight, and overlays.
5. Extract more frames from `token.mp4` only when the current anchors are too coarse.

## Current Gap Audit

- Detailed audit: `docs/video-ui-gap-audit.md`
- Current judgment: the implementation is still a rough scaffold, but it now covers the home-first entry behavior, repeated-cycle basics, result variants, multiple users, success toast, and modal-hidden recovery.

## Scope Guardrails

- Treat the Roblox Robux page as the background-page target, while keeping the Send Robux modal as the custom app layer from the video.
- The custom modal must be entered through the Robux page `Send` button; it should not be pre-opened on first launch.
- Do not turn the app into a documentation, analysis workspace, or frame viewer.
- Do not assume the 12 current frames are final; they are only the first calibration set.

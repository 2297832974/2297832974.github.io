# Assets Guide

## Current Truth

- Runtime assets root: `assets/`
- Image assets root: `assets/images/`
- Video assets root: `assets/videos/`
- Token video source: `assets/videos/token.mp4`
- Token keyframe output: `assets/images/token-frames/`
- Dense token frame output: `assets/images/token-frames-dense/`

## Token Keyframes

The `token.mp4` video is split into ordered keyframes for gradual UI restoration instead of exporting dense time-based frames.

Current exported keyframes:

- `01-dialog-initial.jpg`
- `02-input-focus.jpg`
- `03-typing-start.jpg`
- `04-typing-mid.jpg`
- `05-typing-complete.jpg`
- `06-base-page.jpg`
- `07-search-results.jpg`
- `08-user-selected.jpg`
- `09-amount-default.jpg`
- `10-amount-editing.jpg`
- `11-amount-filled.jpg`
- `12-confirmation.jpg`

## Dense Reference Frames

The dense frame set is used when the curated `12` keyframes are too coarse for restoration decisions.

- Directory: `assets/images/token-frames-dense/`
- Current count: `34`
- Extraction cadence: `1` frame per second
- Naming pattern: `frame_01.jpg` through `frame_34.jpg`

## Selection Strategy

- Keep the frame count low enough for early restoration work.
- Preserve the visible UI state transitions needed to rebuild the video effect.
- Prefer representative state changes over evenly spaced timestamps.
- The current baseline uses `12` keyframes as the first calibration set; more frames can be extracted later when the restoration needs finer visual timing.
- Use the dense `1fps` set for gap audits and state discovery; keep the curated set for high-signal implementation anchors.

## Path Strategy

- Keep all source videos and generated images under the project `assets/` tree.
- Use relative project paths in code and docs; do not introduce machine-specific absolute paths.

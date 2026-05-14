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
- [x] Replace the lower-left generic Material icon with a custom frame-matched line icon
- [x] Make the restored app open on the Robux home page and show the Send Robux dialog only after tapping the top-right `Send` button
- [x] Rework the Robux home background toward the referenced Roblox Robux page header, balance strip, hero, and package list

## Next

- [ ] Refine the Send Robux modal size, typography, and state timing against dense frames
- [ ] Refine the Robux home page spacing, icons, avatar, and package rows against the latest screenshot and dense frames
- [ ] Add tests for restored state transitions and key visible video regions
- [ ] Add screenshot-based visual verification after the restoration stabilizes

## Notes

- The current UI is a baseline restoration scaffold, not the final polished product.
- The first milestone is visible composition parity with the video, then gradual frame-by-frame refinement.
- Current audit says the implementation is still rough and misses multiple visible states from the dense frame set.
- Current entry behavior: the app starts on the Robux home page; the custom Send Robux dialog is opened from the top-right `Send` button and closes back to the home page.

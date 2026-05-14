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
- Current friend behavior: the search sheet starts with built-in friends, unknown usernames render as blank-avatar non-friend results, and the friends area supports right-click add/edit/delete flows.
- Current search fallback: normal typing only matches saved friends, while pressing `Enter` injects the current input as the top temporary result when needed.
- Current amount-stage behavior: after selecting a user, the sheet now switches to a centered avatar/name layout with a dedicated amount field, quick Robux chips, and a full-width primary `Next` button.
- Current avatar rule: the Send Robux flow, friend rows, and search results now render without avatars.
- Current balance behavior: the home/header Robux balance is shared state, supports right-click editing, and drops by the sent amount after each successful send.
- Current guardrail: the confirm step disables `Send` when balance is insufficient and shows how much additional Robux is needed.

# Video UI Gap Audit

## Current Evidence

- Source video: `assets/videos/token.mp4`
- Dense reference frames: `assets/images/token-frames-dense/`
- Dense frame count: `34`
- Extraction cadence: `1` frame per second
- Curated anchor frames: `assets/images/token-frames/`
- Curated anchor count: `12`

## Dense Frame Findings

The source video is not a single static modal flow. It repeats the same visible interaction pattern with different users and intermediate states.

Observed states:

- Initial search dialog with empty username input.
- Typed username states before results appear.
- Search with no matching users.
- Search results with multiple rows.
- Search results with a smaller result set.
- User-selected amount dialog.
- Empty amount input.
- Partially typed amount input.
- Enabled `Next` button after an amount exists.
- Confirmation dialog with selected user and amount.
- Success toast near the top of the Robux page.
- Return to empty search dialog after a successful send.
- Background Robux page without the modal visible between some cycles.
- Home-first Robux page state before the Send Robux dialog opens.
- Multiple selected users, including `Sauveur2deCAPYBARAS`, `miriandogaru`, and `SonicBacon`.

## Current Implementation Gaps

- The app now models multiple selected users, but avatar detail is still approximate.
- The app now models success toast behavior, but timing and placement still need frame-level refinement.
- The app now models the modal-hidden Robux home state on initial launch and after Send.
- The top-right `Send` button now opens the Send Robux dialog instead of showing the dialog by default.
- The Send Robux close button now hides the dialog and leaves the background visible.
- Search behavior now supports no-result and alternate result-set variants, but it is still deterministic mock logic.
- Amount flow is too direct and does not represent the different partially typed amount frames well.
- User avatars are generic placeholders instead of matching the changing reference avatars.
- The Robux background page now includes a closer Roblox-style header, balance strip, hero, and yen package list, but spacing and icon detail still need frame-level refinement.
- The top recording/status area and bottom comment icon are only approximate.
- The lower-left comment icon now uses a custom line drawing closer to the dense video frames instead of a generic Material icon.
- The top creator bubble and video caption text are intentionally excluded from restoration.
- The lower-right music playback card is intentionally excluded from restoration.
- There is no internal comparison workflow for checking restored widgets against specific frame groups.

## Priority Fix Order

1. Refine the Send Robux modal dimensions and vertical positions against dense frames.
2. Refine the Robux home page spacing, header icons, avatar, and package rows.
3. Replace generic avatar placeholders with closer approximations.
4. Add a more accurate state timeline for amount input and post-send recovery.
5. Add screenshot-based verification after the app visually stabilizes.

## Current Judgment

The current implementation is still a rough scaffold, but it now covers the main repeated-cycle states: result variants, multiple users, success feedback, and modal-hidden recovery. The remaining gap is mostly visual fidelity and timing.

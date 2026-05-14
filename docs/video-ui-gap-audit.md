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
- The Send Robux entry state now uses a bottom-raised large sheet instead of the earlier floating card layout.
- The Send Robux entry state now animates upward from the bottom instead of appearing instantly.
- The friends/search entry now uses a compact centered card with a fixed results panel, which is closer to the latest reference than the earlier full-height popup.
- The Send Robux search state now starts with built-in friends, supports right-click add/edit/delete flows, and shows blank avatars for non-friend search results.
- Search now keeps normal typing scoped to saved friends, and on `Enter` generates a cached random `1-20` item result list whose first row is always the submitted match.
- The Robux balance is now editable by right-click and decrements after successful sends.
- The confirm step now blocks sending when the shared balance is too low and surfaces the Robux shortfall inline.
- The selected-user amount stage now uses a centered avatar/name composition, dedicated amount field, Robux quick chips, and a larger primary button closer to the reference frame.
- The Send Robux flow now omits avatar rendering in the friends list, search results, and selected-user states.
- The Robux home background now stays on the lighter in-app theme instead of the temporary dark official-page treatment.
- Typography now uses a bundled Gotham-like stand-in font (`Montserrat`), but sizes/weights/spacing still need frame-level tuning.
- The Robux currency icon now uses a custom double-hexagon mark instead of the generic system icon in both the top navigation and package areas.
- Search behavior now distinguishes between saved friends and non-friends, but it is still local mock data rather than a real platform friend source.
- Amount flow layout is now closer to the reference, but it still does not represent the different partially typed amount frames and avatar detail well.
- User avatar rendering is intentionally removed from the Send Robux flow for the current restoration target.
- The home page is still not fully 1:1 with the target look: top-header proportions, exact typeface metrics, and package-card vertical rhythm still need refinement.
- The Robux background page now includes a closer Roblox-style header, balance strip, hero, and yen package list, but spacing and icon detail still need frame-level refinement.
- The bottom comment icon is still only approximate.
- The lower-left comment icon now uses a custom line drawing closer to the dense video frames instead of a generic Material icon.
- The top creator bubble and video caption text are intentionally excluded from restoration.
- The top phone status and recording strip are intentionally excluded from restoration.
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

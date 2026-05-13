# Token Flow Plan

## Current Truth

- Source reference set: `assets/images/token-frames/`
- Current implementation baseline: a stage-driven Flutter skeleton with one workspace page
- Primary build target right now: restore the core token-buy flow, not every overlay detail from the original video

## Stage Map

### 1. Search Entry

- Reference frames: `01` to `05`
- User goal: open the dialog and type a username
- Core widgets:
  - Send dialog shell
  - Username input
  - Search helper text

### 2. User Selection

- Reference frames: `06` to `08`
- User goal: review matches and choose one account
- Core widgets:
  - Search result list
  - Result row with avatar, display name, and tap target
  - Selected user summary

### 3. Amount Input

- Reference frames: `09` to `11`
- User goal: pick a quick amount or type a custom amount
- Core widgets:
  - User summary header
  - Amount text field
  - Preset amount chips
  - Primary next action

### 4. Confirmation

- Reference frame: `12`
- User goal: confirm account and amount, then submit or exit
- Core widgets:
  - Confirmation summary
  - Large amount readout
  - Primary and secondary actions

## Component Boundaries

- App shell: global theme, page padding, and wide-screen workspace layout
- Flow state: current stage, selected user, typed query, amount
- Dialog presentation: reusable white modal card and shared field styles
- Search module: input, loading/empty/result states
- Amount module: chips, numeric entry, enabled button rules
- Confirmation module: summary content and action row

## Recommended Build Order

1. Stabilize the modal shell and global theme.
2. Implement search input and static search states.
3. Add result list and selected-user transition.
4. Build amount chips plus custom amount field behavior.
5. Finish confirmation state and action handling.
6. Replace mock data with real state management and service integration later.

## Scope Guardrails

- Do not chase every overlay element from the video in the first pass.
- Keep the first implementation focused on the central modal flow.
- Treat the original video as a visual reference, not as a requirement to reproduce every recording artifact.

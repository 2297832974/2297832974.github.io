# App Lock (Acceptance Guardrail)

## Goal

For acceptance/demo builds, we need a simple time-based guardrail:

- After the first launch on a device, the app becomes unusable after **2 hours**.
- The lock state is **persistent** (stored locally), so reopening the app after expiry stays locked.

## How It Works

- On first launch, we store `firstLaunchAt` in `SharedPreferences` under:
  - `app_lock:first_launch_at_ms`
- On every app start and app resume:
  - compute `expiresAt = firstLaunchAt + afterMinutes`
  - if `now > expiresAt` => show the lock screen (`Build Expired`) and block the UI.

Implementation entrypoint:

- `lib/core/app_lock/app_gate.dart`

## Configuration (Testing Only)

Defaults are chosen for acceptance:

- `APP_LOCK_ENABLE` default: `true`
- `APP_LOCK_AFTER_MINUTES` default: `120`
- `APP_LOCK_RESET_ON_START` default: `false`

Examples:

```bash
# Lock after 2 minutes (quick QA)
flutter run --dart-define=APP_LOCK_AFTER_MINUTES=2

# Disable the lock entirely (local development)
flutter run --dart-define=APP_LOCK_ENABLE=false

# Always reset the timer on startup (local development)
flutter run --dart-define=APP_LOCK_RESET_ON_START=true
```

## Resetting A Device

The stored timer is local to the device/app sandbox. To reset it without a special build:

- Uninstall the app (clears local storage), then install/run again.


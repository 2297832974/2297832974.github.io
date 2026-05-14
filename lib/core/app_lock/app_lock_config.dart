class AppLockConfig {
  // Defaults to enabled so the acceptance build is protected by default.
  static const bool enabled = bool.fromEnvironment(
    'APP_LOCK_ENABLE',
    defaultValue: true,
  );

  // Minutes after the first ever launch before the app becomes unusable.
  // Override for QA via: --dart-define=APP_LOCK_AFTER_MINUTES=2
  static const String _afterMinutesRaw = String.fromEnvironment(
    'APP_LOCK_AFTER_MINUTES',
    defaultValue: '120',
  );

  // For quick local testing: reset the stored "first launch time" on every
  // start. Keep this OFF for acceptance builds.
  static const bool resetOnStart = bool.fromEnvironment(
    'APP_LOCK_RESET_ON_START',
    defaultValue: false,
  );

  static int get afterMinutes {
    final parsed = int.tryParse(_afterMinutesRaw.trim());
    if (parsed == null || parsed <= 0) return 120;
    return parsed;
  }
}

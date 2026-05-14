import 'package:shared_preferences/shared_preferences.dart';

import 'app_lock_config.dart';

class AppLockStatus {
  final bool locked;
  final DateTime firstLaunchAt;
  final DateTime expiresAt;

  const AppLockStatus({
    required this.locked,
    required this.firstLaunchAt,
    required this.expiresAt,
  });
}

class AppLockService {
  static const _kFirstLaunchAtMsKey = 'app_lock:first_launch_at_ms';

  Future<AppLockStatus> getStatus() async {
    final prefs = await SharedPreferences.getInstance();

    if (AppLockConfig.resetOnStart) {
      await prefs.remove(_kFirstLaunchAtMsKey);
    }

    final now = DateTime.now();
    final firstLaunchAt = await _getOrSetFirstLaunchAt(prefs, now);
    final expiresAt = firstLaunchAt.add(
      Duration(minutes: AppLockConfig.afterMinutes),
    );

    final locked = AppLockConfig.enabled && now.isAfter(expiresAt);
    return AppLockStatus(
      locked: locked,
      firstLaunchAt: firstLaunchAt,
      expiresAt: expiresAt,
    );
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFirstLaunchAtMsKey);
  }

  Future<DateTime> _getOrSetFirstLaunchAt(
    SharedPreferences prefs,
    DateTime now,
  ) async {
    final existingMs = prefs.getInt(_kFirstLaunchAtMsKey);
    if (existingMs != null) {
      return DateTime.fromMillisecondsSinceEpoch(existingMs);
    }
    final ms = now.millisecondsSinceEpoch;
    await prefs.setInt(_kFirstLaunchAtMsKey, ms);
    return now;
  }
}

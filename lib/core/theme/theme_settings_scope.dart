import 'package:flutter/material.dart';

class ThemeSettingsScope extends InheritedWidget {
  const ThemeSettingsScope({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> setThemeMode;

  static ThemeSettingsScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ThemeSettingsScope>();
    assert(scope != null, 'ThemeSettingsScope not found in widget tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(ThemeSettingsScope oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}

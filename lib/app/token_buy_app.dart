import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_settings_scope.dart';
import '../features/token_flow/presentation/token_flow_page.dart';

class TokenBuyApp extends StatefulWidget {
  const TokenBuyApp({super.key});

  @override
  State<TokenBuyApp> createState() => _TokenBuyAppState();
}

class _TokenBuyAppState extends State<TokenBuyApp> {
  static const _prefKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (!mounted) return;
    setState(() {
      _themeMode = raw == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSettingsScope(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: MaterialApp(
        title: 'Token Buy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _themeMode,
        home: const TokenFlowPage(),
      ),
    );
  }
}

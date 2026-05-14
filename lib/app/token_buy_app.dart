import 'package:flutter/material.dart';

import '../core/app_lock/app_gate.dart';
import '../core/theme/app_theme.dart';
import '../features/token_flow/presentation/token_flow_page.dart';

class TokenBuyApp extends StatelessWidget {
  const TokenBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token Buy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const AppGate(child: TokenFlowPage()),
    );
  }
}

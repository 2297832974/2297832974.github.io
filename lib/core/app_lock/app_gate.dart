import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_lock_service.dart';
import 'app_locked_page.dart';

class AppGate extends StatefulWidget {
  final Widget child;

  const AppGate({super.key, required this.child});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> with WidgetsBindingObserver {
  final _service = AppLockService();

  AppLockStatus? _status;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    final status = await _service.getStatus();
    if (!mounted) return;

    setState(() => _status = status);
    _scheduleLock(status);
  }

  void _scheduleLock(AppLockStatus status) {
    _timer?.cancel();

    if (status.locked) return;
    final now = DateTime.now();
    final remaining = status.expiresAt.difference(now);
    if (remaining.isNegative) return;

    _timer = Timer(remaining, _refresh);
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    if (status == null) return widget.child;
    if (!status.locked) return widget.child;
    return AppLockedPage(status: status);
  }
}

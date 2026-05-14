import 'package:flutter/material.dart';

import 'app_lock_service.dart';

class AppLockedPage extends StatelessWidget {
  final AppLockStatus status;

  const AppLockedPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;
    final muted =
        theme.textTheme.bodyMedium?.color ?? text.withValues(alpha: 0.7);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Build Expired', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        'This build is limited to 2 hours after its first launch on this device.',
                        style: theme.textTheme.bodyLarge?.copyWith(color: text),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'First launch: ${status.firstLaunchAt}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Expired at: ${status.expiresAt}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'If you need to continue testing, reset the stored timer or use a test build configuration.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

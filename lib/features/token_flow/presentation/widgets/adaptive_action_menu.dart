import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/robux_ui_palette.dart';

class AdaptiveActionItem<T> {
  const AdaptiveActionItem({
    required this.value,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });

  final T value;
  final String label;
  final IconData icon;
  final bool isDestructive;
}

bool supportsDesktopSecondaryActions(BuildContext context) {
  if (kIsWeb) {
    return false;
  }

  switch (Theme.of(context).platform) {
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return true;
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return false;
  }
}

Future<T?> showAdaptiveActionMenu<T>(
  BuildContext context, {
  required List<AdaptiveActionItem<T>> items,
  Offset? globalPosition,
  String? title,
}) async {
  if (items.isEmpty) {
    return null;
  }

  if (supportsDesktopSecondaryActions(context) && globalPosition != null) {
    final palette = RobuxUiPalette.of(context);
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        for (final item in items)
          PopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color:
                      item.isDestructive
                          ? const Color(0xFFC83C3C)
                          : palette.textPrimary,
                ),
                const SizedBox(width: 10),
                Text(
                  item.label,
                  style: TextStyle(
                    color:
                        item.isDestructive
                            ? const Color(0xFFC83C3C)
                            : palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final palette = RobuxUiPalette.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Container(
            decoration: BoxDecoration(
              color: palette.dialogBackground,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 28,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: palette.divider),
                ],
                for (final item in items)
                  ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          item.isDestructive
                              ? const Color(0xFFC83C3C)
                              : palette.textPrimary,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color:
                            item.isDestructive
                                ? const Color(0xFFC83C3C)
                                : palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(item.value),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

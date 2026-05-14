import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                          : const Color(0xFF252A35),
                ),
                const SizedBox(width: 10),
                Text(
                  item.label,
                  style: TextStyle(
                    color:
                        item.isDestructive
                            ? const Color(0xFFC83C3C)
                            : const Color(0xFF252A35),
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
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                          style: const TextStyle(
                            color: Color(0xFF20232B),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE8EAF0)),
                ],
                for (final item in items)
                  ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          item.isDestructive
                              ? const Color(0xFFC83C3C)
                              : const Color(0xFF252A35),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color:
                            item.isDestructive
                                ? const Color(0xFFC83C3C)
                                : const Color(0xFF252A35),
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

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'adaptive_action_menu.dart';
import '../../../../core/theme/robux_ui_palette.dart';
import '../../../../core/theme/theme_settings_scope.dart';

class RobuxHomePage extends StatelessWidget {
  const RobuxHomePage({
    super.key,
    required this.robuxBalance,
    required this.onSendPressed,
    required this.onEditBalanceRequested,
  });

  final int robuxBalance;
  final VoidCallback onSendPressed;
  final VoidCallback onEditBalanceRequested;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 430;
        final heroHeadingStyle = _heroHeadingStyle(context, isCompact);
        final palette = RobuxUiPalette.of(context);

        return Container(
          color: palette.pageBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RobloxHeader(isCompact: isCompact),
              _RobuxAccountStrip(
                robuxBalance: robuxBalance,
                onSendPressed: onSendPressed,
                onEditBalanceRequested: onEditBalanceRequested,
                isCompact: isCompact,
              ),
              Expanded(
                child: CustomPaint(
                  painter: _SubtleGridPainter(palette: palette),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 14 : 22,
                      isCompact ? 20 : 34,
                      isCompact ? 14 : 22,
                      isCompact ? 20 : 34,
                    ),
                    children: [
                      Text(
                        'Enjoy up to 25% more Robux',
                        style: heroHeadingStyle,
                      ),
                      SizedBox(height: isCompact ? 34 : 70),
                      Text(
                        'Robux packages',
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: isCompact ? 20 : 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: isCompact ? 12 : 18),
                      _RobuxPackageCard(isCompact: isCompact),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

TextStyle _heroHeadingStyle(BuildContext context, bool isCompact) {
  final palette = RobuxUiPalette.of(context);
  final platform = Theme.of(context).platform;
  final fontSize =
      isCompact
          ? 34.0
          : switch (platform) {
            TargetPlatform.windows => 72.0,
            TargetPlatform.macOS => 60.0,
            _ => 66.0,
          };

  return TextStyle(
    color: palette.textPrimary,
    fontSize: fontSize,
    fontWeight: FontWeight.w900,
    height: isCompact ? 1.0 : 0.94,
    letterSpacing: isCompact ? -1.4 : -3.4,
  );
}

class _RobloxHeader extends StatelessWidget {
  const _RobloxHeader({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    return Container(
      height: isCompact ? 92 : 110,
      color: palette.headerBackground,
      child: Column(
        children: [
          SizedBox(
            height: isCompact ? 50 : 58,
            child: Row(
              children: [
                SizedBox(width: isCompact ? 8 : 10),
                Icon(
                  Icons.menu_rounded,
                  size: isCompact ? 24 : 28,
                  color: palette.iconPrimary,
                ),
                SizedBox(width: isCompact ? 12 : 20),
                _RobloxTiltedLogo(isCompact: isCompact),
                const Spacer(),
                _RobloxAvatar(isCompact: isCompact),
                SizedBox(width: isCompact ? 12 : 18),
                Icon(
                  Icons.search_rounded,
                  size: isCompact ? 28 : 34,
                  color: palette.iconSecondary,
                ),
                SizedBox(width: isCompact ? 12 : 18),
                _RobuxCurrencyIcon(
                  size: isCompact ? 28 : 34,
                  color: palette.iconPrimary,
                ),
                SizedBox(width: isCompact ? 12 : 18),
                InkWell(
                  key: const Key('open-settings-button'),
                  onTap: () => _showSettingsSheet(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.settings_outlined,
                      size: isCompact ? 28 : 34,
                      color: palette.iconPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isCompact ? 8 : 12),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _HeaderTab(label: 'Charts', isCompact: isCompact),
                ),
                Expanded(
                  child: _HeaderTab(label: 'Marketplace', isCompact: isCompact),
                ),
                Expanded(
                  child: _HeaderTab(label: 'Create', isCompact: isCompact),
                ),
                Expanded(
                  child: _HeaderTab(label: 'Robux', isCompact: isCompact),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: palette.divider),
        ],
      ),
    );
  }
}

Future<void> _showSettingsSheet(BuildContext context) async {
  final scope = ThemeSettingsScope.of(context);
  final palette = RobuxUiPalette.of(context);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                  child: Row(
                    children: [
                      Text(
                        'Settings',
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
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: scope.themeMode,
                  onChanged: (value) {
                    if (value == null) return;
                    scope.setThemeMode(value);
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    'Light',
                    style: TextStyle(color: palette.textPrimary),
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: scope.themeMode,
                  onChanged: (value) {
                    if (value == null) return;
                    scope.setThemeMode(value);
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    'Dark',
                    style: TextStyle(color: palette.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({required this.label, required this.isCompact});

  final String label;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            color: palette.textPrimary.withValues(alpha: 0.9),
            fontSize: isCompact ? 13 : 18,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _RobloxTiltedLogo extends StatelessWidget {
  const _RobloxTiltedLogo({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    final logoSize = isCompact ? 28.0 : 34.0;

    return Transform.rotate(
      angle: 0.26,
      child: Container(
        width: logoSize,
        height: logoSize,
        color: palette.logoFill,
        alignment: Alignment.center,
        child: Container(
          width: isCompact ? 7 : 9,
          height: isCompact ? 7 : 9,
          color: palette.logoHole,
        ),
      ),
    );
  }
}

class _RobloxAvatar extends StatelessWidget {
  const _RobloxAvatar({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    final avatarSize = isCompact ? 28.0 : 34.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: palette.avatarBackground,
        shape: BoxShape.circle,
        border: Border.all(color: palette.avatarBorder, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        'R',
        style: TextStyle(
          color: palette.avatarText,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RobuxAccountStrip extends StatelessWidget {
  const _RobuxAccountStrip({
    required this.robuxBalance,
    required this.onSendPressed,
    required this.onEditBalanceRequested,
    required this.isCompact,
  });

  final int robuxBalance;
  final VoidCallback onSendPressed;
  final VoidCallback onEditBalanceRequested;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final enableSecondaryTap = supportsDesktopSecondaryActions(context);
    final palette = RobuxUiPalette.of(context);

    return Container(
      height: isCompact ? 74 : 90,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 14 : 24),
      decoration: BoxDecoration(
        color: palette.accountStripBackground,
        border: Border(
          bottom: BorderSide(color: palette.accountStripBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              key: const Key('home-balance-trigger'),
              behavior: HitTestBehavior.opaque,
              onSecondaryTap:
                  enableSecondaryTap ? onEditBalanceRequested : null,
              onLongPress: onEditBalanceRequested,
              child: Row(
                children: [
                  _RobuxCurrencyIcon(
                    size: isCompact ? 28 : 34,
                    color: palette.textPrimary,
                  ),
                  SizedBox(width: isCompact ? 7 : 9),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatCompactRobuxBalance(robuxBalance),
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: isCompact ? 20 : 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: isCompact ? 10 : 16),
          InkWell(
            key: const Key('open-send-dialog-button'),
            onTap: onSendPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: isCompact ? 82 : 92,
              height: isCompact ? 34 : 38,
              decoration: BoxDecoration(
                color: palette.sendButtonBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    size: isCompact ? 16 : 18,
                    color: palette.sendButtonText,
                  ),
                  SizedBox(width: isCompact ? 5 : 7),
                  Text(
                    'Send',
                    style: TextStyle(
                      color: palette.sendButtonText,
                      fontSize: isCompact ? 13 : 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCompactRobuxBalance(int balance) {
  final raw = balance.toString();
  return raw.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

class _SubtleGridPainter extends CustomPainter {
  const _SubtleGridPainter({required this.palette});

  final RobuxUiPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = palette.gridLine
          ..strokeWidth = 0.7;

    for (double x = -36; x < size.width; x += 26) {
      canvas.drawLine(Offset(x, 0), Offset(x + 92, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 44), paint);
    }

    final curvePaint =
        Paint()
          ..color = palette.gridCurve
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    for (double radius = 160; radius < 540; radius += 46) {
      canvas.drawCircle(Offset(size.width * 0.48, 132), radius, curvePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SubtleGridPainter oldDelegate) => false;
}

class _RobuxPackageCard extends StatelessWidget {
  const _RobuxPackageCard({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 12 : 20,
        isCompact ? 12 : 16,
        isCompact ? 12 : 16,
        isCompact ? 8 : 18,
      ),
      decoration: BoxDecoration(
        color: palette.packageCardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.packageCardBorder, width: 1),
      ),
      child: Column(
        children: [
          _RobuxPackageRow(
            amount: '24,000',
            previous: '22,500',
            price: '£199.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '11,000',
            previous: '10,000',
            price: '£99.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '5,250',
            previous: '4,500',
            price: '£49.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '3,625',
            previous: '3,150',
            price: '£34.99',
            isPrimary: true,
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '2,000',
            previous: '1,700',
            price: '£19.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '1,500',
            previous: '1,200',
            price: '£14.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '1,000',
            previous: '800',
            price: '£9.99',
            isCompact: isCompact,
          ),
          _RobuxPackageRow(
            amount: '500',
            previous: '400',
            price: '£4.99',
            isCompact: isCompact,
          ),
        ],
      ),
    );
  }
}

class _RobuxPackageRow extends StatelessWidget {
  const _RobuxPackageRow({
    required this.amount,
    required this.previous,
    required this.price,
    required this.isCompact,
    this.isPrimary = false,
  });

  final String amount;
  final String previous;
  final String price;
  final bool isCompact;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final palette = RobuxUiPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 18 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RobuxCurrencyIcon(
            size: isCompact ? 22 : 28,
            color: palette.textPrimary,
          ),
          SizedBox(width: isCompact ? 7 : 9),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: isCompact ? 6 : 10,
              runSpacing: 2,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: isCompact ? 22 : 29,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                _RobuxCurrencyIcon(
                  size: isCompact ? 17 : 21,
                  color: palette.textSecondary,
                ),
                Text(
                  previous,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: isCompact ? 15 : 18,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: palette.textSecondary,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isCompact ? 8 : 12),
          Container(
            width: isCompact ? 110 : 144,
            height: isCompact ? 42 : 48,
            decoration: BoxDecoration(
              color:
                  isPrimary
                      ? palette.pricePillPrimaryBackground
                      : palette.pricePillBackground,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              price,
              style: TextStyle(
                color:
                    isPrimary
                        ? palette.pricePillPrimaryText
                        : palette.pricePillText,
                fontSize: isCompact ? 15 : 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RobuxCurrencyIcon extends StatelessWidget {
  const _RobuxCurrencyIcon({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RobuxCurrencyIconPainter(
          color: color,
          strokeWidth: size * 0.09,
        ),
      ),
    );
  }
}

class _RobuxCurrencyIconPainter extends CustomPainter {
  const _RobuxCurrencyIconPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round;
    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawPath(
      _hexagon(center: center, radius: size.width * 0.46),
      strokePaint,
    );
    canvas.drawPath(
      _hexagon(center: center, radius: size.width * 0.29),
      strokePaint,
    );

    final squareSize = size.width * 0.19;
    canvas.drawRect(
      Rect.fromCenter(center: center, width: squareSize, height: squareSize),
      fillPaint,
    );
  }

  Path _hexagon({required Offset center, required double radius}) {
    final path = Path();
    for (int index = 0; index < 6; index++) {
      final angle = (-math.pi / 2) + (index * math.pi / 3);
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _RobuxCurrencyIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

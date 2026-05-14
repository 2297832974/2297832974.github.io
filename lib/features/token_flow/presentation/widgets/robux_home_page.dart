import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'adaptive_action_menu.dart';

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

        return Container(
          color: const Color(0xFFFAFAFB),
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
                  painter: const _SubtleGridPainter(),
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
                          color: const Color(0xFF20232B),
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
    color: const Color(0xFF20232B),
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
    return Container(
      height: isCompact ? 92 : 110,
      color: const Color(0xFFFAFAFB),
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
                  color: const Color(0xFF33363D),
                ),
                SizedBox(width: isCompact ? 12 : 20),
                _RobloxTiltedLogo(isCompact: isCompact),
                const Spacer(),
                _RobloxAvatar(isCompact: isCompact),
                SizedBox(width: isCompact ? 12 : 18),
                Icon(
                  Icons.search_rounded,
                  size: isCompact ? 28 : 34,
                  color: const Color(0xFF4B4E55),
                ),
                SizedBox(width: isCompact ? 12 : 18),
                _RobuxCurrencyIcon(
                  size: isCompact ? 28 : 34,
                  color: const Color(0xFF33363D),
                ),
                SizedBox(width: isCompact ? 12 : 18),
                Icon(
                  Icons.settings_outlined,
                  size: isCompact ? 28 : 34,
                  color: const Color(0xFF33363D),
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
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E8)),
        ],
      ),
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({required this.label, required this.isCompact});

  final String label;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xFF2A2D34),
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
    final logoSize = isCompact ? 28.0 : 34.0;

    return Transform.rotate(
      angle: 0.26,
      child: Container(
        width: logoSize,
        height: logoSize,
        color: const Color(0xFF33363D),
        alignment: Alignment.center,
        child: Container(
          width: isCompact ? 7 : 9,
          height: isCompact ? 7 : 9,
          color: const Color(0xFFFAFAFB),
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
    final avatarSize = isCompact ? 28.0 : 34.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF7),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD2D5DC), width: 1),
      ),
      alignment: Alignment.center,
      child: const Text(
        'R',
        style: TextStyle(
          color: Color(0xFF7A4B23),
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

    return Container(
      height: isCompact ? 74 : 90,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 14 : 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E8), width: 1)),
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
                    color: const Color(0xFF20232B),
                  ),
                  SizedBox(width: isCompact ? 7 : 9),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatCompactRobuxBalance(robuxBalance),
                        style: TextStyle(
                          color: const Color(0xFF20232B),
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
                color: const Color(0xFFE3E3EA),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    size: isCompact ? 16 : 18,
                    color: const Color(0xFF20232B),
                  ),
                  SizedBox(width: isCompact ? 5 : 7),
                  Text(
                    'Send',
                    style: TextStyle(
                      color: const Color(0xFF20232B),
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
  const _SubtleGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE8E9EF).withValues(alpha: 0.52)
          ..strokeWidth = 0.7;

    for (double x = -36; x < size.width; x += 26) {
      canvas.drawLine(Offset(x, 0), Offset(x + 92, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 44), paint);
    }

    final curvePaint =
        Paint()
          ..color = const Color(0xFFD9DBE3).withValues(alpha: 0.42)
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
    return Container(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 12 : 20,
        isCompact ? 12 : 16,
        isCompact ? 12 : 16,
        isCompact ? 8 : 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFC).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD7D9E1), width: 1),
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
    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 18 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RobuxCurrencyIcon(
            size: isCompact ? 22 : 28,
            color: const Color(0xFF20232B),
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
                    color: const Color(0xFF20232B),
                    fontSize: isCompact ? 22 : 29,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                _RobuxCurrencyIcon(
                  size: isCompact ? 17 : 21,
                  color: const Color(0xFF777C8E),
                ),
                Text(
                  previous,
                  style: TextStyle(
                    color: const Color(0xFF777C8E),
                    fontSize: isCompact ? 15 : 18,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: const Color(0xFF777C8E),
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
                  isPrimary ? const Color(0xFF3761FF) : const Color(0xFFE4E4EA),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              price,
              style: TextStyle(
                color: isPrimary ? Colors.white : const Color(0xFF20232B),
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

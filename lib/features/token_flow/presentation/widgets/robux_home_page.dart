import 'dart:math' as math;

import 'package:flutter/material.dart';

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
    return Container(
      color: const Color(0xFFFAFAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _RobloxHeader(),
          _RobuxAccountStrip(
            robuxBalance: robuxBalance,
            onSendPressed: onSendPressed,
            onEditBalanceRequested: onEditBalanceRequested,
          ),
          Expanded(
            child: CustomPaint(
              painter: const _SubtleGridPainter(),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 34, 22, 34),
                children: const [
                  Text(
                    'Enjoy up to 25% more\nRobux',
                    style: TextStyle(
                      color: Color(0xFF20232B),
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                      letterSpacing: -1.7,
                    ),
                  ),
                  SizedBox(height: 70),
                  Text(
                    'Robux packages',
                    style: TextStyle(
                      color: Color(0xFF20232B),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 18),
                  _RobuxPackageCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RobloxHeader extends StatelessWidget {
  const _RobloxHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      color: const Color(0xFFFAFAFB),
      child: Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(
                  Icons.menu_rounded,
                  size: 28,
                  color: Color(0xFF33363D),
                ),
                const SizedBox(width: 20),
                const _RobloxTiltedLogo(),
                const Spacer(),
                const _RobloxAvatar(),
                const SizedBox(width: 18),
                const Icon(
                  Icons.search_rounded,
                  size: 34,
                  color: Color(0xFF4B4E55),
                ),
                const SizedBox(width: 18),
                const _RobuxCurrencyIcon(size: 34, color: Color(0xFF33363D)),
                const SizedBox(width: 18),
                const Icon(
                  Icons.settings_outlined,
                  size: 34,
                  color: Color(0xFF33363D),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderTab(label: 'Charts'),
                _HeaderTab(label: 'Marketplace'),
                _HeaderTab(label: 'Create'),
                _HeaderTab(label: 'Robux'),
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
  const _HeaderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF2A2D34),
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _RobloxTiltedLogo extends StatelessWidget {
  const _RobloxTiltedLogo();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.26,
      child: Container(
        width: 34,
        height: 34,
        color: const Color(0xFF33363D),
        alignment: Alignment.center,
        child: Container(width: 9, height: 9, color: const Color(0xFFFAFAFB)),
      ),
    );
  }
}

class _RobloxAvatar extends StatelessWidget {
  const _RobloxAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
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
  });

  final int robuxBalance;
  final VoidCallback onSendPressed;
  final VoidCallback onEditBalanceRequested;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E8), width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            key: const Key('home-balance-trigger'),
            behavior: HitTestBehavior.opaque,
            onSecondaryTap: onEditBalanceRequested,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _RobuxCurrencyIcon(size: 34, color: Color(0xFF20232B)),
                const SizedBox(width: 9),
                Text(
                  _formatCompactRobuxBalance(robuxBalance),
                  style: const TextStyle(
                    color: Color(0xFF20232B),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            key: const Key('open-send-dialog-button'),
            onTap: onSendPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 92,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE3E3EA),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    size: 18,
                    color: Color(0xFF20232B),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Send',
                    style: TextStyle(
                      color: Color(0xFF20232B),
                      fontSize: 15,
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
  const _RobuxPackageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFC).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD7D9E1), width: 1),
      ),
      child: const Column(
        children: [
          _RobuxPackageRow(
            amount: '24,000',
            previous: '22,500',
            price: '¥31,800',
          ),
          _RobuxPackageRow(
            amount: '11,000',
            previous: '10,000',
            price: '¥15,800',
          ),
          _RobuxPackageRow(amount: '5,250', previous: '4,500', price: '¥8,000'),
          _RobuxPackageRow(amount: '3,625', previous: '3,150', price: '¥6,000'),
          _RobuxPackageRow(amount: '2,000', previous: '1,700', price: '¥3,200'),
          _RobuxPackageRow(amount: '1,500', previous: '1,200', price: '¥2,500'),
          _RobuxPackageRow(amount: '1,000', previous: '800', price: '¥1,600'),
          _RobuxPackageRow(
            amount: '500',
            previous: '400',
            price: '¥800',
            isPrimary: true,
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
    this.isPrimary = false,
  });

  final String amount;
  final String previous;
  final String price;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _RobuxCurrencyIcon(size: 28, color: Color(0xFF20232B)),
          const SizedBox(width: 9),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF20232B),
              fontSize: 29,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(width: 10),
          const _RobuxCurrencyIcon(size: 21, color: Color(0xFF777C8E)),
          Text(
            previous,
            style: const TextStyle(
              color: Color(0xFF777C8E),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.lineThrough,
              decorationColor: Color(0xFF777C8E),
              decorationThickness: 2,
            ),
          ),
          const Spacer(),
          Container(
            width: 144,
            height: 48,
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
                fontSize: 18,
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

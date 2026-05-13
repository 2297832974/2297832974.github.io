import 'package:flutter/material.dart';

import '../../domain/token_flow_stage.dart';

class TokenMockPhone extends StatelessWidget {
  const TokenMockPhone({super.key, required this.stage});

  final TokenFlowStage stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile Skeleton Preview', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'A code-first mock shaped from the extracted video states. Switch stages on the left to validate structure before building production logic.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 9 / 19,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: const Color(0xFF2A3140)),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0C0E15), Color(0xFF07070A)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _buildTopBanner(theme),
                      const Spacer(),
                      _buildDialog(theme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF4E1C28)),
        color: const Color(0xFF100C12),
      ),
      child: Column(
        children: [
          Text(
            'EDUCATIONAL PURPOSES ONLY',
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFE8E6EA),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'SPAM USERNAMES!!!',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialog(ThemeData theme) {
    switch (stage) {
      case TokenFlowStage.search:
        return _DialogShell(
          title: 'Send Robux',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InputField(value: 'gxyan2404', focused: true),
              const SizedBox(height: 12),
              Text('Search results', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                'Start typing to search Roblox users.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case TokenFlowStage.results:
        return _DialogShell(
          title: 'Send Robux',
          child: Column(
            children: [
              _InputField(value: 'Sauveur2deCAPYBARAS', focused: true),
              const SizedBox(height: 12),
              ...[
                'Sauveur2deCAPYBARAS',
                'pls',
                'pls',
                'plsssss',
              ].map((name) => _ResultRow(name: name)),
            ],
          ),
        );
      case TokenFlowStage.amount:
        return _DialogShell(
          title: 'Send Robux',
          child: Column(
            children: [
              _ProfileHeader(amount: '5'),
              const SizedBox(height: 14),
              _InputField(value: '5000'),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AmountChip(label: '25'),
                  _AmountChip(label: '50'),
                  _AmountChip(label: '100'),
                  _AmountChip(label: '200'),
                ],
              ),
              const SizedBox(height: 16),
              _PrimaryButton(label: 'Next'),
            ],
          ),
        );
      case TokenFlowStage.confirm:
        return _DialogShell(
          title: 'Send Robux',
          child: Column(
            children: [
              const _ProfileHeader(amount: '5,000', expanded: true),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _PrimaryButton(label: 'Send')),
                  const SizedBox(width: 10),
                  Expanded(child: _SecondaryButton(label: 'Exit')),
                ],
              ),
            ],
          ),
        );
    }
  }
}

class _DialogShell extends StatelessWidget {
  const _DialogShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(
          color: const Color(0xFF616674),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF181B22),
                  ),
                ),
                const Spacer(),
                Text(
                  '27.7M',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF181B22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({this.value = '', this.focused = false});

  final String value;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? const Color(0xFF5865F2) : const Color(0xFFD9DCE4),
          width: focused ? 1.5 : 1,
        ),
      ),
      child: Text(
        value.isEmpty ? 'Enter username' : value,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color:
              value.isEmpty ? const Color(0xFF9BA1B3) : const Color(0xFF131722),
          fontSize: 14,
          fontWeight: value.isEmpty ? FontWeight.w500 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Color(0xFFE5E8EF)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF171B24),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.amount, this.expanded = false});

  final String amount;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE5E8EF)),
        const SizedBox(height: 10),
        const Text(
          'Sauveur2deCAPYBARAS',
          style: TextStyle(
            color: Color(0xFF171B24),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          expanded ? amount : amount,
          style: const TextStyle(
            color: Color(0xFF171B24),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF171B24),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF5865F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF171B24),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

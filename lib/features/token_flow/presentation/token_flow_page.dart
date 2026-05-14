import 'package:flutter/material.dart';

import 'widgets/robux_home_page.dart';

enum _SendStage { search, amount, confirm, hidden }

class _ReferenceUser {
  const _ReferenceUser({
    required this.name,
    required this.handle,
    required this.avatarColor,
  });

  final String name;
  final String handle;
  final Color avatarColor;
}

const _referenceUsers = [
  _ReferenceUser(
    name: 'Sauveur2deCAPYBARAS',
    handle: '@sauveur',
    avatarColor: Color(0xFFE5E7EC),
  ),
  _ReferenceUser(
    name: 'miriandogaru',
    handle: '@miriandogaru',
    avatarColor: Color(0xFFD5805E),
  ),
  _ReferenceUser(
    name: 'SonicBacon',
    handle: '@SonicBacon',
    avatarColor: Color(0xFFE2C35F),
  ),
];

class TokenFlowPage extends StatefulWidget {
  const TokenFlowPage({super.key});

  @override
  State<TokenFlowPage> createState() => _TokenFlowPageState();
}

class _TokenFlowPageState extends State<TokenFlowPage> {
  final _usernameController = TextEditingController();
  final _amountController = TextEditingController();
  _SendStage _stage = _SendStage.hidden;
  _ReferenceUser _selectedUser = _referenceUsers.first;
  bool _showSuccessToast = false;

  bool get _showResults => _usernameController.text.trim().length >= 3;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_handleTextChanged);
    _amountController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _usernameController
      ..removeListener(_handleTextChanged)
      ..dispose();
    _amountController
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 592,
              height: 1280,
              child: _VideoAppSurface(
                stage: _stage,
                selectedUser: _selectedUser,
                usernameController: _usernameController,
                amountController: _amountController,
                showResults: _showResults,
                showSuccessToast: _showSuccessToast,
                onUserSelected: _handleUserSelected,
                onNext: _handleNext,
                onSend: _handleSend,
                onOpenSendDialog: _handleOpenSendDialog,
                onClose: _handleCloseDialog,
                onExit: _handleExit,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTextChanged() {
    setState(() {});
  }

  void _handleOpenSendDialog() {
    setState(() {
      _resetSearch(updateState: false, nextStage: _SendStage.search);
    });
  }

  void _handleUserSelected(_ReferenceUser user) {
    setState(() {
      _selectedUser = user;
      _usernameController.text = user.name;
      _stage = _SendStage.amount;
    });
  }

  void _handleNext() {
    if (_amountController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _stage = _SendStage.confirm;
    });
  }

  void _handleExit() {
    _resetSearch();
  }

  void _handleCloseDialog() {
    setState(() {
      _stage = _SendStage.hidden;
    });
  }

  void _handleSend() {
    setState(() {
      _showSuccessToast = true;
      _stage = _SendStage.hidden;
    });

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _resetSearch(updateState: false, nextStage: _SendStage.hidden);
      });
    });
  }

  void _resetSearch({
    bool updateState = true,
    _SendStage nextStage = _SendStage.search,
  }) {
    void reset() {
      _stage = nextStage;
      _selectedUser = _referenceUsers.first;
      _showSuccessToast = false;
      _usernameController.clear();
      _amountController.clear();
    }

    if (updateState) {
      setState(reset);
      return;
    }

    reset();
  }
}

List<_ReferenceUser> _searchUsers(String query) {
  final normalized = query.trim().toLowerCase();

  if (normalized.length < 3) {
    return const [];
  }

  if (normalized.contains('zz') || normalized.contains('none')) {
    return const [];
  }

  if (normalized.contains('mir')) {
    return [_referenceUsers[1]];
  }

  if (normalized.contains('sonic') || normalized.contains('bacon')) {
    return [_referenceUsers[2]];
  }

  return [
    _referenceUsers[0],
    const _ReferenceUser(
      name: 'pls',
      handle: '@pls',
      avatarColor: Color(0xFFD7DCE5),
    ),
    const _ReferenceUser(
      name: 'pls',
      handle: '@pls2',
      avatarColor: Color(0xFFE7E2D7),
    ),
    const _ReferenceUser(
      name: 'plsssss',
      handle: '@plsssss',
      avatarColor: Color(0xFFD7E5DE),
    ),
  ];
}

String _formatRobuxAmount(String amount) {
  final raw = amount.trim();
  if (raw.isEmpty) {
    return '0';
  }

  final parsed = int.tryParse(raw.replaceAll(',', ''));
  if (parsed == null) {
    return raw;
  }

  return parsed.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}

class _VideoAppSurface extends StatelessWidget {
  const _VideoAppSurface({
    required this.stage,
    required this.selectedUser,
    required this.usernameController,
    required this.amountController,
    required this.showResults,
    required this.showSuccessToast,
    required this.onUserSelected,
    required this.onNext,
    required this.onSend,
    required this.onOpenSendDialog,
    required this.onClose,
    required this.onExit,
  });

  final _SendStage stage;
  final _ReferenceUser selectedUser;
  final TextEditingController usernameController;
  final TextEditingController amountController;
  final bool showResults;
  final bool showSuccessToast;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onNext;
  final VoidCallback onSend;
  final VoidCallback onOpenSendDialog;
  final VoidCallback onClose;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1A1A1A)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          RobuxHomePage(onSendPressed: onOpenSendDialog),
          if (stage != _SendStage.hidden)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.26)),
            ),
          if (stage != _SendStage.hidden)
            const Positioned(
              left: 22,
              right: 22,
              top: 8,
              child: _RecordingStatusBar(),
            ),
          if (showSuccessToast)
            Positioned(
              left: 182,
              right: 182,
              top: 92,
              child: _SuccessToast(
                amount: _formatRobuxAmount(amountController.text),
              ),
            ),
          if (stage != _SendStage.hidden)
            Positioned(
              left: 28,
              right: 28,
              top: _dialogTop(stage, showResults),
              child: _SendRobuxDialog(
                stage: stage,
                selectedUser: selectedUser,
                usernameController: usernameController,
                amountController: amountController,
                showResults: showResults,
                onUserSelected: onUserSelected,
                onNext: onNext,
                onSend: onSend,
                onClose: onClose,
                onExit: onExit,
              ),
            ),
          Positioned(
            left: 22,
            bottom: 30,
            child: IgnorePointer(
              ignoring: stage != _SendStage.hidden,
              child: const _CommentIcon(),
            ),
          ),
          if (stage != _SendStage.hidden)
            Positioned(
              left: 96,
              right: 96,
              bottom: 10,
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static double _dialogTop(_SendStage stage, bool showResults) {
    if (stage == _SendStage.confirm) {
      return 322;
    }
    if (stage == _SendStage.amount) {
      return 294;
    }
    if (showResults) {
      return 230;
    }
    if (stage == _SendStage.hidden) {
      return 0;
    }
    return 278;
  }
}

class _RecordingStatusBar extends StatelessWidget {
  const _RecordingStatusBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 74,
          child: Text(
            '19:01',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 150,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFF47101A), width: 1.5),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26),
          child: Container(
            width: 13,
            height: 13,
            decoration: const BoxDecoration(
              color: Color(0xFFFF304F),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(
          width: 122,
          child: Text(
            '▮▮▮  WiFi  24',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SendRobuxDialog extends StatelessWidget {
  const _SendRobuxDialog({
    required this.stage,
    required this.selectedUser,
    required this.usernameController,
    required this.amountController,
    required this.showResults,
    required this.onUserSelected,
    required this.onNext,
    required this.onSend,
    required this.onClose,
    required this.onExit,
  });

  final _SendStage stage;
  final _ReferenceUser selectedUser;
  final TextEditingController usernameController;
  final TextEditingController amountController;
  final bool showResults;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onNext;
  final VoidCallback onSend;
  final VoidCallback onClose;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DialogHeader(onClose: onClose),
          const SizedBox(height: 10),
          if (stage == _SendStage.search)
            _SearchBody(
              controller: usernameController,
              showResults: showResults,
              onUserSelected: onUserSelected,
            ),
          if (stage == _SendStage.amount)
            _AmountBody(
              controller: amountController,
              selectedUser: selectedUser,
              onNext: onNext,
            ),
          if (stage == _SendStage.confirm)
            _ConfirmBody(
              amount: amountController.text.trim(),
              selectedUser: selectedUser,
              onSend: onSend,
              onExit: onExit,
            ),
        ],
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.adjust_rounded, size: 14, color: Color(0xFF1E222B)),
        const SizedBox(width: 6),
        const Text(
          'Send Robux',
          style: TextStyle(
            color: Color(0xFF1E222B),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        const Icon(Icons.adjust_rounded, size: 12, color: Color(0xFF1E222B)),
        const SizedBox(width: 4),
        const Text(
          '27.7M',
          style: TextStyle(
            color: Color(0xFF1E222B),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          key: const Key('close-dialog-button'),
          onTap: onClose,
          borderRadius: BorderRadius.circular(12),
          child: const SizedBox(
            width: 22,
            height: 22,
            child: Center(
              child: Text(
                'x',
                style: TextStyle(
                  color: Color(0xFF1E222B),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.controller,
    required this.showResults,
    required this.onUserSelected,
  });

  final TextEditingController controller;
  final bool showResults;
  final ValueChanged<_ReferenceUser> onUserSelected;

  @override
  Widget build(BuildContext context) {
    final results = _searchUsers(controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DialogTextField(
          key: const Key('username-input'),
          controller: controller,
          hintText: 'Enter username',
        ),
        const SizedBox(height: 11),
        const Row(
          children: [
            Icon(
              Icons.person_search_rounded,
              size: 13,
              color: Color(0xFF505666),
            ),
            SizedBox(width: 5),
            Text(
              'Search results',
              style: TextStyle(
                color: Color(0xFF303541),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!showResults)
          const Text(
            'Start typing to search Roblox users',
            style: TextStyle(
              color: Color(0xFF737987),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (showResults && results.isEmpty)
          const Text(
            'No users found',
            style: TextStyle(
              color: Color(0xFF737987),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (showResults && results.isNotEmpty)
          ...results.map(
            (user) => _ResultRow(user: user, onTap: () => onUserSelected(user)),
          ),
      ],
    );
  }
}

class _AmountBody extends StatelessWidget {
  const _AmountBody({
    required this.controller,
    required this.selectedUser,
    required this.onNext,
  });

  final TextEditingController controller;
  final _ReferenceUser selectedUser;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final hasAmount = controller.text.trim().isNotEmpty;

    return Column(
      children: [
        _SelectedUserHeader(user: selectedUser),
        const SizedBox(height: 13),
        _DialogTextField(
          key: const Key('amount-input'),
          controller: controller,
          hintText: 'Amount',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _AmountPill(label: '25', onTap: () => controller.text = '25'),
            _AmountPill(label: '50', onTap: () => controller.text = '50'),
            _AmountPill(label: '100', onTap: () => controller.text = '100'),
            _AmountPill(label: '200', onTap: () => controller.text = '200'),
          ],
        ),
        const SizedBox(height: 12),
        _ActionButton(
          key: const Key('amount-next-button'),
          label: 'Next',
          enabled: hasAmount,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _ConfirmBody extends StatelessWidget {
  const _ConfirmBody({
    required this.amount,
    required this.selectedUser,
    required this.onSend,
    required this.onExit,
  });

  final String amount;
  final _ReferenceUser selectedUser;
  final VoidCallback onSend;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final displayAmount = _formatRobuxAmount(amount);

    return Column(
      children: [
        _SelectedUserHeader(user: selectedUser, showMeta: true),
        const SizedBox(height: 16),
        Text(
          '◎ $displayAmount',
          style: const TextStyle(
            color: Color(0xFF1E222B),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                key: const Key('confirm-send-button'),
                label: 'Send',
                enabled: true,
                onTap: onSend,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(child: _ExitButton(onTap: onExit)),
          ],
        ),
      ],
    );
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1B1F2A),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF8B90A0),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFF5E49D6), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFF5E49D6), width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.user, required this.onTap});

  final _ReferenceUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            _AvatarMark(user: user, size: 28),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Color(0xFF171B24),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    user.handle,
                    style: const TextStyle(
                      color: Color(0xFF7B8190),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedUserHeader extends StatelessWidget {
  const _SelectedUserHeader({required this.user, this.showMeta = false});

  final _ReferenceUser user;
  final bool showMeta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AvatarMark(user: user),
        const SizedBox(height: 7),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF171B24),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (showMeta) ...[
          const SizedBox(height: 5),
          Text(
            '${user.handle}\nJoined in 2021',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7B8190),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _AmountPill extends StatelessWidget {
  const _AmountPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 50,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF252A35),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark({required this.user, this.size = 52});

  final _ReferenceUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = user.name.isEmpty ? '?' : user.name.characters.first;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: user.avatarColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(
          color: const Color(0xFF171B24),
          fontSize: size * 0.32,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xEA1D1F27),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'You sent $amount Robux',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.enabled,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF5A43F1) : const Color(0xFFE1E3EA),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : const Color(0xFF9AA0AD),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F5),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Text(
          'Exit',
          style: TextStyle(
            color: Color(0xFF252A35),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CommentIcon extends StatelessWidget {
  const _CommentIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 30,
      height: 36,
      child: CustomPaint(painter: _CommentIconPainter()),
    );
  }
}

class _CommentIconPainter extends CustomPainter {
  const _CommentIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.17,
        size.height * 0.08,
        size.width * 0.62,
        size.height * 0.66,
      ),
      const Radius.circular(1.5),
    );

    canvas.drawRRect(rect, paint);
    canvas.drawLine(
      Offset(size.width * 0.31, size.height * 0.52),
      Offset(size.width * 0.31, size.height * 0.91),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.31, size.height * 0.91),
      Offset(size.width * 0.56, size.height * 0.70),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.56, size.height * 0.70),
      Offset(size.width * 0.83, size.height * 0.86),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

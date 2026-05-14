import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'widgets/robux_home_page.dart';

enum _SendStage { search, amount, confirm, hidden }

class _ReferenceUser {
  const _ReferenceUser({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarColor,
    this.hasAvatar = true,
    this.isFriend = true,
  });

  final String id;
  final String name;
  final String handle;
  final Color avatarColor;
  final bool hasAvatar;
  final bool isFriend;

  _ReferenceUser copyWith({
    String? id,
    String? name,
    String? handle,
    Color? avatarColor,
    bool? hasAvatar,
    bool? isFriend,
  }) {
    return _ReferenceUser(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarColor: avatarColor ?? this.avatarColor,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}

const _seedFriends = [
  _ReferenceUser(
    id: 'friend-ktz',
    name: 'ktz',
    handle: '@ktz',
    avatarColor: Color(0xFF3A3F49),
  ),
  _ReferenceUser(
    id: 'friend-diddieblud676',
    name: 'diddieblud676',
    handle: '@diddieblud676',
    avatarColor: Color(0xFFB88251),
  ),
  _ReferenceUser(
    id: 'friend-vixsauce',
    name: 'vixsauce',
    handle: '@vixsauce',
    avatarColor: Color(0xFF6C202B),
  ),
  _ReferenceUser(
    id: 'friend-daxshyy',
    name: 'daxshyy',
    handle: '@daxshyy',
    avatarColor: Color(0xFFB7BDC9),
  ),
  _ReferenceUser(
    id: 'friend-dinoh',
    name: 'Dinoh',
    handle: '@Dinoh',
    avatarColor: Color(0xFF8A5A36),
  ),
  _ReferenceUser(
    id: 'friend-sauveur',
    name: 'Sauveur2deCAPYBARAS',
    handle: '@sauveur',
    avatarColor: Color(0xFFE5E7EC),
  ),
  _ReferenceUser(
    id: 'friend-mirian',
    name: 'miriandogaru',
    handle: '@miriandogaru',
    avatarColor: Color(0xFFD5805E),
  ),
  _ReferenceUser(
    id: 'friend-sonic',
    name: 'SonicBacon',
    handle: '@SonicBacon',
    avatarColor: Color(0xFFE2C35F),
  ),
];

const _avatarPalette = [
  Color(0xFF3A3F49),
  Color(0xFFB88251),
  Color(0xFF6C202B),
  Color(0xFFB7BDC9),
  Color(0xFF8A5A36),
  Color(0xFFE5E7EC),
  Color(0xFFD5805E),
  Color(0xFFE2C35F),
  Color(0xFF4E6E58),
];

enum _FriendMenuAction { add, edit, delete }

class TokenFlowPage extends StatefulWidget {
  const TokenFlowPage({super.key});

  @override
  State<TokenFlowPage> createState() => _TokenFlowPageState();
}

class _TokenFlowPageState extends State<TokenFlowPage> {
  final _usernameController = TextEditingController();
  final _amountController = TextEditingController();
  _SendStage _stage = _SendStage.hidden;
  List<_ReferenceUser> _friends = List.of(_seedFriends);
  _ReferenceUser _selectedUser = _seedFriends.first;
  int _robuxBalance = 0;
  bool _showSuccessToast = false;
  String? _submittedSearchQuery;

  String get _trimmedUsername => _usernameController.text.trim();

  bool get _hasCommittedSearch =>
      _trimmedUsername.isNotEmpty && _submittedSearchQuery == _trimmedUsername;

  bool get _showResults => _trimmedUsername.isNotEmpty;

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
                friends: _friends,
                robuxBalance: _robuxBalance,
                usernameController: _usernameController,
                amountController: _amountController,
                showResults: _showResults,
                submittedSearchQuery:
                    _hasCommittedSearch ? _submittedSearchQuery : null,
                showSuccessToast: _showSuccessToast,
                onUserSelected: _handleUserSelected,
                onSearchSubmitted: _handleSearchSubmitted,
                onAddFriendRequested: _handleAddFriendRequested,
                onEditFriendRequested: _handleEditFriendRequested,
                onDeleteFriendRequested: _handleDeleteFriendRequested,
                onEditBalanceRequested: _handleEditBalanceRequested,
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

  void _handleSearchSubmitted() {
    final query = _trimmedUsername;
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _submittedSearchQuery = query;
    });
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
      _submittedSearchQuery = null;
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
    final sendAmount = int.tryParse(
      _amountController.text.trim().replaceAll(',', ''),
    );

    setState(() {
      if (sendAmount != null && sendAmount > 0) {
        _robuxBalance = math.max(0, _robuxBalance - sendAmount);
      }
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

  Future<void> _handleAddFriendRequested() async {
    final friend = await _showFriendEditorDialog();
    if (!mounted || friend == null) {
      return;
    }

    setState(() {
      _friends = [..._friends, friend];
    });
  }

  Future<void> _handleEditFriendRequested(_ReferenceUser user) async {
    final friend = await _showFriendEditorDialog(existing: user);
    if (!mounted || friend == null) {
      return;
    }

    setState(() {
      _friends =
          _friends
              .map((current) => current.id == user.id ? friend : current)
              .toList();
      if (_selectedUser.id == user.id) {
        _selectedUser = friend;
      }
    });
  }

  void _handleDeleteFriendRequested(_ReferenceUser user) {
    setState(() {
      _friends = _friends.where((current) => current.id != user.id).toList();
      if (_selectedUser.id == user.id) {
        _selectedUser = _friends.isNotEmpty ? _friends.first : user;
      }
    });
  }

  Future<void> _handleEditBalanceRequested() async {
    final controller = TextEditingController(text: _robuxBalance.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit balance'),
          content: TextField(
            key: const Key('balance-input'),
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Robux balance'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final parsed = int.tryParse(
                  controller.text.trim().replaceAll(',', ''),
                );
                Navigator.of(context).pop(parsed);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _robuxBalance = math.max(0, result);
    });
  }

  Future<_ReferenceUser?> _showFriendEditorDialog({
    _ReferenceUser? existing,
  }) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final handleController = TextEditingController(
      text: existing == null ? '' : existing.handle.replaceFirst('@', ''),
    );
    var selectedColor = existing?.avatarColor ?? _avatarPalette.first;
    var hasAvatar = existing?.hasAvatar ?? true;

    final result = await showDialog<_ReferenceUser>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existing == null ? 'Add friend' : 'Edit friend'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nickname'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: handleController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Avatar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Blank'),
                          selected: !hasAvatar,
                          onSelected: (_) {
                            setDialogState(() {
                              hasAvatar = false;
                            });
                          },
                        ),
                        ..._avatarPalette.map(
                          (color) => ChoiceChip(
                            label: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            selected: hasAvatar && selectedColor == color,
                            onSelected: (_) {
                              setDialogState(() {
                                hasAvatar = true;
                                selectedColor = color;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final normalizedName = nameController.text.trim();
                    final normalizedHandle = handleController.text.trim();
                    if (normalizedName.isEmpty || normalizedHandle.isEmpty) {
                      return;
                    }

                    Navigator.of(context).pop(
                      _ReferenceUser(
                        id:
                            existing?.id ??
                            'friend-${DateTime.now().microsecondsSinceEpoch}',
                        name: normalizedName,
                        handle: '@$normalizedHandle',
                        avatarColor: selectedColor,
                        hasAvatar: hasAvatar,
                        isFriend: true,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  }

  void _resetSearch({
    bool updateState = true,
    _SendStage nextStage = _SendStage.search,
  }) {
    void reset() {
      _stage = nextStage;
      _selectedUser = _friends.isNotEmpty ? _friends.first : _seedFriends.first;
      _showSuccessToast = false;
      _submittedSearchQuery = null;
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

List<_ReferenceUser> _searchUsers(
  String query,
  List<_ReferenceUser> friends, {
  bool includeSubmittedFallback = false,
}) {
  final trimmed = query.trim();
  final normalized = trimmed.toLowerCase();

  if (normalized.isEmpty) {
    return const [];
  }

  final friendMatches =
      friends.where((friend) {
        final searchable = '${friend.name} ${friend.handle}'.toLowerCase();
        return searchable.contains(normalized);
      }).toList();

  if (!includeSubmittedFallback) {
    return friendMatches;
  }

  final hasExactFriendMatch = friendMatches.any((friend) {
    final normalizedHandle = friend.handle.replaceFirst('@', '').toLowerCase();
    return friend.name.toLowerCase() == normalized ||
        normalizedHandle == normalized;
  });

  if (hasExactFriendMatch) {
    return friendMatches;
  }

  return [
    _ReferenceUser(
      id: 'search-$normalized',
      name: trimmed,
      handle: '@$normalized',
      avatarColor: const Color(0xFFE7EAF1),
      hasAvatar: false,
      isFriend: false,
    ),
    ...friendMatches,
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

String _formatCompactBalance(int balance) {
  if (balance >= 1000000) {
    final millions = balance / 1000000;
    final text =
        millions >= 10
            ? millions.toStringAsFixed(1)
            : millions.toStringAsPrecision(2);
    return '${text.replaceFirst(RegExp(r'\.?0+$'), '')}M';
  }

  if (balance >= 1000) {
    return _formatRobuxAmount('$balance');
  }

  return '$balance';
}

class _VideoAppSurface extends StatelessWidget {
  const _VideoAppSurface({
    required this.stage,
    required this.selectedUser,
    required this.friends,
    required this.robuxBalance,
    required this.usernameController,
    required this.amountController,
    required this.showResults,
    required this.submittedSearchQuery,
    required this.showSuccessToast,
    required this.onUserSelected,
    required this.onSearchSubmitted,
    required this.onAddFriendRequested,
    required this.onEditFriendRequested,
    required this.onDeleteFriendRequested,
    required this.onEditBalanceRequested,
    required this.onNext,
    required this.onSend,
    required this.onOpenSendDialog,
    required this.onClose,
    required this.onExit,
  });

  final _SendStage stage;
  final _ReferenceUser selectedUser;
  final List<_ReferenceUser> friends;
  final int robuxBalance;
  final TextEditingController usernameController;
  final TextEditingController amountController;
  final bool showResults;
  final String? submittedSearchQuery;
  final bool showSuccessToast;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onAddFriendRequested;
  final ValueChanged<_ReferenceUser> onEditFriendRequested;
  final ValueChanged<_ReferenceUser> onDeleteFriendRequested;
  final VoidCallback onEditBalanceRequested;
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
          RobuxHomePage(
            robuxBalance: robuxBalance,
            onSendPressed: onOpenSendDialog,
            onEditBalanceRequested: onEditBalanceRequested,
          ),
          if (stage != _SendStage.hidden)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.26)),
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
              left: _dialogInsets(stage).left,
              right: _dialogInsets(stage).right,
              top: _dialogInsets(stage).top,
              bottom: _dialogInsets(stage).bottom,
              child: _AnimatedDialogShell(
                stage: stage,
                child: _SendRobuxDialog(
                  stage: stage,
                  selectedUser: selectedUser,
                  friends: friends,
                  robuxBalance: robuxBalance,
                  usernameController: usernameController,
                  amountController: amountController,
                  showResults: showResults,
                  submittedSearchQuery: submittedSearchQuery,
                  onUserSelected: onUserSelected,
                  onSearchSubmitted: onSearchSubmitted,
                  onAddFriendRequested: onAddFriendRequested,
                  onEditFriendRequested: onEditFriendRequested,
                  onDeleteFriendRequested: onDeleteFriendRequested,
                  onEditBalanceRequested: onEditBalanceRequested,
                  onNext: onNext,
                  onSend: onSend,
                  onClose: onClose,
                  onExit: onExit,
                ),
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

  static _DialogInsets _dialogInsets(_SendStage stage) {
    switch (stage) {
      case _SendStage.search:
        return const _DialogInsets(left: 18, right: 18, top: 102, bottom: 0);
      case _SendStage.amount:
        return const _DialogInsets(left: 28, right: 28, top: 286, bottom: 384);
      case _SendStage.confirm:
        return const _DialogInsets(left: 28, right: 28, top: 314, bottom: 406);
      case _SendStage.hidden:
        return const _DialogInsets();
    }
  }
}

class _DialogInsets {
  const _DialogInsets({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
}

class _AnimatedDialogShell extends StatelessWidget {
  const _AnimatedDialogShell({required this.stage, required this.child});

  final _SendStage stage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (stage != _SendStage.search) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      key: const ValueKey('send-dialog-entry-animation'),
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Transform.translate(
          offset: Offset(0, value * 220),
          child: Opacity(opacity: 1 - (value * 0.18), child: animatedChild),
        );
      },
      child: child,
    );
  }
}

class _SendRobuxDialog extends StatelessWidget {
  const _SendRobuxDialog({
    required this.stage,
    required this.selectedUser,
    required this.friends,
    required this.robuxBalance,
    required this.usernameController,
    required this.amountController,
    required this.showResults,
    required this.submittedSearchQuery,
    required this.onUserSelected,
    required this.onSearchSubmitted,
    required this.onAddFriendRequested,
    required this.onEditFriendRequested,
    required this.onDeleteFriendRequested,
    required this.onEditBalanceRequested,
    required this.onNext,
    required this.onSend,
    required this.onClose,
    required this.onExit,
  });

  final _SendStage stage;
  final _ReferenceUser selectedUser;
  final List<_ReferenceUser> friends;
  final int robuxBalance;
  final TextEditingController usernameController;
  final TextEditingController amountController;
  final bool showResults;
  final String? submittedSearchQuery;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onAddFriendRequested;
  final ValueChanged<_ReferenceUser> onEditFriendRequested;
  final ValueChanged<_ReferenceUser> onDeleteFriendRequested;
  final VoidCallback onEditBalanceRequested;
  final VoidCallback onNext;
  final VoidCallback onSend;
  final VoidCallback onClose;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final isSearchStage = stage == _SendStage.search;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSearchStage ? 24 : 14,
        isSearchStage ? 20 : 13,
        isSearchStage ? 24 : 14,
        isSearchStage ? 28 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSearchStage ? 22 : 13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: isSearchStage ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DialogHeader(
            onClose: onClose,
            large: isSearchStage,
            robuxBalance: robuxBalance,
            onEditBalanceRequested: onEditBalanceRequested,
          ),
          SizedBox(height: isSearchStage ? 22 : 10),
          if (stage == _SendStage.search)
            Expanded(
              child: _SearchBody(
                controller: usernameController,
                friends: friends,
                showResults: showResults,
                submittedSearchQuery: submittedSearchQuery,
                onUserSelected: onUserSelected,
                onSearchSubmitted: onSearchSubmitted,
                onAddFriendRequested: onAddFriendRequested,
                onEditFriendRequested: onEditFriendRequested,
                onDeleteFriendRequested: onDeleteFriendRequested,
              ),
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
              robuxBalance: robuxBalance,
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
  const _DialogHeader({
    required this.onClose,
    required this.robuxBalance,
    required this.onEditBalanceRequested,
    this.large = false,
  });

  final VoidCallback onClose;
  final int robuxBalance;
  final VoidCallback onEditBalanceRequested;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final displayBalance =
        large
            ? _formatRobuxAmount('$robuxBalance')
            : _formatCompactBalance(robuxBalance);

    return Row(
      children: [
        _HeaderRobuxIcon(size: large ? 24 : 14, color: const Color(0xFF1E222B)),
        SizedBox(width: large ? 10 : 6),
        Expanded(
          child: Text(
            'Send Robux',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF1E222B),
              fontSize: large ? 28 : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: large ? 14 : 8),
        GestureDetector(
          key: const Key('dialog-balance-trigger'),
          behavior: HitTestBehavior.opaque,
          onSecondaryTap: onEditBalanceRequested,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderRobuxIcon(
                size: large ? 18 : 12,
                color: const Color(0xFF1E222B),
              ),
              SizedBox(width: large ? 9 : 4),
              Text(
                displayBalance,
                style: TextStyle(
                  color: const Color(0xFF1E222B),
                  fontSize: large ? 22 : 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: large ? 18 : 8),
        InkWell(
          key: const Key('close-dialog-button'),
          onTap: onClose,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: large ? 34 : 22,
            height: large ? 34 : 22,
            child: Center(
              child: Text(
                '×',
                style: TextStyle(
                  color: const Color(0xFF1E222B),
                  fontSize: large ? 24 : 14,
                  fontWeight: FontWeight.w500,
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
    required this.friends,
    required this.showResults,
    required this.submittedSearchQuery,
    required this.onUserSelected,
    required this.onSearchSubmitted,
    required this.onAddFriendRequested,
    required this.onEditFriendRequested,
    required this.onDeleteFriendRequested,
  });

  final TextEditingController controller;
  final List<_ReferenceUser> friends;
  final bool showResults;
  final String? submittedSearchQuery;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onAddFriendRequested;
  final ValueChanged<_ReferenceUser> onEditFriendRequested;
  final ValueChanged<_ReferenceUser> onDeleteFriendRequested;

  @override
  Widget build(BuildContext context) {
    final includeSubmittedFallback =
        submittedSearchQuery != null &&
        submittedSearchQuery == controller.text.trim();
    final results = _searchUsers(
      controller.text,
      friends,
      includeSubmittedFallback: includeSubmittedFallback,
    );
    final showFriendsEmpty = !showResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DialogTextField(
          key: const Key('username-input'),
          controller: controller,
          hintText: 'Search by username',
          onSubmitted: (_) => onSearchSubmitted(),
          large: true,
        ),
        const SizedBox(height: 34),
        if (showFriendsEmpty) ...[
          Text(
            'My friends (${friends.length})',
            style: const TextStyle(
              color: Color(0xFF454B5A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GestureDetector(
              key: const Key('friends-empty-zone'),
              behavior: HitTestBehavior.opaque,
              onSecondaryTapDown: (details) async {
                final overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final action = await showMenu<_FriendMenuAction>(
                  context: context,
                  position: RelativeRect.fromRect(
                    Rect.fromLTWH(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      0,
                      0,
                    ),
                    Offset.zero & overlay.size,
                  ),
                  items: const [
                    PopupMenuItem(
                      value: _FriendMenuAction.add,
                      child: Text('Add friend'),
                    ),
                  ],
                );
                if (action == _FriendMenuAction.add) {
                  onAddFriendRequested();
                }
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...friends.map(
                    (user) => _ResultRow(
                      user: user,
                      onTap: () => onUserSelected(user),
                      onEdit: () => onEditFriendRequested(user),
                      onDelete: () => onDeleteFriendRequested(user),
                    ),
                  ),
                  if (friends.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 42),
                      child: Center(
                        child: Text(
                          'No friends',
                          style: TextStyle(
                            color: Color(0xFF737987),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 360),
                ],
              ),
            ),
          ),
        ],
        if (showResults && results.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Color(0xFF737987),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (showResults && results.isNotEmpty)
          const Text(
            'Search results',
            style: TextStyle(
              color: Color(0xFF454B5A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        if (showResults && results.isNotEmpty) const SizedBox(height: 16),
        if (showResults && results.isNotEmpty)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children:
                  results
                      .map(
                        (user) => _ResultRow(
                          user: user,
                          onTap: () => onUserSelected(user),
                          onEdit:
                              user.isFriend
                                  ? () => onEditFriendRequested(user)
                                  : null,
                          onDelete:
                              user.isFriend
                                  ? () => onDeleteFriendRequested(user)
                                  : null,
                        ),
                      )
                      .toList(),
            ),
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
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final rawAmount = value.text.trim();
        final hasAmount = rawAmount.isNotEmpty;
        final displayAmount = _formatRobuxAmount(rawAmount);

        return Column(
          children: [
            _SelectedUserHeader(user: selectedUser, amountText: displayAmount),
            const SizedBox(height: 18),
            _AmountEntryField(controller: controller),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _AmountPill(
                    label: '25',
                    onTap: () => controller.text = '25',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _AmountPill(
                    label: '50',
                    onTap: () => controller.text = '50',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _AmountPill(
                    label: '100',
                    onTap: () => controller.text = '100',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _AmountPill(
                    label: '200',
                    onTap: () => controller.text = '200',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ActionButton(
              key: const Key('amount-next-button'),
              label: 'Next',
              enabled: hasAmount,
              onTap: onNext,
              height: 48,
              fontSize: 18,
              borderRadius: 12,
            ),
          ],
        );
      },
    );
  }
}

class _ConfirmBody extends StatelessWidget {
  const _ConfirmBody({
    required this.amount,
    required this.robuxBalance,
    required this.selectedUser,
    required this.onSend,
    required this.onExit,
  });

  final String amount;
  final int robuxBalance;
  final _ReferenceUser selectedUser;
  final VoidCallback onSend;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final displayAmount = _formatRobuxAmount(amount);
    final parsedAmount = int.tryParse(amount.replaceAll(',', '')) ?? 0;
    final hasEnoughBalance = parsedAmount > 0 && parsedAmount <= robuxBalance;
    final shortfall =
        parsedAmount > robuxBalance ? parsedAmount - robuxBalance : 0;

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
        const SizedBox(height: 8),
        Text(
          hasEnoughBalance
              ? 'Balance after send: ${_formatRobuxAmount('${robuxBalance - parsedAmount}')}'
              : 'Need ${_formatRobuxAmount('$shortfall')} more Robux',
          style: TextStyle(
            color:
                hasEnoughBalance
                    ? const Color(0xFF6E7587)
                    : const Color(0xFFD14C4C),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                key: const Key('confirm-send-button'),
                label: 'Send',
                enabled: hasEnoughBalance,
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
    this.onSubmitted,
    this.large = false,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large ? 76 : 34,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: const Color(0xFF1B1F2A),
          fontSize: large ? 26 : 12,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF77809A),
            fontSize: large ? 26 : 12,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: large ? 24 : 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(large ? 16 : 7),
            borderSide: BorderSide(
              color: const Color(0xFF3E61F1),
              width: large ? 2.2 : 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(large ? 16 : 7),
            borderSide: BorderSide(
              color: const Color(0xFF3E61F1),
              width: large ? 2.6 : 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountEntryField extends StatelessWidget {
  const _AmountEntryField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FD),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('amount-input'),
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Color(0xFF1B1F2A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(
                  color: Color(0xFF7A8294),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.unfold_more_rounded,
            size: 16,
            color: Color(0xFF6F7788),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.user,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final _ReferenceUser user;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('friend-row-${user.id}'),
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) async {
        if (onEdit == null && onDelete == null) {
          return;
        }

        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final action = await showMenu<_FriendMenuAction>(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(
              details.globalPosition.dx,
              details.globalPosition.dy,
              0,
              0,
            ),
            Offset.zero & overlay.size,
          ),
          items: const [
            PopupMenuItem(
              value: _FriendMenuAction.edit,
              child: Text('Edit friend'),
            ),
            PopupMenuItem(
              value: _FriendMenuAction.delete,
              child: Text('Delete friend'),
            ),
          ],
        );

        if (action == _FriendMenuAction.edit) {
          onEdit?.call();
        }
        if (action == _FriendMenuAction.delete) {
          onDelete?.call();
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: Color(0xFF171B24),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                user.handle,
                style: const TextStyle(
                  color: Color(0xFF7B8190),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedUserHeader extends StatelessWidget {
  const _SelectedUserHeader({
    required this.user,
    this.showMeta = false,
    this.amountText,
  });

  final _ReferenceUser user;
  final bool showMeta;
  final String? amountText;

  @override
  Widget build(BuildContext context) {
    final amountLabel =
        amountText == null || amountText == '0' ? '0' : amountText!;

    return Column(
      children: [
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF171B24),
            fontSize: showMeta ? 14 : 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (!showMeta) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _HeaderRobuxIcon(size: 12, color: Color(0xFF555D70)),
              const SizedBox(width: 6),
              Text(
                amountLabel,
                style: const TextStyle(
                  color: Color(0xFF555D70),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
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
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FC),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _HeaderRobuxIcon(size: 12, color: Color(0xFF252A35)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF252A35),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
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

class _HeaderRobuxIcon extends StatelessWidget {
  const _HeaderRobuxIcon({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HeaderRobuxIconPainter(color: color, strokeWidth: size * 0.1),
      ),
    );
  }
}

class _HeaderRobuxIconPainter extends CustomPainter {
  const _HeaderRobuxIconPainter({
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
      final angle = (-3.141592653589793 / 2) + (index * 3.141592653589793 / 3);
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
  bool shouldRepaint(covariant _HeaderRobuxIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.enabled,
    this.onTap,
    this.height = 34,
    this.fontSize = 11,
    this.borderRadius = 7,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final double height;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF5A43F1) : const Color(0xFFE1E3EA),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : const Color(0xFF9AA0AD),
            fontSize: fontSize,
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

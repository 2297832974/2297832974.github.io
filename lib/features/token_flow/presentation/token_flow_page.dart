import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'widgets/adaptive_action_menu.dart';
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
  List<_ReferenceUser> _submittedSearchResults = const [];

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shouldFillViewport = constraints.maxWidth < 700;

            if (shouldFillViewport) {
              return SizedBox.expand(child: _buildVideoSurface());
            }

            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 592,
                  height: 1280,
                  child: _buildVideoSurface(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoSurface() {
    return _VideoAppSurface(
      stage: _stage,
      selectedUser: _selectedUser,
      friends: _friends,
      robuxBalance: _robuxBalance,
      usernameController: _usernameController,
      amountController: _amountController,
      showResults: _showResults,
      submittedSearchQuery: _hasCommittedSearch ? _submittedSearchQuery : null,
      submittedSearchResults: _submittedSearchResults,
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
      _submittedSearchResults = _buildSubmittedSearchResults(query, _friends);
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
      _submittedSearchResults = const [];
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
      _submittedSearchResults = const [];
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

List<_ReferenceUser> _searchUsers(String query, List<_ReferenceUser> friends) {
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

  return friendMatches;
}

List<_ReferenceUser> _buildSubmittedSearchResults(
  String query,
  List<_ReferenceUser> friends,
) {
  final trimmed = query.trim();
  final normalized = trimmed.toLowerCase();

  if (normalized.isEmpty) {
    return const [];
  }

  final random = math.Random();
  final totalCount = random.nextInt(20) + 1;
  final friendMatches = _searchUsers(trimmed, friends);
  final hasExactFriendMatch = friendMatches.any((friend) {
    final normalizedHandle = friend.handle.replaceFirst('@', '').toLowerCase();
    return friend.name.toLowerCase() == normalized ||
        normalizedHandle == normalized;
  });

  final topMatch =
      hasExactFriendMatch
          ? friendMatches.firstWhere((friend) {
            final normalizedHandle =
                friend.handle.replaceFirst('@', '').toLowerCase();
            return friend.name.toLowerCase() == normalized ||
                normalizedHandle == normalized;
          })
          : _ReferenceUser(
            id: 'search-$normalized',
            name: trimmed,
            handle: '@$normalized',
            avatarColor: const Color(0xFFE7EAF1),
            hasAvatar: false,
            isFriend: false,
          );

  final results = <_ReferenceUser>[topMatch];
  final usedIds = <String>{topMatch.id};

  for (final friend in friendMatches) {
    if (results.length >= totalCount) {
      break;
    }
    if (usedIds.add(friend.id)) {
      results.add(friend);
    }
  }

  while (results.length < totalCount) {
    final suffix = random.nextInt(9000) + 1000;
    final baseName = _randomSearchName(random);
    final candidateName = '$trimmed$baseName$suffix';
    final candidate = _ReferenceUser(
      id: 'search-$normalized-$suffix-${results.length}',
      name: candidateName,
      handle: '@${candidateName.toLowerCase()}',
      avatarColor: _avatarPalette[random.nextInt(_avatarPalette.length)],
      hasAvatar: false,
      isFriend: false,
    );

    if (usedIds.add(candidate.id)) {
      results.add(candidate);
    }
  }

  return results;
}

String _randomSearchName(math.Random random) {
  const parts = [
    'Galaxy',
    'Nova',
    'Trade',
    'Builder',
    'Boost',
    'Pixel',
    'Quest',
    'Storm',
    'Ultra',
    'Vault',
  ];
  return parts[random.nextInt(parts.length)];
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
    required this.submittedSearchResults,
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
  final List<_ReferenceUser> submittedSearchResults;
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
    final isCompact = MediaQuery.sizeOf(context).width < 430;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(isCompact ? 0 : 18),
        border: isCompact ? null : Border.all(color: const Color(0xFF1A1A1A)),
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
            _DialogOverlay(
              stage: stage,
              selectedUser: selectedUser,
              friends: friends,
              robuxBalance: robuxBalance,
              usernameController: usernameController,
              amountController: amountController,
              showResults: showResults,
              submittedSearchQuery: submittedSearchQuery,
              submittedSearchResults: submittedSearchResults,
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
}

class _DialogOverlay extends StatelessWidget {
  const _DialogOverlay({
    required this.stage,
    required this.selectedUser,
    required this.friends,
    required this.robuxBalance,
    required this.usernameController,
    required this.amountController,
    required this.showResults,
    required this.submittedSearchQuery,
    required this.submittedSearchResults,
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
  final List<_ReferenceUser> submittedSearchResults;
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
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    final horizontalInset = isCompact ? 16.0 : 0.0;
    final searchTopPadding = isCompact ? 316.0 : 360.0;
    final searchMaxHeight = isCompact ? 432.0 : 520.0;

    final dialog = _SendRobuxDialog(
      stage: stage,
      selectedUser: selectedUser,
      friends: friends,
      robuxBalance: robuxBalance,
      usernameController: usernameController,
      amountController: amountController,
      showResults: showResults,
      submittedSearchQuery: submittedSearchQuery,
      submittedSearchResults: submittedSearchResults,
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
    );

    if (stage == _SendStage.search) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: searchTopPadding,
              left: horizontalInset,
              right: horizontalInset,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 470,
                maxHeight: searchMaxHeight,
              ),
              child: _AnimatedDialogShell(stage: stage, child: dialog),
            ),
          ),
        ),
      );
    }

    final topPadding =
        stage == _SendStage.amount
            ? (isCompact ? 360.0 : 390.0)
            : (isCompact ? 386.0 : 420.0);

    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            left: horizontalInset,
            right: horizontalInset,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: dialog,
          ),
        ),
      ),
    );
  }
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
    required this.submittedSearchResults,
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
  final List<_ReferenceUser> submittedSearchResults;
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
    final isCompact = MediaQuery.sizeOf(context).width < 430;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSearchStage ? (isCompact ? 14 : 18) : (isCompact ? 12 : 14),
        isSearchStage ? (isCompact ? 14 : 16) : (isCompact ? 12 : 13),
        isSearchStage ? (isCompact ? 14 : 18) : (isCompact ? 12 : 14),
        isSearchStage ? (isCompact ? 14 : 18) : (isCompact ? 12 : 14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          isSearchStage ? (isCompact ? 18 : 20) : (isCompact ? 12 : 13),
        ),
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
          _DialogHeader(
            onClose: onClose,
            large: false,
            robuxBalance: robuxBalance,
            onEditBalanceRequested: onEditBalanceRequested,
          ),
          SizedBox(height: isSearchStage ? (isCompact ? 10 : 14) : 8),
          if (stage == _SendStage.search)
            Expanded(
              child: _SearchBody(
                controller: usernameController,
                friends: friends,
                showResults: showResults,
                submittedSearchQuery: submittedSearchQuery,
                submittedSearchResults: submittedSearchResults,
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
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    final enableSecondaryTap = supportsDesktopSecondaryActions(context);
    final displayBalance =
        large
            ? _formatRobuxAmount('$robuxBalance')
            : _formatCompactBalance(robuxBalance);

    return Row(
      children: [
        _HeaderRobuxIcon(
          size: large ? 24 : (isCompact ? 13 : 14),
          color: const Color(0xFF1E222B),
        ),
        SizedBox(width: large ? 10 : (isCompact ? 5 : 6)),
        Expanded(
          child: Text(
            'Send Robux',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF1E222B),
              fontSize: large ? 28 : (isCompact ? 16 : 18),
              fontWeight: large ? FontWeight.w900 : FontWeight.w800,
              letterSpacing: large ? -0.4 : -0.2,
              height: 1.05,
            ),
          ),
        ),
        SizedBox(width: large ? 14 : (isCompact ? 6 : 8)),
        GestureDetector(
          key: const Key('dialog-balance-trigger'),
          behavior: HitTestBehavior.opaque,
          onSecondaryTap: enableSecondaryTap ? onEditBalanceRequested : null,
          onLongPress: onEditBalanceRequested,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderRobuxIcon(
                size: large ? 18 : (isCompact ? 11 : 12),
                color: const Color(0xFF1E222B),
              ),
              SizedBox(width: large ? 9 : (isCompact ? 3 : 4)),
              Text(
                displayBalance,
                style: TextStyle(
                  color: const Color(0xFF1E222B),
                  fontSize: large ? 22 : (isCompact ? 11 : 12),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: large ? 18 : (isCompact ? 6 : 8)),
        InkWell(
          key: const Key('close-dialog-button'),
          onTap: onClose,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: large ? 34 : (isCompact ? 20 : 22),
            height: large ? 34 : (isCompact ? 20 : 22),
            child: Center(
              child: Text(
                '×',
                style: TextStyle(
                  color: const Color(0xFF1E222B),
                  fontSize: large ? 24 : (isCompact ? 13 : 14),
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
    required this.submittedSearchResults,
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
  final List<_ReferenceUser> submittedSearchResults;
  final ValueChanged<_ReferenceUser> onUserSelected;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onAddFriendRequested;
  final ValueChanged<_ReferenceUser> onEditFriendRequested;
  final ValueChanged<_ReferenceUser> onDeleteFriendRequested;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    final enableSecondaryTap = supportsDesktopSecondaryActions(context);
    final useSubmittedResults =
        submittedSearchQuery != null &&
        submittedSearchQuery == controller.text.trim();
    final results =
        useSubmittedResults
            ? submittedSearchResults
            : _searchUsers(controller.text, friends);
    final showFriendsEmpty = !showResults;
    final sectionTitle =
        showFriendsEmpty
            ? 'My friends (${friends.length})'
            : 'Search results (${results.length})';
    final scrollItems =
        showFriendsEmpty
            ? friends
                .map(
                  (user) => _ResultRow(
                    user: user,
                    compact: true,
                    onTap: () => onUserSelected(user),
                    onEdit: () => onEditFriendRequested(user),
                    onDelete: () => onDeleteFriendRequested(user),
                  ),
                )
                .toList()
            : results
                .map(
                  (user) => _ResultRow(
                    user: user,
                    compact: true,
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
                .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DialogTextField(
          key: const Key('username-input'),
          controller: controller,
          hintText: 'Search by username',
          onSubmitted: (_) => onSearchSubmitted(),
          large: false,
          compact: isCompact,
        ),
        SizedBox(height: isCompact ? 10 : 14),
        Text(
          sectionTitle,
          style: TextStyle(
            color: const Color(0xFF454B5A),
            fontSize: isCompact ? 11 : 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: isCompact ? 8 : 10),
        Expanded(
          child: GestureDetector(
            key: const Key('friends-empty-zone'),
            behavior: HitTestBehavior.opaque,
            onLongPress: showFriendsEmpty ? onAddFriendRequested : null,
            onSecondaryTapDown:
                showFriendsEmpty && enableSecondaryTap
                    ? (details) async {
                      final action =
                          await showAdaptiveActionMenu<_FriendMenuAction>(
                            context,
                            globalPosition: details.globalPosition,
                            title: 'Friends',
                            items: const [
                              AdaptiveActionItem(
                                value: _FriendMenuAction.add,
                                label: 'Add friend',
                                icon: Icons.person_add_alt_1_rounded,
                              ),
                            ],
                          );
                      if (action == _FriendMenuAction.add) {
                        onAddFriendRequested();
                      }
                    }
                    : null,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FC),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.symmetric(
                vertical: isCompact ? 8 : 10,
                horizontal: isCompact ? 8 : 10,
              ),
              child:
                  scrollItems.isEmpty
                      ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(
                            color: Color(0xFF737987),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      : Stack(
                        children: [
                          ListView(
                            primary: false,
                            padding: EdgeInsets.only(
                              right: isCompact ? 14 : 18,
                            ),
                            children: scrollItems,
                          ),
                          if (scrollItems.length > 5)
                            Positioned(
                              top: 14,
                              right: 4,
                              bottom: 18,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 6,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6E6E73),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 14,
                                    color: Color(0xFF7C7C82),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
            ),
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
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final rawAmount = value.text.trim();
        final hasAmount = rawAmount.isNotEmpty;
        final displayAmount = _formatRobuxAmount(rawAmount);

        return Column(
          children: [
            _SelectedUserHeader(user: selectedUser, amountText: displayAmount),
            SizedBox(height: isCompact ? 14 : 18),
            _AmountEntryField(controller: controller, compact: isCompact),
            SizedBox(height: isCompact ? 12 : 14),
            Row(
              children: [
                Expanded(
                  child: _AmountPill(
                    label: '1000',
                    onTap: () => controller.text = '1000',
                    compact: isCompact,
                  ),
                ),
                SizedBox(width: isCompact ? 6 : 9),
                Expanded(
                  child: _AmountPill(
                    label: '2000',
                    onTap: () => controller.text = '2000',
                    compact: isCompact,
                  ),
                ),
                SizedBox(width: isCompact ? 6 : 9),
                Expanded(
                  child: _AmountPill(
                    label: '5000',
                    onTap: () => controller.text = '5000',
                    compact: isCompact,
                  ),
                ),
                SizedBox(width: isCompact ? 6 : 9),
                Expanded(
                  child: _AmountPill(
                    label: '10000',
                    onTap: () => controller.text = '10000',
                    compact: isCompact,
                  ),
                ),
              ],
            ),
            SizedBox(height: isCompact ? 12 : 16),
            _ActionButton(
              key: const Key('amount-next-button'),
              label: 'Next',
              enabled: hasAmount,
              onTap: onNext,
              height: isCompact ? 44 : 48,
              fontSize: isCompact ? 16 : 18,
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
    this.compact = false,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final bool large;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large ? 76 : (compact ? 30 : 34),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: const Color(0xFF1B1F2A),
          fontSize: large ? 26 : (compact ? 11 : 12),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF77809A),
            fontSize: large ? 26 : (compact ? 11 : 12),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: large ? 24 : (compact ? 9 : 10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(large ? 16 : (compact ? 8 : 7)),
            borderSide: BorderSide(
              color: const Color(0xFF3E61F1),
              width: large ? 2.2 : (compact ? 1.1 : 1.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(large ? 16 : (compact ? 8 : 7)),
            borderSide: BorderSide(
              color: const Color(0xFF3E61F1),
              width: large ? 2.6 : (compact ? 1.3 : 1.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountEntryField extends StatelessWidget {
  const _AmountEntryField({required this.controller, required this.compact});

  final TextEditingController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 38 : 42,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 14),
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
          SizedBox(width: compact ? 8 : 10),
          Icon(
            Icons.unfold_more_rounded,
            size: compact ? 14 : 16,
            color: const Color(0xFF6F7788),
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
    this.compact = false,
    this.onEdit,
    this.onDelete,
  });

  final _ReferenceUser user;
  final VoidCallback onTap;
  final bool compact;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final enableSecondaryTap = supportsDesktopSecondaryActions(context);

    Future<void> showActions([Offset? globalPosition]) async {
      if (onEdit == null && onDelete == null) {
        return;
      }

      final action = await showAdaptiveActionMenu<_FriendMenuAction>(
        context,
        globalPosition: globalPosition,
        title: user.name,
        items: [
          if (onEdit != null)
            const AdaptiveActionItem(
              value: _FriendMenuAction.edit,
              label: 'Edit friend',
              icon: Icons.edit_rounded,
            ),
          if (onDelete != null)
            const AdaptiveActionItem(
              value: _FriendMenuAction.delete,
              label: 'Delete friend',
              icon: Icons.delete_outline_rounded,
              isDestructive: true,
            ),
        ],
      );

      if (action == _FriendMenuAction.edit) {
        onEdit?.call();
      }
      if (action == _FriendMenuAction.delete) {
        onDelete?.call();
      }
    }

    return GestureDetector(
      key: Key('friend-row-${user.id}'),
      behavior: HitTestBehavior.opaque,
      onLongPress:
          onEdit != null || onDelete != null ? () => showActions() : null,
      onSecondaryTapDown:
          enableSecondaryTap
              ? (details) async {
                await showActions(details.globalPosition);
              }
              : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(bottom: compact ? 10 : 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        color: const Color(0xFF171B24),
                        fontSize: compact ? 12 : 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      user.handle,
                      style: TextStyle(
                        color: const Color(0xFF7B8190),
                        fontSize: compact ? 11 : 14,
                        fontWeight: compact ? FontWeight.w500 : FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ],
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
  const _AmountPill({
    required this.label,
    required this.onTap,
    required this.compact,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: compact ? 48 : 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 5 : 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HeaderRobuxIcon(
                  size: compact ? 11 : 13,
                  color: const Color(0xFF252A35),
                ),
                SizedBox(width: compact ? 4 : 6),
                Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF252A35),
                    fontSize: compact ? 11 : 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
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

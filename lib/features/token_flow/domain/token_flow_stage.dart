enum TokenFlowStage { search, results, amount, confirm }

extension TokenFlowStageX on TokenFlowStage {
  String get title {
    switch (this) {
      case TokenFlowStage.search:
        return 'Search Entry';
      case TokenFlowStage.results:
        return 'User Selection';
      case TokenFlowStage.amount:
        return 'Amount Input';
      case TokenFlowStage.confirm:
        return 'Confirmation';
    }
  }

  String get description {
    switch (this) {
      case TokenFlowStage.search:
        return 'Open the send dialog, focus the input, and guide the user into the lookup flow.';
      case TokenFlowStage.results:
        return 'Show matching accounts in a focused list so the user can choose the right profile fast.';
      case TokenFlowStage.amount:
        return 'Support quick chips and custom amount editing without losing context about the target user.';
      case TokenFlowStage.confirm:
        return 'Summarize the chosen account and amount with a single primary action and a safe exit.';
    }
  }

  String get assetPath {
    switch (this) {
      case TokenFlowStage.search:
        return 'assets/images/token-frames/02-input-focus.jpg';
      case TokenFlowStage.results:
        return 'assets/images/token-frames/07-search-results.jpg';
      case TokenFlowStage.amount:
        return 'assets/images/token-frames/10-amount-editing.jpg';
      case TokenFlowStage.confirm:
        return 'assets/images/token-frames/12-confirmation.jpg';
    }
  }

  List<String> get focusItems {
    switch (this) {
      case TokenFlowStage.search:
        return const [
          'Pinned modal card',
          'Single-line username field',
          'Helper copy for search feedback',
        ];
      case TokenFlowStage.results:
        return const [
          'Scrollable result rows',
          'Avatar plus display name pairing',
          'Tap target for selecting one account',
        ];
      case TokenFlowStage.amount:
        return const [
          'Quick amount chips',
          'Editable numeric field',
          'Primary button enabled state',
        ];
      case TokenFlowStage.confirm:
        return const [
          'Profile summary header',
          'Large amount readout',
          'Primary and secondary actions',
        ];
    }
  }
}

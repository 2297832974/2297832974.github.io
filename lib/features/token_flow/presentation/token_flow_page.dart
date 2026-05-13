import 'package:flutter/material.dart';

import '../domain/token_flow_stage.dart';
import 'widgets/reference_gallery.dart';
import 'widgets/token_mock_phone.dart';

class TokenFlowPage extends StatefulWidget {
  const TokenFlowPage({super.key});

  @override
  State<TokenFlowPage> createState() => _TokenFlowPageState();
}

class _TokenFlowPageState extends State<TokenFlowPage> {
  TokenFlowStage _selectedStage = TokenFlowStage.search;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token Buy Flow Workspace',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This baseline turns the 12 extracted frames into a buildable flow map so we can implement the app in clean stages instead of guessing from the video each time.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      wide
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: _StagePlanPanel(
                                  selectedStage: _selectedStage,
                                  onStageSelected: _handleStageSelected,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 4,
                                child: TokenMockPhone(stage: _selectedStage),
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              _StagePlanPanel(
                                selectedStage: _selectedStage,
                                onStageSelected: _handleStageSelected,
                              ),
                              const SizedBox(height: 24),
                              TokenMockPhone(stage: _selectedStage),
                            ],
                          ),
                      const SizedBox(height: 24),
                      const ReferenceGallery(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleStageSelected(TokenFlowStage stage) {
    setState(() {
      _selectedStage = stage;
    });
  }
}

class _StagePlanPanel extends StatelessWidget {
  const _StagePlanPanel({
    required this.selectedStage,
    required this.onStageSelected,
  });

  final TokenFlowStage selectedStage;
  final ValueChanged<TokenFlowStage> onStageSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build Sequence', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Use these four stages as the implementation backbone. Each stage maps to multiple reference frames, but keeps the code surface compact.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            for (final stage in TokenFlowStage.values) ...[
              _StageTile(
                stage: stage,
                selected: stage == selectedStage,
                onTap: () => onStageSelected(stage),
              ),
              if (stage != TokenFlowStage.values.last)
                const SizedBox(height: 12),
            ],
            const SizedBox(height: 24),
            Text(
              'Current Focus Components',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  selectedStage.focusItems
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF181B24),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF232634)),
                          ),
                          child: Text(item, style: theme.textTheme.bodyMedium),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.stage,
    required this.selected,
    required this.onTap,
  });

  final TokenFlowStage stage;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF171C34) : const Color(0xFF0D1016),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    selected
                        ? theme.colorScheme.primary
                        : const Color(0xFF181B24),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${stage.index + 1}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stage.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(stage.description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

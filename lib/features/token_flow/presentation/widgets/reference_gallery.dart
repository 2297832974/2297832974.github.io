import 'package:flutter/material.dart';

class ReferenceGallery extends StatelessWidget {
  const ReferenceGallery({super.key});

  static const _frames = [
    'assets/images/token-frames/01-dialog-initial.jpg',
    'assets/images/token-frames/02-input-focus.jpg',
    'assets/images/token-frames/03-typing-start.jpg',
    'assets/images/token-frames/04-typing-mid.jpg',
    'assets/images/token-frames/05-typing-complete.jpg',
    'assets/images/token-frames/06-base-page.jpg',
    'assets/images/token-frames/07-search-results.jpg',
    'assets/images/token-frames/08-user-selected.jpg',
    'assets/images/token-frames/09-amount-default.jpg',
    'assets/images/token-frames/10-amount-editing.jpg',
    'assets/images/token-frames/11-amount-filled.jpg',
    'assets/images/token-frames/12-confirmation.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reference Frames', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Keep the extracted frames visible while building widgets so visual drift stays small.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _frames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                final frame = _frames[index];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(frame, fit: BoxFit.cover),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

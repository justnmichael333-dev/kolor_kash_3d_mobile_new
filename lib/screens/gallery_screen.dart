import 'package:flutter/material.dart';

/// Shows a placeholder grid of saved 3D pieces.
/// Later this will be backed by real user artwork.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For now, just a fixed list of "pieces".
    final List<_MockPiece> mockPieces = <_MockPiece>[
      const _MockPiece(title: 'Neon Cube', kashesEarned: 15),
      const _MockPiece(title: 'Hologram Skull', kashesEarned: 30),
      const _MockPiece(title: 'Cyber City', kashesEarned: 50),
      const _MockPiece(title: 'Retro Bot', kashesEarned: 20),
      const _MockPiece(title: 'Chrome Dragon', kashesEarned: 75),
      const _MockPiece(title: 'Pixel Phoenix', kashesEarned: 40),
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: mockPieces.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (BuildContext context, int index) {
          final _MockPiece piece = mockPieces[index];
          return _GalleryCard(piece: piece);
        },
      ),
    );
  }
}

class _MockPiece {
  final String title;
  final int kashesEarned;

  const _MockPiece({
    required this.title,
    required this.kashesEarned,
  });
}

class _GalleryCard extends StatelessWidget {
  final _MockPiece piece;

  const _GalleryCard({
    Key? key,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colorful gradient background to suggest art.
    final Gradient gradient = LinearGradient(
      colors: <Color>[
        Theme.of(context).colorScheme.primary.withOpacity(0.8),
        Theme.of(context).colorScheme.secondary.withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Later: open full-screen view + share / NFT / stats.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Preview for "${piece.title}" coming soon…'),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: const Center(
                  child: Icon(
                    Icons.view_in_ar_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    piece.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+${piece.kashesEarned} Kashes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
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

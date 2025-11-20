import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class ColorPacksScreen extends StatefulWidget {
  const ColorPacksScreen({super.key});

  @override
  State<ColorPacksScreen> createState() => _ColorPacksScreenState();
}

class _ColorPacksScreenState extends State<ColorPacksScreen> {
  final List<ColorPack> _colorPacks = [
    ColorPack(
      id: 'basic_pack',
      name: 'Basic Collection',
      description: '12 essential colors for beginners',
      price: 0,
      colorCount: 12,
      isPremium: false,
      isUnlocked: true,
      thumbnail: '🎨',
    ),
    ColorPack(
      id: 'nature_pack',
      name: 'Nature Palette',
      description: 'Earth tones and natural colors',
      price: 50,
      colorCount: 20,
      isPremium: false,
      isUnlocked: false,
      thumbnail: '🌿',
    ),
    ColorPack(
      id: 'neon_pack',
      name: 'Neon Dreams',
      description: 'Vibrant neon colors',
      price: 100,
      colorCount: 24,
      isPremium: true,
      isUnlocked: false,
      thumbnail: '⚡',
    ),
    ColorPack(
      id: 'pastel_pack',
      name: 'Pastel Paradise',
      description: 'Soft and gentle pastel colors',
      price: 75,
      colorCount: 18,
      isPremium: false,
      isUnlocked: false,
      thumbnail: '🦄',
    ),
    ColorPack(
      id: 'metallic_pack',
      name: 'Metallic Shine',
      description: 'Gold, silver, and metallic colors',
      price: 150,
      colorCount: 16,
      isPremium: true,
      isUnlocked: false,
      thumbnail: '✨',
    ),
    ColorPack(
      id: 'ocean_pack',
      name: 'Ocean Depths',
      description: 'Blues and aquatic colors',
      price: 60,
      colorCount: 22,
      isPremium: false,
      isUnlocked: false,
      thumbnail: '🌊',
    ),
  ];

  Future<void> _unlockPack(ColorPack pack) async {
    if (pack.isUnlocked) {
      _showPackDetails(pack);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unlock Pack?'),
        content: Text(
          pack.price == 0
              ? 'Get this pack for free!'
              : 'Unlock this pack for ${pack.price} Kashes?',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('UNLOCK'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Deduct Kashes and unlock pack
      setState(() {
        pack.isUnlocked = true;
      });

      await AnalyticsService.logEvent('color_pack_unlocked', params: {
        'pack_id': pack.id,
        'pack_name': pack.name,
        'price': pack.price,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pack.name} unlocked! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showPackDetails(ColorPack pack) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  pack.thumbnail,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  pack.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  pack.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Color Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: pack.colorCount,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _getRandomColor(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRandomColor(int seed) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
    ];
    return colors[seed % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Packs'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unlock New Colors',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expand your palette with premium color packs',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.palette, size: 48),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Color Packs Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _colorPacks.length,
              itemBuilder: (context, index) {
                final pack = _colorPacks[index];
                return _buildColorPackCard(pack);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPackCard(ColorPack pack) {
    return InkWell(
      onTap: () => _unlockPack(pack),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: pack.isPremium
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thumbnail
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        pack.thumbnail,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),

                // Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pack.colorCount} colors',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (pack.price == 0)
                            const Chip(
                              label: Text(
                                'FREE',
                                style: TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          else
                            Text(
                              '${pack.price} 💰',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (pack.isUnlocked)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          else
                            const Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 20,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Premium Badge
            if (pack.isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ColorPack {
  final String id;
  final String name;
  final String description;
  final int price;
  final int colorCount;
  final bool isPremium;
  bool isUnlocked;
  final String thumbnail;

  ColorPack({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.colorCount,
    required this.isPremium,
    required this.isUnlocked,
    required this.thumbnail,
  });
}

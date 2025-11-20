import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/kashes_service.dart';
import '../widgets/color_3d_canvas.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  bool _isColoring = false;
  String? _currentModelId;

  @override
  void initState() {
    super.initState();
    _loadDefaultModel();
  }

  Future<void> _loadDefaultModel() async {
    setState(() {
      _currentModelId = 'sample_model_1';
    });
  }

  Future<void> _startColoring() async {
    setState(() {
      _isColoring = true;
    });

    // Log analytics event
    await AnalyticsService.logEvent('coloring_started', params: {
      'model_id': _currentModelId ?? 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _saveArtwork() async {
    // Save the colored artwork
    await KashesService.rewardForCompletion(10);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎨 Artwork saved! +10 Kashes earned'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Studio'),
        elevation: 0,
        actions: [
          if (_isColoring)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveArtwork,
              tooltip: 'Save Artwork',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDefaultModel,
            tooltip: 'New Model',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.monetization_on,
                  label: 'Kashes',
                  value: '1,250',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '7 days',
                  color: Colors.orange,
                ),
                _buildStatItem(
                  icon: Icons.brush,
                  label: 'Artworks',
                  value: '23',
                  color: Colors.purple,
                ),
              ],
            ),
          ),

          // 3D Canvas
          Expanded(
            child: Center(
              child: _currentModelId != null
                  ? Color3DCanvas(
                      modelId: _currentModelId!,
                      onColoringStart: _startColoring,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),

          // Color Palette
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color Palette',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final colors = [
                        Colors.red,
                        Colors.pink,
                        Colors.purple,
                        Colors.blue,
                        Colors.cyan,
                        Colors.teal,
                        Colors.green,
                        Colors.lime,
                        Colors.yellow,
                        Colors.orange,
                        Colors.brown,
                        Colors.grey,
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            // Select color logic
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors[index].withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

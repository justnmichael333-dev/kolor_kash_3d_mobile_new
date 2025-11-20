import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/pvp_service.dart';

class PvPScreen extends StatefulWidget {
  const PvPScreen({super.key});

  @override
  State<PvPScreen> createState() => _PvPScreenState();
}

class _PvPScreenState extends State<PvPScreen> {
  bool _isSearching = false;
  String? _currentMatchId;

  Future<void> _findMatch() async {
    setState(() {
      _isSearching = true;
    });

    try {
      // Log analytics
      await AnalyticsService.logEvent('pvp_match_started');

      // Simulate matchmaking
      final matchId = await PvPService.findMatch();

      setState(() {
        _currentMatchId = matchId;
        _isSearching = false;
      });

      if (mounted) {
        _showMatchFoundDialog();
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error finding match: $e')),
        );
      }
    }
  }

  void _showMatchFoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎮 Match Found!'),
        content: const Text('Prepare to battle with your coloring skills!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startMatch();
            },
            child: const Text('START BATTLE'),
          ),
        ],
      ),
    );
  }

  Future<void> _startMatch() async {
    // Navigate to PvP coloring battle
    // This would be a full screen with both players' progress
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PvP Battle Arena'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PvP Stats Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Your PvP Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Wins', '45', Colors.green),
                        _buildStatColumn('Losses', '12', Colors.red),
                        _buildStatColumn('Win Rate', '78%', Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Rank', '#247', Colors.purple),
                        _buildStatColumn('Trophies', '2,340', Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Find Match Button
            if (!_isSearching && _currentMatchId == null)
              ElevatedButton(
                onPressed: _findMatch,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'FIND MATCH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Searching indicator
            if (_isSearching)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Finding opponent...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Recent Matches
            Text(
              'Recent Matches',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            ...List.generate(5, (index) {
              final isWin = index % 2 == 0;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isWin ? Colors.green : Colors.red,
                    child: Icon(
                      isWin ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('vs Player${index + 1}'),
                  subtitle: Text(isWin ? 'Victory' : 'Defeat'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isWin ? '+25 🏆' : '-10 🏆',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isWin ? Colors.green : Colors.red,
                        ),
                      ),
                      const Text(
                        '2 hours ago',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

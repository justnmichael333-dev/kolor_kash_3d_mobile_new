import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/iap_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _kashesBalance = 1250;
  final List<Transaction> _recentTransactions = [
    Transaction(
      type: TransactionType.earned,
      amount: 10,
      description: 'Completed artwork',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Transaction(
      type: TransactionType.earned,
      amount: 50,
      description: 'Daily streak bonus',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Transaction(
      type: TransactionType.spent,
      amount: -30,
      description: 'Premium color pack',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Transaction(
      type: TransactionType.earned,
      amount: 100,
      description: 'Referral bonus',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<void> _purchaseKashes(int amount, double price) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💰 Purchase Kashes'),
        content: Text('Buy $amount Kashes for \$$price?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('BUY NOW'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await IAPService.purchaseKashes(amount);
        await AnalyticsService.logEvent('iap_purchase_completed', params: {
          'amount': amount,
          'price': price,
        });

        setState(() {
          _kashesBalance += amount;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Successfully purchased $amount Kashes!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchase failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show full transaction history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$_kashesBalance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Kashes',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.card_giftcard,
                      label: 'Redeem',
                      onTap: () {
                        // Navigate to redeem screen
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.share,
                      label: 'Earn More',
                      onTap: () {
                        // Navigate to referral screen
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.local_fire_department,
                      label: 'Streaks',
                      onTap: () {
                        // Show streak details
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Buy Kashes Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buy Kashes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKashesPack(
                          amount: 100,
                          price: 0.99,
                          popular: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKashesPack(
                          amount: 500,
                          price: 3.99,
                          popular: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKashesPack(
                          amount: 1200,
                          price: 7.99,
                          popular: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._recentTransactions.map(_buildTransactionItem),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKashesPack({
    required int amount,
    required double price,
    required bool popular,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () => _purchaseKashes(amount, price),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: popular
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: popular ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: popular ? 40 : 32,
                ),
                const SizedBox(height: 8),
                Text(
                  '$amount',
                  style: TextStyle(
                    fontSize: popular ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (popular)
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isPositive = transaction.amount > 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositive
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.2),
          child: Icon(
            isPositive ? Icons.add : Icons.remove,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text(_formatTimestamp(transaction.timestamp)),
        trailing: Text(
          '${isPositive ? '+' : ''}${transaction.amount}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

enum TransactionType { earned, spent, purchased }

class Transaction {
  final TransactionType type;
  final int amount;
  final String description;
  final DateTime timestamp;

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });
}

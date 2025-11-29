import 'package:flutter/material.dart';

/// Shows the main battle hub with placeholder lists
/// for 1v1 battles, contests, and tournaments.
class BattleHubScreen extends StatelessWidget {
  const BattleHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        const _SectionHeader(
          title: 'Quick 1v1 Battles',
          subtitle: 'Jump into fast paint-offs to earn Kashes.',
        ),
        const SizedBox(height: 8),
        _BattleCard(
          title: 'Neon Clash 1v1',
          subtitle: '3D graffiti cube · 3 min',
          kashReward: 25,
          onTap: () {
            // Placeholder – later this will push to a battle lobby / canvas.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Battle lobby coming soon…'),
              ),
            );
          },
        ),
        _BattleCard(
          title: 'Chromatic Duel',
          subtitle: 'Holographic skull · 5 min',
          kashReward: 40,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Battle lobby coming soon…'),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Featured Contests',
          subtitle: 'Bigger prizes, more players.',
        ),
        const SizedBox(height: 8),
        _BattleCard(
          title: 'Cyber City Skyline Contest',
          subtitle: 'Up to 32 players · 250 Kashes prize pool',
          kashReward: 250,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contest details coming soon…'),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Tournaments',
          subtitle: 'Bracket-style battles for the dedicated painters.',
        ),
        const SizedBox(height: 8),
        _BattleCard(
          title: 'Hologram Gauntlet',
          subtitle: 'Tournament · 64 players',
          kashReward: 1000,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tournament flow coming soon…'),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }
}

class _BattleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int kashReward;
  final VoidCallback onTap;

  const _BattleCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.kashReward,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.bolt_outlined, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '+$kashReward',
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  Text(
                    'Kashes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

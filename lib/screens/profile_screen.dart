import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Shows basic user info and a placeholder Kashes wallet.
class ProfileScreen extends StatelessWidget {
  final User user;
  final AuthService authService;

  const ProfileScreen({
    Key? key,
    required this.user,
    required this.authService,
  }) : super(key: key);

  String _initialFrom(String? displayName, String? email) {
    final String source;
    if (displayName != null && displayName.trim().isNotEmpty) {
      source = displayName.trim();
    } else if (email != null && email.isNotEmpty) {
      source = email;
    } else {
      source = 'K';
    }
    return source[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = (user.displayName?.trim().isNotEmpty ?? false)
        ? user.displayName!.trim()
        : 'Kolor Kash Artist';
    final String? email = user.email;
    final String? photoUrl = user.photoURL;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? Text(
                        _initialFrom(user.displayName, email),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _KashesCard(currentKashes: 1250),
          const SizedBox(height: 24),
          const _RecentActivitySection(),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await authService.signOut();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign out: $e')),
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _KashesCard extends StatelessWidget {
  final int currentKashes;

  const _KashesCard({Key? key, required this.currentKashes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.monetization_on_outlined, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kashes Wallet',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Earn Kashes by winning battles and contests.',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currentKashes.toString(),
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('Kashes',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_ActivityItem> mockActivity = const <_ActivityItem>[
      _ActivityItem(title: 'Won Neon Clash 1v1', deltaKashes: 25),
      _ActivityItem(title: 'Entered Cyber City Contest', deltaKashes: -50),
      _ActivityItem(title: 'Daily login bonus', deltaKashes: 5),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent activity',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...mockActivity.map((_ActivityItem item) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              item.deltaKashes >= 0
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: item.deltaKashes >= 0 ? Colors.green : Colors.red,
            ),
            title: Text(item.title),
            trailing: Text(
              '${item.deltaKashes >= 0 ? '+' : ''}${item.deltaKashes} K',
              style: TextStyle(
                color: item.deltaKashes >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _ActivityItem {
  final String title;
  final int deltaKashes;

  const _ActivityItem({required this.title, required this.deltaKashes});
}
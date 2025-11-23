import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(authService: _authService);
        } else {
          return KolorKashShell(user: user, authService: _authService);
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isSigningIn = true);
    try {
      final user = await widget.authService.signInWithGoogle();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled')),
        );
      }
      // If user != null, the StreamBuilder in AuthGate will rebuild into the shell.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B1F3B), Color(0xFF0F2027)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Kolor Kash 3D',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Paint 3D canvases.\nWin battles.\nEarn Kashes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSigningIn ? null : _handleGoogleSignIn,
                  icon: _isSigningIn
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isSigningIn ? 'Signing in...' : 'Sign in with Google',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KolorKashShell extends StatefulWidget {
  final User user;
  final AuthService authService;

  const KolorKashShell({
    super.key,
    required this.user,
    required this.authService,
  });

  @override
  State<KolorKashShell> createState() => _KolorKashShellState();
}

class _KolorKashShellState extends State<KolorKashShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _PlayPage(user: widget.user),
      const _GalleryPage(),
      _ProfilePage(user: widget.user, authService: widget.authService),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolor Kash 3D'),
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlayPage extends StatelessWidget {
  final User user;

  const _PlayPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Welcome, ${user.displayName ?? user.email ?? 'Artist'}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Featured Battles',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        const _BattleCard(
          title: '1v1 Neon City Showdown',
          reward: '500 Kashes',
          slots: '2 / 2',
        ),
        const _BattleCard(
          title: 'Tournament: Galaxy Graffiti Cup',
          reward: '5,000 Kashes',
          slots: '32 players',
        ),
      ],
    );
  }
}

class _BattleCard extends StatelessWidget {
  final String title;
  final String reward;
  final String slots;

  const _BattleCard({
    required this.title,
    required this.reward,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text('$reward • $slots'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Battle flow coming next – core shell is working.'),
            ),
          );
        },
      ),
    );
  }
}

class _GalleryPage extends StatelessWidget {
  const _GalleryPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your 3D canvases will show up here.\nCore app shell first, art later.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final User user;
  final AuthService authService;

  const _ProfilePage({required this.user, required this.authService});

  @override
  Widget build(BuildContext context) {
    final email = user.email ?? 'Unknown email';
    final name = user.displayName ?? 'Unnamed artist';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: $name', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Email: $email', style: const TextStyle(fontSize: 16)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await authService.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}

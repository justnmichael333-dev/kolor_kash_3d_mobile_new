import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'battle_hub_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';

/// Main in-app shell that users see after logging in.
/// Provides bottom navigation between Play, Gallery, and Profile tabs.
class KolorKashHomeShell extends StatefulWidget {
  final User user;
  final AuthService authService;

  const KolorKashHomeShell({
    Key? key,
    required this.user,
    required this.authService,
  }) : super(key: key);

  @override
  State<KolorKashHomeShell> createState() => _KolorKashHomeShellState();
}

class _KolorKashHomeShellState extends State<KolorKashHomeShell> {
  int _selectedIndex = 0;

  static const List<String> _screenTitles = <String>[
    'Play · Battle Hub',
    'My Gallery',
    'Profile & Wallet',
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      const BattleHubScreen(),
      const GalleryScreen(),
      ProfileScreen(user: widget.user, authService: widget.authService),
    ];
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_outlined),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kolor_kash_3d_mobile/screens/home_screen.dart';
import 'package:kolor_kash_3d_mobile/screens/contest_screen.dart';
import 'package:kolor_kash_3d_mobile/screens/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/contest':
        return MaterialPageRoute(builder: (_) => const ContestScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

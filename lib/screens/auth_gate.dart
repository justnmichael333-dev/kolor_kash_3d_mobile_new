import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'google_sign_in_screen.dart';
import 'kolor_kash_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Not signed in → show Google Sign-In screen
        if (!snapshot.hasData) {
          return const GoogleSignInScreen();
        }

        // Signed in → show main app
        return const KolorKashHomeScreen();
      },
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Replace this with your real Web OAuth client ID from Google Cloud,
// the long string that ends with `.apps.googleusercontent.com`.
const String _webClientId = 'MY_WEB_CLIENT_ID_HERE';

// IMPORTANT: reuse the same instance if you share it
// or just create a new one; for simple apps it's fine.
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: kIsWeb ? _webClientId : null,
  scopes: <String>['email'],
);

class KolorKashHomeScreen extends StatelessWidget {
  const KolorKashHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolor Kash 3D'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Signed in as:\n${user?.email ?? "Unknown"}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

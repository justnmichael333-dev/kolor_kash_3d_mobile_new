import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Replace this with your real Web OAuth client ID from Google Cloud,
// the long string that ends with `.apps.googleusercontent.com`.
const String _webClientId = '994893675209-h4biqkhcakubte0pdmnob3dfrsq2rrjj.apps.googleusercontent.com';

// Main GoogleSignIn instance for the app.
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: kIsWeb ? _webClientId : null,
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});

  Future<void> _handleSignIn(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // user cancelled

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 96),
              const SizedBox(height: 24),
              const Text(
                'Kolor Kash 3D',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to start coloring,\nbattling, and earning Kashes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                onPressed: () => _handleSignIn(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

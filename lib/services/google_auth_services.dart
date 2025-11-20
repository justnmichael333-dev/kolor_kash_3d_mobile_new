import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Google auth singleton for the app.
/// Make sure YOUR_WEB_CLIENT_ID_HERE matches the one in web/index.html.
class GoogleAuthService {
  GoogleAuthService._internal();

  static final GoogleAuthService instance = GoogleAuthService._internal();

  // Replace this with your real Web OAuth client ID
  static const String _webClientId = '994893675209-h4biqkhcakubte0pdmnob3dfrsq2rrjj.apps.googleusercontent.com';

  /// Main GoogleSignIn instance used across the app.
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _webClientId : null,
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
}

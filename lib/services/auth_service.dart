import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'analytics_service.dart';
import 'kashes_service.dart';

/// Comprehensive authentication service for Kolor Kash 3D
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Get current Firebase user
  static User? get currentUser => _auth.currentUser;

  /// Get auth state changes stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current UserModel from Firestore
  static Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream of current UserModel
  static Stream<UserModel?> get userModelStream {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  /// Sign up with email and password
  static Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(displayName);

      // Initialize user profile in Firestore
      if (credential.user != null) {
        await _initializeUserProfile(
          user: credential.user!,
          displayName: displayName,
        );
      }

      await AnalyticsService.logSignUp('email');
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with email and password
  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _updateLastVisit(credential.user!.uid);
      await AnalyticsService.logLogin('email');
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if new user and initialize profile
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _initializeUserProfile(
          user: userCredential.user!,
          displayName: userCredential.user!.displayName ?? 'Player',
          photoUrl: userCredential.user!.photoURL,
        );
        await AnalyticsService.logSignUp('google');
      } else {
        await _updateLastVisit(userCredential.user!.uid);
        await AnalyticsService.logLogin('google');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      await AnalyticsService.logEvent('password_reset_requested');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      await AnalyticsService.logEvent('sign_out');
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Delete user account
  static Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();

      await AnalyticsService.logEvent('account_deleted');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'Please sign in again before deleting your account for security reasons.');
      }
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Update user profile
  static Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      // Update Firebase Auth profile
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore profile
      await _firestore.collection('users').doc(user.uid).update({
        if (displayName != null) 'display_name': displayName,
        if (photoUrl != null) 'photo_url': photoUrl,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await AnalyticsService.logEvent('profile_updated');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Update user favorite colors
  static Future<void> updateFavoriteColors(List<String> colors) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await _firestore.collection('users').doc(user.uid).update({
        'favorite_colors': colors,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update favorite colors: $e');
    }
  }

  /// Mark tutorial as completed
  static Future<void> completeTutorial() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await _firestore.collection('users').doc(user.uid).update({
        'has_completed_tutorial': true,
        'updated_at': FieldValue.serverTimestamp(),
      });

      await AnalyticsService.logEvent('tutorial_completed');
    } catch (e) {
      throw Exception('Failed to mark tutorial as completed: $e');
    }
  }

  /// Initialize user profile in Firestore
  static Future<void> _initializeUserProfile({
    required User user,
    required String displayName,
    String? photoUrl,
    String? referralCode,
  }) async {
    try {
      // Generate unique referral code
      final userReferralCode = await _generateUniqueReferralCode();

      // Create user document
      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: displayName,
        photoUrl: photoUrl,
        kashesBalance: 100, // Starter coins as per PROJECT_CONTEXT
        referralCode: userReferralCode,
        usedReferralCode: referralCode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());

      // Award starter Kashes
      await KashesService.addKashes(100, 'Welcome Bonus');

      // If user used a referral code, process the referral
      if (referralCode != null && referralCode.isNotEmpty) {
        await _processReferralReward(referralCode);
      }

      await AnalyticsService.logEvent('user_initialized', params: {
        'referral_code': userReferralCode,
        'used_referral': referralCode != null,
      });
    } catch (e) {
      // Don't throw here, just log - profile initialization shouldn't block sign up
      await AnalyticsService.logEvent('user_init_failed', params: {
        'error': e.toString(),
      });
    }
  }

  /// Generate a unique referral code
  static Future<String> _generateUniqueReferralCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    for (var attempts = 0; attempts < 10; attempts++) {
      final code = List.generate(
        8,
        (index) => chars[random.nextInt(chars.length)],
      ).join();

      // Check if code already exists
      final existing = await _firestore
          .collection('users')
          .where('referral_code', isEqualTo: code)
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        return code;
      }
    }

    // Fallback: use timestamp-based code
    return 'KK${DateTime.now().millisecondsSinceEpoch % 1000000}';
  }

  /// Process referral reward for the referrer
  static Future<void> _processReferralReward(String referralCode) async {
    try {
      final referrerQuery = await _firestore
          .collection('users')
          .where('referral_code', isEqualTo: referralCode)
          .limit(1)
          .get();

      if (referrerQuery.docs.isNotEmpty) {
        final referrerId = referrerQuery.docs.first.id;

        // Increment referral count
        await _firestore.collection('users').doc(referrerId).update({
          'referral_count': FieldValue.increment(1),
          'updated_at': FieldValue.serverTimestamp(),
        });

        // Award Kashes to referrer (50 Kashes per referral)
        await _firestore
            .collection('users')
            .doc(referrerId)
            .collection('transactions')
            .add({
          'amount': 50,
          'reason': 'Referral Bonus',
          'type': 'referral',
          'timestamp': FieldValue.serverTimestamp(),
        });

        await _firestore.collection('users').doc(referrerId).update({
          'kashes': FieldValue.increment(50),
        });
      }
    } catch (e) {
      // Don't throw - referral processing shouldn't block sign up
    }
  }

  /// Update last visit timestamp
  static Future<void> _updateLastVisit(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'last_visit': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Don't throw - last visit update shouldn't block sign in
    }
  }

  /// Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed: ${e.message ?? "Unknown error"}';
    }
  }
}


import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import 'analytics_service.dart';
import 'kashes_service.dart';

/// Service for managing referral system
///
/// NOTE: Firebase Dynamic Links has been removed as it was discontinued (Aug 25, 2025).
/// Now using simple referral links. Consider migrating to:
/// - Universal Links (iOS) + App Links (Android)
/// - Third-party services: Branch.io, Adjust, AppsFlyer
/// See: https://firebase.google.com/support/dynamic-links-faq
class ReferralService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Generate a unique referral code for the user
  static Future<String> getUserReferralCode() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 'GUEST';

      final doc = await _firestore.collection('users').doc(userId).get();
      String? referralCode = doc.data()?['referral_code'] as String?;

      if (referralCode == null) {
        // Generate new code
        referralCode = _generateReferralCode();
        await _firestore.collection('users').doc(userId).update({
          'referral_code': referralCode,
        });

        // Store code mapping
        await _firestore.collection('referral_codes').doc(referralCode).set({
          'user_id': userId,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      return referralCode;
    } catch (e) {
      return 'GUEST';
    }
  }

  /// Generate a random referral code
  static String _generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Create a simple referral link
  static Future<String> createReferralLink(String referralCode) async {
    // Using simple URL scheme - implement Universal Links/App Links for production
    return 'https://kolorkash.com/invite?code=$referralCode';
  }

  /// Share referral link
  static Future<void> shareReferral(String referralCode) async {
    try {
      final link = await createReferralLink(referralCode);
      final message = 'Join me on Kolor Kash 3D! 🎨\n\n'
          'Create stunning 3D art, compete in contests, and earn rewards!\n\n'
          'Use my invite code: $referralCode\n'
          'Download: $link\n\n'
          'Get 100 Kashes as a welcome bonus! 💰';

      await SharePlus.instance.share(ShareParams(text: message));

      await AnalyticsService.logReferralShared(referralCode);
    } catch (e) {
      // Handle error
    }
  }

  /// Redeem a referral code
  static Future<bool> redeemReferralCode(String code) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      // Check if user already used a referral code
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.data()?['used_referral_code'] != null) {
        return false; // Already used a code
      }

      // Get referrer's user ID
      final codeDoc =
          await _firestore.collection('referral_codes').doc(code).get();
      if (!codeDoc.exists) {
        return false; // Invalid code
      }

      final referrerId = codeDoc.data()?['user_id'] as String?;
      if (referrerId == null || referrerId == userId) {
        return false; // Can't use own code
      }

      // Reward both users
      await _firestore.runTransaction((transaction) async {
        // Mark code as used by this user
        transaction.update(
          _firestore.collection('users').doc(userId),
          {
            'used_referral_code': code,
            'referred_by': referrerId,
          },
        );

        // Increment referrer's referral count
        final referrerRef = _firestore.collection('users').doc(referrerId);
        final referrerDoc = await transaction.get(referrerRef);
        final currentCount = referrerDoc.data()?['referral_count'] as int? ?? 0;

        transaction.update(referrerRef, {
          'referral_count': currentCount + 1,
        });
      });

      // Reward both users with Kashes
      await KashesService.rewardForReferral(code); // New user gets 100

      // Reward referrer
      final referrerKashes = KashesService.addKashes(100, 'Referral reward');
      await referrerKashes;

      await AnalyticsService.logReferralRedeemed(code);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user's referral stats
  static Future<ReferralStats> getReferralStats() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return ReferralStats(totalReferrals: 0, totalEarned: 0);
      }

      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();

      return ReferralStats(
        totalReferrals: data?['referral_count'] as int? ?? 0,
        totalEarned: (data?['referral_count'] as int? ?? 0) * 100,
      );
    } catch (e) {
      return ReferralStats(totalReferrals: 0, totalEarned: 0);
    }
  }

  /// Handle incoming referral links
  /// PRODUCTION: Implement Universal Links (iOS) and App Links (Android) for deep linking
  static Future<void> handleReferralLink(Uri? deepLink) async {
    if (deepLink == null) return;

    final code = deepLink.queryParameters['code'];

    if (code != null) {
      // Store the code to be redeemed after sign-in
      // This would be handled in your auth flow
      await redeemReferralCode(code);
    }
  }

  /// Initialize referral link handling
  /// PRODUCTION: Set up Universal Links and App Links before deploying
  static void initializeReferralLinks() {
    // Placeholder for Universal Links/App Links initialization
    // In production, implement:
    // - iOS: Configure associated domains and handle NSUserActivity
    // - Android: Configure intent filters and handle app links
  }
}

class ReferralStats {
  final int totalReferrals;
  final int totalEarned;

  ReferralStats({
    required this.totalReferrals,
    required this.totalEarned,
  });
}

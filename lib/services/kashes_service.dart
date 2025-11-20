import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'analytics_service.dart';

/// Service for managing Kashes virtual currency
class KashesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user's current Kashes balance
  static Future<int> getBalance() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['kashes'] as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Add Kashes to user's balance
  static Future<void> addKashes(int amount, String reason) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userRef = _firestore.collection('users').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        final currentBalance = snapshot.data()?['kashes'] as int? ?? 0;
        final newBalance = currentBalance + amount;

        transaction.update(userRef, {'kashes': newBalance});

        // Log transaction
        transaction.set(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('transactions')
              .doc(),
          {
            'type': 'earned',
            'amount': amount,
            'reason': reason,
            'balance_after': newBalance,
            'timestamp': FieldValue.serverTimestamp(),
          },
        );
      });

      await AnalyticsService.logEvent('kashes_earned', params: {
        'amount': amount,
        'reason': reason,
      });
    } catch (e) {
      // Handle error
    }
  }

  /// Deduct Kashes from user's balance
  static Future<bool> deductKashes(int amount, String reason) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final userRef = _firestore.collection('users').doc(userId);

      final result = await _firestore.runTransaction<bool>((transaction) async {
        final snapshot = await transaction.get(userRef);
        final currentBalance = snapshot.data()?['kashes'] as int? ?? 0;

        if (currentBalance < amount) {
          return false; // Insufficient balance
        }

        final newBalance = currentBalance - amount;
        transaction.update(userRef, {'kashes': newBalance});

        // Log transaction
        transaction.set(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('transactions')
              .doc(),
          {
            'type': 'spent',
            'amount': -amount,
            'reason': reason,
            'balance_after': newBalance,
            'timestamp': FieldValue.serverTimestamp(),
          },
        );

        return true;
      });

      if (result) {
        await AnalyticsService.logEvent('kashes_spent', params: {
          'amount': amount,
          'reason': reason,
        });
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  /// Reward user for completing an artwork
  static Future<void> rewardForCompletion(int amount) async {
    await addKashes(amount, 'Artwork completed');
  }

  /// Reward user for daily streak
  static Future<void> rewardForStreak(int days) async {
    final bonusAmount = days * 10; // 10 Kashes per day
    await addKashes(bonusAmount, 'Daily streak: $days days');
    await AnalyticsService.logStreakCompleted(days);
  }

  /// Reward user for winning PvP
  static Future<void> rewardForPvPWin(int amount) async {
    await addKashes(amount, 'PvP victory');
  }

  /// Reward user for contest win
  static Future<void> rewardForContestWin(int amount, String contestId) async {
    await addKashes(amount, 'Contest prize: $contestId');
    await AnalyticsService.logContestWon(contestId, amount);
  }

  /// Reward user for referral
  static Future<void> rewardForReferral(String referralCode) async {
    await addKashes(100, 'Referral bonus');
    await AnalyticsService.logReferralRedeemed(referralCode);
  }

  /// Get user's transaction history
  static Stream<List<Map<String, dynamic>>> getTransactionHistory() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  /// Check and update daily streak
  static Future<void> checkDailyStreak() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userRef = _firestore.collection('users').doc(userId);
      final doc = await userRef.get();
      final data = doc.data();

      final lastVisit = (data?['last_visit'] as Timestamp?)?.toDate();
      final currentStreak = data?['current_streak'] as int? ?? 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (lastVisit == null) {
        // First visit
        await userRef.update({
          'last_visit': Timestamp.fromDate(now),
          'current_streak': 1,
        });
      } else {
        final lastVisitDate =
            DateTime(lastVisit.year, lastVisit.month, lastVisit.day);
        final daysDifference = today.difference(lastVisitDate).inDays;

        if (daysDifference == 1) {
          // Consecutive day
          final newStreak = currentStreak + 1;
          await userRef.update({
            'last_visit': Timestamp.fromDate(now),
            'current_streak': newStreak,
          });
          await rewardForStreak(newStreak);
        } else if (daysDifference > 1) {
          // Streak broken
          await userRef.update({
            'last_visit': Timestamp.fromDate(now),
            'current_streak': 1,
          });
        }
      }
    } catch (e) {
      // Handle error
    }
  }
}

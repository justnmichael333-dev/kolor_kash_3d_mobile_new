import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'analytics_service.dart';

/// Service for managing PvP battles
class PvPService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Find a PvP match
  static Future<String> findMatch() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Add user to matchmaking queue
      final queueRef = _firestore.collection('matchmaking_queue').doc(userId);
      await queueRef.set({
        'user_id': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'searching',
      });

      // Wait for match (simulated with timeout)
      await Future.delayed(const Duration(seconds: 3));

      // Create a match
      final matchId = 'match_${DateTime.now().millisecondsSinceEpoch}';
      await _firestore.collection('matches').doc(matchId).set({
        'players': [userId, 'opponent_id'],
        'status': 'active',
        'created_at': FieldValue.serverTimestamp(),
        'model_id': 'pvp_model_1',
      });

      // Remove from queue
      await queueRef.delete();

      await AnalyticsService.logPvPMatchStarted(matchId);

      return matchId;
    } catch (e) {
      throw Exception('Failed to find match: $e');
    }
  }

  /// Record a PvP match result
  static Future<void> recordMatchResult({
    required String matchId,
    required bool isWin,
    required String opponentId,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Update match status
      await _firestore.collection('matches').doc(matchId).update({
        'status': 'completed',
        'winner_id': isWin ? userId : opponentId,
        'completed_at': FieldValue.serverTimestamp(),
      });

      // Update user stats
      final userRef = _firestore.collection('users').doc(userId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        final data = snapshot.data();

        final wins = (data?['pvp_wins'] as int? ?? 0) + (isWin ? 1 : 0);
        final losses = (data?['pvp_losses'] as int? ?? 0) + (isWin ? 0 : 1);
        final trophies = (data?['trophies'] as int? ?? 0) + (isWin ? 25 : -10);

        transaction.update(userRef, {
          'pvp_wins': wins,
          'pvp_losses': losses,
          'trophies': trophies,
        });
      });

      // Reward winner
      if (isWin) {
        await KashesService.rewardForPvPWin(25);
        await AnalyticsService.logPvPMatchWon(opponentId);
      }

      // Record match history
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('match_history')
          .doc(matchId)
          .set({
        'match_id': matchId,
        'opponent_id': opponentId,
        'result': isWin ? 'win' : 'loss',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error
    }
  }

  /// Get user's PvP stats
  static Future<PvPStats> getUserStats() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return PvPStats(wins: 0, losses: 0, trophies: 0, rank: 0);
      }

      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();

      return PvPStats(
        wins: data?['pvp_wins'] as int? ?? 0,
        losses: data?['pvp_losses'] as int? ?? 0,
        trophies: data?['trophies'] as int? ?? 0,
        rank: data?['pvp_rank'] as int? ?? 999,
      );
    } catch (e) {
      return PvPStats(wins: 0, losses: 0, trophies: 0, rank: 0);
    }
  }

  /// Get match history
  static Stream<List<MatchRecord>> getMatchHistory() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('match_history')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MatchRecord.fromFirestore(doc))
            .toList());
  }

  /// Get global leaderboard
  static Future<List<LeaderboardPlayer>> getGlobalLeaderboard({
    int limit = 50,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('trophies', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .asMap()
          .entries
          .map((entry) => LeaderboardPlayer.fromFirestore(
                entry.value,
                rank: entry.key + 1,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Cancel matchmaking
  static Future<void> cancelMatchmaking() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('matchmaking_queue').doc(userId).delete();
    } catch (e) {
      // Handle error
    }
  }
}

class PvPStats {
  final int wins;
  final int losses;
  final int trophies;
  final int rank;

  PvPStats({
    required this.wins,
    required this.losses,
    required this.trophies,
    required this.rank,
  });

  double get winRate {
    final total = wins + losses;
    if (total == 0) return 0.0;
    return (wins / total) * 100;
  }
}

class MatchRecord {
  final String matchId;
  final String opponentId;
  final bool isWin;
  final DateTime timestamp;

  MatchRecord({
    required this.matchId,
    required this.opponentId,
    required this.isWin,
    required this.timestamp,
  });

  factory MatchRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchRecord(
      matchId: data['match_id'] as String,
      opponentId: data['opponent_id'] as String,
      isWin: data['result'] == 'win',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class LeaderboardPlayer {
  final String userId;
  final String userName;
  final int trophies;
  final int rank;
  final int wins;
  final int losses;

  LeaderboardPlayer({
    required this.userId,
    required this.userName,
    required this.trophies,
    required this.rank,
    required this.wins,
    required this.losses,
  });

  factory LeaderboardPlayer.fromFirestore(
    DocumentSnapshot doc, {
    required int rank,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardPlayer(
      userId: doc.id,
      userName: data['display_name'] as String? ?? 'Player',
      trophies: data['trophies'] as int? ?? 0,
      rank: rank,
      wins: data['pvp_wins'] as int? ?? 0,
      losses: data['pvp_losses'] as int? ?? 0,
    );
  }
}

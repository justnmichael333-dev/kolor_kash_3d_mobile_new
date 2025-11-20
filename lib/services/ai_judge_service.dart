import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for AI-powered artwork judging in contests
///
/// PRODUCTION: Replace _baseUrl with your deployed API endpoint.
/// Currently returns mock data for demo purposes.
class AIJudgeService {
  static const String _baseUrl = 'https://api.kolorkash.com/ai-judge';

  /// Submit artwork for AI judging
  static Future<JudgmentResult> submitForJudging({
    required String artworkId,
    required String contestId,
    required String userId,
    required String imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/submit'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'artwork_id': artworkId,
          'contest_id': contestId,
          'user_id': userId,
          'image_url': imageUrl,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return JudgmentResult.fromJson(data);
      } else {
        throw Exception('Failed to submit artwork for judging');
      }
    } catch (e) {
      // Mock response for demo
      return JudgmentResult(
        artworkId: artworkId,
        score: 85.0,
        rank: 12,
        feedback: 'Excellent use of colors and shading technique!',
        categories: {
          'creativity': 90.0,
          'technique': 85.0,
          'color_harmony': 82.0,
          'detail': 88.0,
        },
      );
    }
  }

  /// Get contest leaderboard
  static Future<List<LeaderboardEntry>> getContestLeaderboard(
    String contestId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/leaderboard/$contestId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LeaderboardEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      // Mock response for demo
      return [
        LeaderboardEntry(
          rank: 1,
          userId: 'user1',
          userName: 'ArtMaster',
          score: 95.5,
          artworkUrl: '',
        ),
        LeaderboardEntry(
          rank: 2,
          userId: 'user2',
          userName: 'ColorKing',
          score: 93.2,
          artworkUrl: '',
        ),
        LeaderboardEntry(
          rank: 3,
          userId: 'user3',
          userName: 'PaintPro',
          score: 91.8,
          artworkUrl: '',
        ),
      ];
    }
  }

  /// Get detailed AI feedback for an artwork
  static Future<String> getDetailedFeedback(String artworkId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/feedback/$artworkId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['feedback'] as String;
      } else {
        throw Exception('Failed to get feedback');
      }
    } catch (e) {
      return 'Great work! Your color choices show creativity and the shading adds depth to the piece.';
    }
  }
}

class JudgmentResult {
  final String artworkId;
  final double score;
  final int rank;
  final String feedback;
  final Map<String, double> categories;

  JudgmentResult({
    required this.artworkId,
    required this.score,
    required this.rank,
    required this.feedback,
    required this.categories,
  });

  factory JudgmentResult.fromJson(Map<String, dynamic> json) {
    return JudgmentResult(
      artworkId: json['artwork_id'] as String,
      score: (json['score'] as num).toDouble(),
      rank: json['rank'] as int,
      feedback: json['feedback'] as String,
      categories: Map<String, double>.from(json['categories'] as Map),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final double score;
  final String artworkUrl;

  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.score,
    required this.artworkUrl,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      score: (json['score'] as num).toDouble(),
      artworkUrl: json['artwork_url'] as String,
    );
  }
}

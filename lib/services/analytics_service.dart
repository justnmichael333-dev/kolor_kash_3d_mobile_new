import 'package:firebase_analytics/firebase_analytics.dart';

/// Service to track all viral growth and engagement events
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Generic event logger
  static Future<void> logEvent(String name,
      {Map<String, Object?>? params}) async {
    await _analytics.logEvent(
      name: name,
      parameters: params?.cast<String, Object>(),
    );
  }

  /// User opened the app
  static Future<void> logAppOpened() async {
    await logEvent('app_opened', params: {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User signed up
  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
    await logEvent('sign_up', params: {
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User logged in
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
    await logEvent('login', params: {
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User started coloring a model
  static Future<void> logColoringStarted(String modelId) async {
    await logEvent('coloring_started', params: {
      'model_id': modelId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User started a PvP match
  static Future<void> logPvPMatchStarted(String matchId) async {
    await logEvent('pvp_match_started', params: {
      'match_id': matchId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User won a PvP match
  static Future<void> logPvPMatchWon(String opponent) async {
    await logEvent('pvp_match_won', params: {
      'opponent': opponent,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User joined a contest
  static Future<void> logContestJoined(String contestId) async {
    await logEvent('contest_joined', params: {
      'contest_id': contestId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User won a contest
  static Future<void> logContestWon(String contestId, int prize) async {
    await logEvent('contest_won', params: {
      'contest_id': contestId,
      'prize': prize,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User shared a referral link
  static Future<void> logReferralShared(String code) async {
    await logEvent('referral_shared', params: {
      'code': code,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User redeemed a referral code
  static Future<void> logReferralRedeemed(String code) async {
    await logEvent('referral_redeemed', params: {
      'code': code,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User completed a daily streak
  static Future<void> logStreakCompleted(int days) async {
    await logEvent('streak_completed', params: {
      'days': days,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User minted an NFT
  static Future<void> logNFTMinted(String nftId) async {
    await logEvent('nft_minted', params: {
      'nft_id': nftId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// User completed an IAP purchase
  static Future<void> logIAPPurchaseCompleted(
      String productId, double price) async {
    await logEvent('iap_purchase_completed', params: {
      'product_id': productId,
      'price': price,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Set user properties
  static Future<void> setUserProperties({
    String? userId,
    String? userName,
    int? kashesBalance,
  }) async {
    if (userId != null) {
      await _analytics.setUserId(id: userId);
    }
    if (userName != null) {
      await _analytics.setUserProperty(name: 'user_name', value: userName);
    }
    if (kashesBalance != null) {
      await _analytics.setUserProperty(
        name: 'kashes_balance',
        value: kashesBalance.toString(),
      );
    }
  }

  /// Set current screen
  static Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}

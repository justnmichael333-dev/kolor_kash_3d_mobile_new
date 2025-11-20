/// Application configuration constants
class AppConfig {
  // App Info
  static const String appName = 'Kolor Kash 3D';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Endpoints
  static const String baseApiUrl = 'https://api.kolorkash.com';
  static const String aiJudgeEndpoint = '$baseApiUrl/ai-judge';
  static const String nftEndpoint = '$baseApiUrl/nft';
  static const String analyticsEndpoint = '$baseApiUrl/analytics';

  // Firebase
  static const String firebaseProjectId = 'kolor-kash-3d';
  static const String firebaseStorageBucket = 'kolor-kash-3d.appspot.com';

  // Deep Links
  static const String deepLinkPrefix = 'https://kolorkash.page.link';
  static const String webUrl = 'https://kolorkash.com';

  // Rewards & Economy
  static const int artworkCompletionReward = 10;
  static const int dailyStreakReward = 50;
  static const int pvpWinReward = 25;
  static const int pvpLossPenalty = 10;
  static const int referralReward = 100;
  static const int minWithdrawal = 1000;

  // IAP Product IDs
  static const String iapKashes100 = 'com.kolorkash.kashes.100';
  static const String iapKashes500 = 'com.kolorkash.kashes.500';
  static const String iapKashes1200 = 'com.kolorkash.kashes.1200';
  static const String iapPremiumMonthly = 'com.kolorkash.premium.monthly';
  static const String iapPremiumYearly = 'com.kolorkash.premium.yearly';

  // IAP Prices (in USD)
  static const double priceKashes100 = 0.99;
  static const double priceKashes500 = 3.99;
  static const double priceKashes1200 = 7.99;
  static const double pricePremiumMonthly = 4.99;
  static const double pricePremiumYearly = 39.99;

  // Contest Settings
  static const Duration contestDuration = Duration(days: 3);
  static const int minContestParticipants = 10;
  static const List<int> contestPrizes = [500, 300, 200, 100, 50];

  // PvP Settings
  static const Duration pvpMatchDuration = Duration(minutes: 5);
  static const int pvpMatchmakingTimeout = 30; // seconds
  static const int pvpTrophiesPerWin = 25;
  static const int pvpTrophiesPerLoss = 10;

  // Social
  static const int maxReferrals = 100;
  static const Duration streakResetTime = Duration(hours: 24);

  // UI Settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const int maxRecentArtworks = 20;
  static const int leaderboardPageSize = 50;

  // 3D Model Settings
  static const int maxModelComplexity = 100000; // triangles
  static const List<String> supportedModelFormats = ['.glb', '.gltf', '.obj'];
  static const double defaultCameraDistance = 5.0;
  static const double minZoom = 0.5;
  static const double maxZoom = 10.0;

  // Storage
  static const String artworkStoragePath = 'artworks';
  static const String modelStoragePath = 'models';
  static const String userAvatarStoragePath = 'avatars';
  static const int maxImageSizeMB = 10;

  // Analytics Events
  static const String eventAppOpened = 'app_opened';
  static const String eventColoringStarted = 'coloring_started';
  static const String eventPvPMatchStarted = 'pvp_match_started';
  static const String eventPvPMatchWon = 'pvp_match_won';
  static const String eventContestJoined = 'contest_joined';
  static const String eventContestWon = 'contest_won';
  static const String eventReferralShared = 'referral_shared';
  static const String eventReferralRedeemed = 'referral_redeemed';
  static const String eventStreakCompleted = 'streak_completed';
  static const String eventNFTMinted = 'nft_minted';
  static const String eventIAPPurchaseCompleted = 'iap_purchase_completed';

  // Feature Flags
  static const bool enableNFTMinting = true;
  static const bool enablePvP = true;
  static const bool enableContests = true;
  static const bool enableIAP = true;
  static const bool enableReferrals = true;
  static const bool enablePremium = true;

  // Debug Settings
  static const bool debugMode = false;
  static const bool showPerformanceOverlay = false;
  static const bool enableLogging = true;
}

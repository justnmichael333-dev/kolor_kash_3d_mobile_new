class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int kashesBalance;
  final int currentStreak;
  final DateTime? lastVisit;
  final String? referralCode;
  final String? usedReferralCode;
  final int referralCount;
  final int pvpWins;
  final int pvpLosses;
  final int trophies;
  final int pvpRank;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final int levelsCompleted;
  final List<String> favoriteColors;
  final bool hasCompletedTutorial;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.kashesBalance = 0,
    this.currentStreak = 0,
    this.lastVisit,
    this.referralCode,
    this.usedReferralCode,
    this.referralCount = 0,
    this.pvpWins = 0,
    this.pvpLosses = 0,
    this.trophies = 0,
    this.pvpRank = 999,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.levelsCompleted = 0,
    this.favoriteColors = const [],
    this.hasCompletedTutorial = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(dynamic doc) {
    final data = (doc.data() ?? {}) as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String,
      displayName: data['display_name'] as String?,
      photoUrl: data['photo_url'] as String?,
      kashesBalance: data['kashes'] is int
          ? data['kashes'] as int
          : int.tryParse(data['kashes']?.toString() ?? '') ?? 0,
      currentStreak: data['current_streak'] is int
          ? data['current_streak'] as int
          : int.tryParse(data['current_streak']?.toString() ?? '') ?? 0,
      lastVisit: data['last_visit'] != null && data['last_visit'] is DateTime
          ? data['last_visit'] as DateTime
          : data['last_visit'] != null &&
                  data['last_visit'].toString().isNotEmpty
              ? DateTime.tryParse(data['last_visit'].toString())
              : null,
      referralCode: data['referral_code'] as String?,
      usedReferralCode: data['used_referral_code'] as String?,
      referralCount: data['referral_count'] is int
          ? data['referral_count'] as int
          : int.tryParse(data['referral_count']?.toString() ?? '') ?? 0,
      pvpWins: data['pvp_wins'] is int
          ? data['pvp_wins'] as int
          : int.tryParse(data['pvp_wins']?.toString() ?? '') ?? 0,
      pvpLosses: data['pvp_losses'] as int? ?? 0,
      trophies: data['trophies'] as int? ?? 0,
      pvpRank: data['pvp_rank'] is int
          ? data['pvp_rank'] as int
          : int.tryParse(data['pvp_rank']?.toString() ?? '') ?? 999,
      isPremium: data['is_premium'] as bool? ?? false,
      premiumExpiresAt: data['premium_expires_at'] != null
          ? (data['premium_expires_at'] is DateTime
              ? data['premium_expires_at'] as DateTime
              : DateTime.tryParse(data['premium_expires_at'].toString()))
          : null,
      levelsCompleted: data['levels_completed'] is int
          ? data['levels_completed'] as int
          : int.tryParse(data['levels_completed']?.toString() ?? '') ?? 0,
      favoriteColors: data['favorite_colors'] != null
          ? List<String>.from(data['favorite_colors'] as List)
          : [],
      hasCompletedTutorial: data['has_completed_tutorial'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? (data['created_at'] is DateTime
              ? data['created_at'] as DateTime
              : DateTime.tryParse(data['created_at'].toString()) ??
                  DateTime.now())
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] is DateTime
              ? data['updated_at'] as DateTime
              : DateTime.tryParse(data['updated_at'].toString()) ??
                  DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'kashes': kashesBalance,
      'current_streak': currentStreak,
      'last_visit': lastVisit,
      'referral_code': referralCode,
      'used_referral_code': usedReferralCode,
      'referral_count': referralCount,
      'pvp_wins': pvpWins,
      'pvp_losses': pvpLosses,
      'trophies': trophies,
      'pvp_rank': pvpRank,
      'is_premium': isPremium,
      'premium_expires_at': premiumExpiresAt,
      'levels_completed': levelsCompleted,
      'favorite_colors': favoriteColors,
      'has_completed_tutorial': hasCompletedTutorial,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? kashesBalance,
    int? currentStreak,
    DateTime? lastVisit,
    String? referralCode,
    String? usedReferralCode,
    int? referralCount,
    int? pvpWins,
    int? pvpLosses,
    int? trophies,
    int? pvpRank,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    int? levelsCompleted,
    List<String>? favoriteColors,
    bool? hasCompletedTutorial,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      kashesBalance: kashesBalance ?? this.kashesBalance,
      currentStreak: currentStreak ?? this.currentStreak,
      lastVisit: lastVisit ?? this.lastVisit,
      referralCode: referralCode ?? this.referralCode,
      usedReferralCode: usedReferralCode ?? this.usedReferralCode,
      referralCount: referralCount ?? this.referralCount,
      pvpWins: pvpWins ?? this.pvpWins,
      pvpLosses: pvpLosses ?? this.pvpLosses,
      trophies: trophies ?? this.trophies,
      pvpRank: pvpRank ?? this.pvpRank,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      favoriteColors: favoriteColors ?? this.favoriteColors,
      hasCompletedTutorial: hasCompletedTutorial ?? this.hasCompletedTutorial,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  double get winRate {
    final total = pvpWins + pvpLosses;
    if (total == 0) return 0.0;
    return (pvpWins / total) * 100;
  }
}

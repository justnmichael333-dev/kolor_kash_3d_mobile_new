class ArtworkModel {
  final String id;
  final String userId;
  final String modelId;
  final String title;
  final String? description;
  final String imageUrl;
  final String? thumbnailUrl;
  final int likesCount;
  final int viewsCount;
  final bool isPublic;
  final bool isFeatured;
  final List<String> tags;
  final Map<String, dynamic> colorData;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Contest related
  final String? contestId;
  final double? contestScore;
  final int? contestRank;

  // NFT related
  final bool isMintedAsNFT;
  final String? nftId;

  ArtworkModel({
    required this.id,
    required this.userId,
    required this.modelId,
    required this.title,
    this.description,
    required this.imageUrl,
    this.thumbnailUrl,
    this.likesCount = 0,
    this.viewsCount = 0,
    this.isPublic = true,
    this.isFeatured = false,
    this.tags = const [],
    this.colorData = const {},
    required this.createdAt,
    required this.updatedAt,
    this.contestId,
    this.contestScore,
    this.contestRank,
    this.isMintedAsNFT = false,
    this.nftId,
  });

  factory ArtworkModel.fromFirestore(dynamic doc) {
    final data = (doc.data() as Map<String, dynamic>);
    return ArtworkModel(
      id: doc.id,
      userId: data['user_id'] as String,
      modelId: data['model_id'] as String,
      title: data['title'] as String,
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String,
      thumbnailUrl: data['thumbnail_url'] as String?,
      likesCount: data['likes_count'] as int? ?? 0,
      viewsCount: data['views_count'] as int? ?? 0,
      isPublic: data['is_public'] as bool? ?? true,
      isFeatured: data['is_featured'] as bool? ?? false,
      tags: List<String>.from(data['tags'] as List? ?? []),
      colorData: Map<String, dynamic>.from(data['color_data'] as Map? ?? {}),
      createdAt: DateTime.tryParse(data['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(data['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      contestId: data['contest_id'] as String?,
      contestScore: (data['contest_score'] as num?)?.toDouble(),
      contestRank: data['contest_rank'] as int?,
      isMintedAsNFT: data['is_minted_as_nft'] as bool? ?? false,
      nftId: data['nft_id'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'model_id': modelId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'likes_count': likesCount,
      'views_count': viewsCount,
      'is_public': isPublic,
      'is_featured': isFeatured,
      'tags': tags,
      'color_data': colorData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'contest_id': contestId,
      'contest_score': contestScore,
      'contest_rank': contestRank,
      'is_minted_as_nft': isMintedAsNFT,
      'nft_id': nftId,
    };
  }
}

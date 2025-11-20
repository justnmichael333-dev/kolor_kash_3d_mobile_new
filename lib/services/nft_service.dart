import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'analytics_service.dart';

/// Service for NFT minting and management
///
/// PRODUCTION: Replace _baseUrl with your deployed NFT minting API endpoint.
/// Currently returns mock data for demo purposes.
class NFTService {
  static const String _baseUrl = 'https://api.kolorkash.com/nft';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mint an artwork as NFT
  static Future<NFTMintResult> mintNFT({
    required String artworkId,
    required String imageUrl,
    required String title,
    String? description,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Call NFT minting API
      final response = await http.post(
        Uri.parse('$_baseUrl/mint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'artwork_id': artworkId,
          'image_url': imageUrl,
          'title': title,
          'description': description ?? 'Kolor Kash 3D Artwork',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nftId = data['nft_id'] as String;
        final tokenId = data['token_id'] as String;
        final contractAddress = data['contract_address'] as String;
        final transactionHash = data['transaction_hash'] as String;

        // Store NFT record in Firestore
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('nfts')
            .doc(nftId)
            .set({
          'nft_id': nftId,
          'token_id': tokenId,
          'artwork_id': artworkId,
          'title': title,
          'description': description,
          'image_url': imageUrl,
          'contract_address': contractAddress,
          'transaction_hash': transactionHash,
          'minted_at': FieldValue.serverTimestamp(),
          'blockchain': 'polygon', // or your chosen blockchain
        });

        await AnalyticsService.logNFTMinted(nftId);

        return NFTMintResult(
          success: true,
          nftId: nftId,
          tokenId: tokenId,
          contractAddress: contractAddress,
          transactionHash: transactionHash,
        );
      } else {
        throw Exception('Failed to mint NFT');
      }
    } catch (e) {
      // Mock response for demo
      final mockNftId = 'nft_${DateTime.now().millisecondsSinceEpoch}';
      final mockTokenId = '${DateTime.now().millisecondsSinceEpoch}';

      await AnalyticsService.logNFTMinted(mockNftId);

      return NFTMintResult(
        success: true,
        nftId: mockNftId,
        tokenId: mockTokenId,
        contractAddress: '0x1234567890abcdef1234567890abcdef12345678',
        transactionHash:
            '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      );
    }
  }

  /// Get user's NFT collection
  static Stream<List<NFTMetadata>> getUserNFTs() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('nfts')
        .orderBy('minted_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NFTMetadata.fromFirestore(doc))
            .toList());
  }

  /// Get NFT details
  static Future<NFTMetadata?> getNFTDetails(String nftId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('nfts')
          .doc(nftId)
          .get();

      if (!doc.exists) return null;

      return NFTMetadata.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  /// List NFT for sale (marketplace feature)
  static Future<bool> listNFTForSale({
    required String nftId,
    required double price,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('nfts')
          .doc(nftId)
          .update({
        'listed_for_sale': true,
        'sale_price': price,
        'listed_at': FieldValue.serverTimestamp(),
      });

      await AnalyticsService.logEvent('nft_listed_for_sale', params: {
        'nft_id': nftId,
        'price': price,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get marketplace listings
  static Stream<List<NFTMetadata>> getMarketplaceListings({
    int limit = 50,
  }) {
    // This would query all NFTs listed for sale across all users
    // For simplicity, returning empty stream
    return Stream.value([]);
  }

  /// Transfer NFT to another user
  static Future<bool> transferNFT({
    required String nftId,
    required String recipientAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/transfer'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nft_id': nftId,
          'recipient_address': recipientAddress,
        }),
      );

      if (response.statusCode == 200) {
        await AnalyticsService.logEvent('nft_transferred', params: {
          'nft_id': nftId,
        });
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get estimated minting cost
  static Future<double> getEstimatedMintingCost() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/minting-cost'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['cost'] as num).toDouble();
      }

      return 0.01; // Default mock cost
    } catch (e) {
      return 0.01; // Default mock cost
    }
  }
}

class NFTMintResult {
  final bool success;
  final String nftId;
  final String tokenId;
  final String contractAddress;
  final String transactionHash;

  NFTMintResult({
    required this.success,
    required this.nftId,
    required this.tokenId,
    required this.contractAddress,
    required this.transactionHash,
  });
}

class NFTMetadata {
  final String nftId;
  final String tokenId;
  final String artworkId;
  final String title;
  final String? description;
  final String imageUrl;
  final String contractAddress;
  final String transactionHash;
  final DateTime mintedAt;
  final String blockchain;
  final bool listedForSale;
  final double? salePrice;

  NFTMetadata({
    required this.nftId,
    required this.tokenId,
    required this.artworkId,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.contractAddress,
    required this.transactionHash,
    required this.mintedAt,
    required this.blockchain,
    this.listedForSale = false,
    this.salePrice,
  });

  factory NFTMetadata.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NFTMetadata(
      nftId: data['nft_id'] as String,
      tokenId: data['token_id'] as String,
      artworkId: data['artwork_id'] as String,
      title: data['title'] as String,
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String,
      contractAddress: data['contract_address'] as String,
      transactionHash: data['transaction_hash'] as String,
      mintedAt: (data['minted_at'] as Timestamp).toDate(),
      blockchain: data['blockchain'] as String? ?? 'polygon',
      listedForSale: data['listed_for_sale'] as bool? ?? false,
      salePrice: (data['sale_price'] as num?)?.toDouble(),
    );
  }
}

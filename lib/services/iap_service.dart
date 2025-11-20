import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'analytics_service.dart';
import 'kashes_service.dart';

/// Service for managing In-App Purchases
class IAPService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Product IDs
  static const String kashes100 = 'com.kolorkash.kashes.100';
  static const String kashes500 = 'com.kolorkash.kashes.500';
  static const String kashes1200 = 'com.kolorkash.kashes.1200';
  static const String premiumMonthly = 'com.kolorkash.premium.monthly';
  static const String premiumYearly = 'com.kolorkash.premium.yearly';

  static final List<String> _productIds = [
    kashes100,
    kashes500,
    kashes1200,
    premiumMonthly,
    premiumYearly,
  ];

  static List<ProductDetails> _products = [];
  static bool _isAvailable = false;

  /// Initialize IAP service
  static Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) {
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: _onDone,
      onError: _onError,
    );

    // Load products
    await loadProducts();
  }

  /// Load available products
  static Future<void> loadProducts() async {
    if (!_isAvailable) return;

    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_productIds.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      // Handle products not found
    }

    _products = response.productDetails;
  }

  /// Get available products
  static List<ProductDetails> get products => _products;

  /// Purchase Kashes
  static Future<void> purchaseKashes(int amount) async {
    if (!_isAvailable) throw Exception('IAP not available');

    String productId;
    switch (amount) {
      case 100:
        productId = kashes100;
        break;
      case 500:
        productId = kashes500;
        break;
      case 1200:
        productId = kashes1200;
        break;
      default:
        throw Exception('Invalid Kashes amount');
    }

    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  /// Purchase premium subscription
  static Future<void> purchaseSubscription(bool isYearly) async {
    if (!_isAvailable) throw Exception('IAP not available');

    final productId = isYearly ? premiumYearly : premiumMonthly;
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore purchases
  static Future<void> restorePurchases() async {
    if (!_isAvailable) return;
    await _iap.restorePurchases();
  }

  /// Handle purchase updates
  static void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  /// Handle individual purchase
  static Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Verify purchase with backend (in production)
      final isValid = await _verifyPurchase(purchaseDetails);

      if (isValid) {
        // Deliver the product
        await _deliverProduct(purchaseDetails);
      }
    }

    if (purchaseDetails.status == PurchaseStatus.error) {
      // Handle error
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await _iap.completePurchase(purchaseDetails);
    }
  }

  /// Verify purchase (should be done server-side in production)
  static Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // In production, send the purchase details to your server for verification
    // For now, we'll just return true
    return true;
  }

  /// Deliver the purchased product
  static Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    final productId = purchaseDetails.productID;

    // Deliver Kashes
    if (productId == kashes100) {
      await KashesService.addKashes(100, 'IAP: 100 Kashes pack');
      await AnalyticsService.logIAPPurchaseCompleted(productId, 0.99);
    } else if (productId == kashes500) {
      await KashesService.addKashes(500, 'IAP: 500 Kashes pack');
      await AnalyticsService.logIAPPurchaseCompleted(productId, 3.99);
    } else if (productId == kashes1200) {
      await KashesService.addKashes(1200, 'IAP: 1200 Kashes pack');
      await AnalyticsService.logIAPPurchaseCompleted(productId, 7.99);
    } else if (productId == premiumMonthly || productId == premiumYearly) {
      // Grant premium subscription
      // This would update user's subscription status in Firestore
      await AnalyticsService.logEvent('premium_subscribed', params: {
        'product_id': productId,
        'subscription_type': productId == premiumYearly ? 'yearly' : 'monthly',
      });
    }
  }

  /// Handle subscription completion
  static void _onDone() {
    _subscription?.cancel();
  }

  /// Handle errors
  static void _onError(dynamic error) {
    // Handle error
  }

  /// Dispose service
  static void dispose() {
    _subscription?.cancel();
  }
}

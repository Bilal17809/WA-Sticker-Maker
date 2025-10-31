import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '/core/theme/theme.dart';
import '/core/local_storage/local_storage.dart';
import '/ad_manager/ad_manager.dart';
import '/core/providers/providers.dart';

class PurchaseState {
  final bool purchasePending;
  final bool isAvailable;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;
  final String? queryProductError;

  PurchaseState({
    this.purchasePending = false,
    this.isAvailable = false,
    this.products = const [],
    this.purchases = const [],
    this.queryProductError,
  });

  PurchaseState copyWith({
    bool? purchasePending,
    bool? isAvailable,
    List<ProductDetails>? products,
    List<PurchaseDetails>? purchases,
    String? queryProductError,
  }) {
    return PurchaseState(
      purchasePending: purchasePending ?? this.purchasePending,
      isAvailable: isAvailable ?? this.isAvailable,
      products: products ?? this.products,
      purchases: purchases ?? this.purchases,
      queryProductError: queryProductError ?? this.queryProductError,
    );
  }
}

class PurchaseNotifier extends Notifier<PurchaseState> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final RemoveAdsNotifier removeAdsNotifier = RemoveAdsNotifier();
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final bool _kAutoConsume = Platform.isIOS;
  final List<String> _kProductIds = const [
    'consumable',
    'upgrade',
    'com.stickermaker.removeads',
  ];

  @override
  PurchaseState build() {
    init();
    ref.onDispose(() {
      _subscription.cancel();
    });
    return PurchaseState();
  }

  Future<void> init() async {
    _checkInternetConnection();
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onError: (error) {
        state = state.copyWith(purchasePending: false);
      },
    );
    await initStoreInfo();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      return;
    }
  }

  Future<void> initStoreInfo() async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      state = state.copyWith(
        isAvailable: false,
        products: [],
        purchases: [],
        queryProductError: null,
        purchasePending: false,
      );
      return;
    }

    final response = await _inAppPurchase.queryProductDetails(
      _kProductIds.toSet(),
    );
    if (response.error != null) {
      state = state.copyWith(
        queryProductError: response.error!.message,
        isAvailable: available,
      );
      return;
    }

    state = state.copyWith(
      isAvailable: available,
      products: response.productDetails,
    );
  }

  Future<void> buyProduct(
    ProductDetails product,
    PurchaseDetails? purchase,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.secondaryIcon(context)),
            SizedBox(width: 20),
            Text('Connecting to store...'),
          ],
        ),
      ),
    );

    try {
      final purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        changeSubscriptionParam:
            purchase != null && purchase is GooglePlayPurchaseDetails
            ? ChangeSubscriptionParam(oldPurchaseDetails: purchase)
            : null,
      );

      if (product.id == 'consumable') {
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (_) {
      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to initiate purchase')));
    }
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> detailsList,
  ) async {
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        state = state.copyWith(purchasePending: true);
      } else if (details.status == PurchaseStatus.error) {
        state = state.copyWith(purchasePending: false);
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        state = state.copyWith(purchasePending: false);

        final prefs = LocalStorage();
        await prefs.setBool('SubscribeWaStickerMaker', true);
        await prefs.setString('subscriptionAiId', details.productID);

        ref.read(removeAdsProvider.notifier).state = ref
            .read(removeAdsProvider.notifier)
            .state
            .copyWith(isSubscribed: true);

        if (details.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(details);
        }
      }
    }
  }

  Future<void> restorePurchases(BuildContext context) async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) return;

    state = state.copyWith(purchasePending: true);
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.secondaryIcon(context)),
            SizedBox(width: 20),
            Text('Restoring purchases...'),
          ],
        ),
      ),
    );

    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds: 15), () {
        if (state.purchasePending) {
          state = state.copyWith(purchasePending: false);
        }
      });
    } catch (_) {
      state = state.copyWith(purchasePending: false);
    }
  }
}

final purchaseProvider = NotifierProvider<PurchaseNotifier, PurchaseState>(
  PurchaseNotifier.new,
);

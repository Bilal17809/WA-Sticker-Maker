import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/premium_screen/widgets/premium_body.dart';
import '/presentation/premium_screen/widgets/product_list.dart';
import '/core/services/services.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseProvider);

    return SafeArea(
      child: PremiumBody(
        loading:
            !purchaseState.isAvailable &&
            purchaseState.queryProductError == null,
        purchasePending: purchaseState.purchasePending,
        queryProductError: purchaseState.queryProductError,
        onRestorePurchases: () =>
            ref.read(purchaseProvider.notifier).restorePurchases(context),
        productListBuilder: const ProductListWidget(),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/purchase_notifier_service.dart';

class ProductListWidget extends ConsumerWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseProvider);
    final removeAdsState = ref.watch(removeAdsProvider);
    final purchaseNotifier = ref.read(purchaseProvider.notifier);

    final products = purchaseState.products;
    final purchases = purchaseState.purchases;
    final isSubscribed = removeAdsState.isSubscribed;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isSmallScreen = width < 600;
    final horizontalPadding = width * 0.02;
    final verticalPadding = height * 0.01;

    final purchaseMap = {for (var p in purchases) p.productID: p};

    return Column(
      children: products.map((product) {
        final purchase = purchaseMap[product.id];

        if (isSubscribed) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: const Text(
              "You are on the ads-free version!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          );
        }

        return Card(
          color: Colors.blue.shade300,
          elevation: 1.0,
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ListTile(
            title: Text(
              'Life Time Subscription',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : height * 0.02,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              product.description,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : height * 0.02,
                color: Colors.white,
              ),
            ),
            trailing: Text(
              product.price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: isSmallScreen ? 16 : height * 0.02,
              ),
            ),
            onTap: () =>
                purchaseNotifier.buyProduct(product, purchase, context),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/theme/theme.dart';
import '/presentation/terms/terms_view.dart';
import '/core/common_widgets/common_widgets.dart';

class PremiumBody extends ConsumerWidget {
  final bool loading;
  final bool purchasePending;
  final String? queryProductError;
  final VoidCallback onRestorePurchases;
  final Widget productListBuilder;
  final VoidCallback onClose;

  const PremiumBody({
    super.key,
    required this.loading,
    required this.purchasePending,
    required this.queryProductError,
    required this.onRestorePurchases,
    required this.productListBuilder,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.secondaryIcon(context),
        ),
      );
    }
    if (queryProductError != null) {
      return Center(child: Text(queryProductError!));
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isSmallScreen = width < 600;

    final items = [
      {'icon': 'images/ai.png', 'text': 'AI Generation'},
      {'icon': 'images/customization.png', 'text': 'Customized Stickers'},
      {'icon': 'images/lib_pack.png', 'text': 'Huge Library'},
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  height: height * 0.32,
                  color: AppColors.primaryColorLight,
                ),
                Container(
                  height: height * 0.19,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, -100),
                        blurRadius: 110,
                        spreadRadius: 90,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.04),
                      SizedBox(
                        height: isSmallScreen ? 100 : height * 0.16,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: width * 0.4,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                padding: const EdgeInsets.all(8),
                                decoration: AppDecorations.simpleRounded(
                                  context,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        items[index]['icon'] as String,
                                        width: isSmallScreen
                                            ? 55
                                            : height * 0.08,
                                        height: isSmallScreen
                                            ? 55
                                            : height * 0.08,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 6),
                                      Flexible(
                                        child: Text(
                                          items[index]['text'] as String,
                                          style: TextStyle(
                                            fontSize: isSmallScreen
                                                ? 12
                                                : height * 0.016,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textBlackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      productListBuilder,
                      Column(
                        children: [
                          const Text(
                            '>> Cancel anytime at least 24 hours before renewal',
                            style: TextStyle(
                              color: AppColors.textBlackColor,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: const Text("Privacy | Terms"),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const TermsView(),
                                    ),
                                  );
                                },
                              ),
                              const Text("Cancel Anytime"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassButton(icon: Icons.clear, onTap: onClose),
                GlassButton(
                  text: "Restore",
                  width: 70,
                  onTap: onRestorePurchases,
                ),
              ],
            ),
          ),
          Positioned(
            left: width * 0.08,
            right: width * 0.08,
            top: height * 0.36,
            child: const Text(
              "Create Stickers with Ease",
              style: TextStyle(
                color: AppColors.primaryColorLight,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            left: width * 0.08,
            right: width * 0.08,
            top: height * 0.42,
            child: const Text(
              "AI-powered tools, ready-made templates, and smart editing to bring your stickers to life.",
              style: TextStyle(color: AppColors.textBlackColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: height * 0.02,
            left: width * 0.20,
            right: width * 0.20,
            child: Image.asset(
              'images/icon.png',
              height: height * 0.34,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: width * 0.65,
            right: width * 0.01,
            top: height * 0.70,
            child: Image.asset("images/offer.png", height: 64, width: 64),
          ),
          if (purchasePending)
            const Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

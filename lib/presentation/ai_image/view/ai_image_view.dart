import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/ad_manager/ad_manager.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/services/connectivity_service.dart';
import 'widgets/widgets.dart';

class AiImageView extends ConsumerWidget {
  final AiPacksState pack;
  const AiImageView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interstitialState = ref.watch(interstitialAdManagerProvider);

    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((isConnected) {
        if (isConnected) {
          ConnectivityDialog.closeIfOpen(context);
        } else {
          ConnectivityDialog.showNoInternetDialog(
            context,
            onRetry: () async {},
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.secondary(context),
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: 'AI Sticker Generator',
        actions: [DownloadOrAddButton(pack: pack)],
      ),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Column(
              spacing: kElementGap,
              children: const [
                PromptInputSection(),
                Expanded(child: ImagesSection()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: interstitialState.isShow
          ? const SizedBox()
          : const BannerAdWidget(),
    );
  }
}

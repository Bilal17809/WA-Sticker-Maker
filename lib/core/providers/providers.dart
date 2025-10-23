import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/presentation/built_in_packs/provider/built_in_packs_notifier.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';
import '/presentation/report/provider/report_notifier.dart';
import '/presentation/report/provider/report_state.dart';
import '/presentation/ai_pack_gallery/provider/ai_pack_gallery_notifier.dart';
import '/presentation/ai_pack_gallery/provider/ai_pack_gallery_state.dart';
import '/presentation/ai_pack/provider/ai_packs_notifier.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/presentation/ai_image/provider/ai_image_notifier.dart';
import '/presentation/ai_image/provider/ai_image_state.dart';
import '/presentation/library_pack/provider/library_pack_notifier.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/presentation/library_pack_gallery/provider/library_pack_gallery_notifier.dart';
import '/presentation/library_pack_gallery/provider/library_pack_gallery_state.dart';
import '/core/services/services.dart';
import '/presentation/splash/provider/splash_notifier.dart';
import '/presentation/splash/provider/splash_state.dart';
import '/presentation/pack_gallery/provider/pack_gallery_state.dart';
import '/presentation/pack_gallery/provider/pack_gallery_notifier.dart';
import '/presentation/packs/provider/packs_notifier.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/presentation/gallery/provider/gallery_notifier.dart';
import '/presentation/gallery/provider/gallery_state.dart';
import '/presentation/library/provider/library_notifier.dart';
import '/presentation/library/provider/library_state.dart';
import '/presentation/home/provider/home_notifier.dart';
import '/presentation/home/provider/home_state.dart';
import '/core/local_storage/local_storage.dart';
import '/ad_manager/ad_manager.dart';
import 'dialog_visibility_notifier.dart';

/// Core
final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final packExportServiceProvider = Provider<PackExportService>((ref) {
  return PackExportService();
});

/// Providers
final splashProvider = NotifierProvider<SplashNotifier, SplashState>(
  SplashNotifier.new,
);

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

final libraryProvider = NotifierProvider<LibraryNotifier, LibraryState>(
  LibraryNotifier.new,
);

final packsProvider = NotifierProvider<PacksNotifier, List<PacksState>>(
  PacksNotifier.new,
);

final aiPacksProvider = NotifierProvider<AiPacksNotifier, List<AiPacksState>>(
  AiPacksNotifier.new,
);

final libraryPacksProvider =
    NotifierProvider<LibraryPacksNotifier, List<LibraryPacksState>>(
      LibraryPacksNotifier.new,
    );

final libraryPackGalleryProvider =
    NotifierProvider<LibraryPackGalleryNotifier, LibraryPackGalleryState>(
      LibraryPackGalleryNotifier.new,
    );

final aiPackGalleryProvider =
    NotifierProvider<AiPackGalleryNotifier, AiPackGalleryState>(
      AiPackGalleryNotifier.new,
    );

final packGalleryProvider =
    NotifierProvider<PackGalleryNotifier, PackGalleryState>(
      PackGalleryNotifier.new,
    );

final galleryProvider = NotifierProvider<GalleryNotifier, GalleryState>(
  GalleryNotifier.new,
);

final freepikImageNotifierProvider =
    NotifierProvider<AIImageNotifier, AiImageState>(AIImageNotifier.new);

final removeAdsProvider = NotifierProvider<RemoveAdsNotifier, RemoveAdsState>(
  RemoveAdsNotifier.new,
);

final interstitialAdManagerProvider =
    NotifierProvider<InterstitialAdManager, InterstitialAdState>(
      InterstitialAdManager.new,
    );

final appOpenAdManagerProvider =
    NotifierProvider<AppOpenAdManager, AppOpenAdState>(AppOpenAdManager.new);

final splashInterstitialManagerProvider =
    NotifierProvider<SplashInterstitialManager, SplashInterstitialState>(
      SplashInterstitialManager.new,
    );

final nativeAdManagerProvider =
    NotifierProvider.family<NativeAdManager, NativeAdState, TemplateType>(
      NativeAdManager.new,
    );

final dialogVisibilityProvider =
    NotifierProvider<DialogVisibilityNotifier, bool>(
      DialogVisibilityNotifier.new,
    );

final reportNotifierProvider = NotifierProvider<ReportNotifier, ReportState>(
  () => ReportNotifier(),
);

final builtInPacksProvider =
    NotifierProvider<BuiltInPacksNotifier, List<BuiltInPacksState>>(
      BuiltInPacksNotifier.new,
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_sticker_maker/presentation/library_pack/provider/library_pack_notifier.dart';
import 'package:wa_sticker_maker/presentation/library_pack/provider/library_pack_state.dart';
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
import '/core/theme/theme.dart';
import '/presentation/home/provider/home_notifier.dart';
import '/presentation/home/provider/home_state.dart';
import '/core/local_storage/local_storage.dart';

/// Core
final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());
final themeProvider = NotifierProvider<ThemeProvider, ThemeState>(
  ThemeProvider.new,
);
final packExportServiceProvider = Provider<PackExportService>((ref) {
  return PackExportService();
});

/// Providers
final splashProvider = NotifierProvider<SplashNotifier, SplashState>(
  () => SplashNotifier(),
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
final libraryPacksProvider =
    NotifierProvider<LibraryPacksNotifier, List<LibraryPacksState>>(
      LibraryPacksNotifier.new,
    );
final packGalleryProvider =
    NotifierProvider<PackGalleryNotifier, PackGalleryState>(
      PackGalleryNotifier.new,
    );
final galleryProvider = NotifierProvider<GalleryNotifier, GalleryState>(
  GalleryNotifier.new,
);

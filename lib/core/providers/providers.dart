import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_sticker_maker/presentation/packs/provider/packs_provider.dart';
import 'package:wa_sticker_maker/presentation/packs/provider/packs_state.dart';
import '/presentation/gallery/provider/gallery_provider.dart';
import '/presentation/gallery/provider/gallery_state.dart';
import '/presentation/library/provider/library_provider.dart';
import '/presentation/library/provider/library_state.dart';
import '/core/theme/theme.dart';
import '/presentation/home/provider/home_provider.dart';
import '/presentation/home/provider/home_state.dart';
import '/core/local_storage/local_storage.dart';

/// Core
final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());
final themeProvider = NotifierProvider<ThemeProvider, ThemeState>(
  ThemeProvider.new,
);

/// Providers
final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);
final libraryProvider = NotifierProvider<LibraryProvider, LibraryState>(
  LibraryProvider.new,
);
final galleryProvider = NotifierProvider<GalleryProvider, GalleryState>(
  GalleryProvider.new,
);
final packsProvider = NotifierProvider<PacksNotifier, List<PacksState>>(
  PacksNotifier.new,
);

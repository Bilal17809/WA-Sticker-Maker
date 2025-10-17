import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/helper/helper.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/core/common/app_exceptions.dart';
import '/core/providers/providers.dart';
import '/core/services/services.dart';
import '/core/config/client.dart';
import '/data/data_source/klipy_data_source.dart';
import '/data/repo_impl/klipy_repo_impl.dart';
import '/data/models/models.dart';
import '/domain/use_cases/get_klipy_stickers.dart';
import 'library_state.dart';

class LibraryNotifier extends Notifier<LibraryState> {
  late final _stickerService = StickerService(
    GetKlipyStickers(KlipyRepoImpl(KlipyDataSource(klipyApiKey))),
  );
  late final _fetchService = FetchService();
  late final _downloadService = StickerDownloadService();
  Timer? _debounce;
  String? _query;

  @override
  LibraryState build() {
    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (_, next) {
      next.whenData((connected) async {
        state = state.copyWith(isConnected: connected);
        if (connected &&
            !state.isLoading &&
            !(state.stickerResponse?.hasData ?? false)) {
          await loadTrending();
        }
      });
    });
    ref.onDispose(() {
      _debounce?.cancel();
      _downloadService.dispose();
    });
    return const LibraryState();
  }

  Future<void> loadTrending() async => _load(fetchTrending, resetQuery: true);

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final trimmed = query.trim();
      _load(
        trimmed.isEmpty ? fetchTrending : () => _stickerService.search(trimmed),
        resetQuery: trimmed.isEmpty,
      );
    });
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore ||
        !(state.stickerResponse?.hasData ?? false)) {
      return;
    }

    final nextPage = state.stickerResponse!.currentPage + 1;
    final fetcher = (_query?.isNotEmpty ?? false)
        ? () => _stickerService.search(_query!, page: nextPage)
        : () => _stickerService.getTrending(page: nextPage);
    state = state.copyWith(isLoadingMore: true);
    await _load(fetcher, append: true);
    state = state.copyWith(isLoadingMore: false);
  }

  Future<void> _load(
    Future<StickerResponseModel> Function() fetcher, {
    bool append = false,
    bool resetQuery = false,
  }) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(milliseconds: 50));

    state = await _fetchService.fetch(
      currentState: state,
      fetcher: fetcher,
      append: append,
    );
    if (resetQuery) _query = null;
    state = state.copyWith(isLoading: false);
  }

  Future<StickerResponseModel> fetchTrending({int page = 1}) =>
      _stickerService.getTrending(page: page, perPage: 20);

  void selectSticker(String id) {
    final selected = {...state.selectedStickerIds};
    selected.contains(id) ? selected.remove(id) : selected.add(id);
    state = state.copyWith(selectedStickerIds: selected);
  }

  Future<bool> downloadAndAddToPack(LibraryPacksState pack) async {
    if (state.selectedStickerIds.isEmpty) return false;
    final stickers =
        state.stickerResponse?.stickers
            .where((s) => state.selectedStickerIds.contains(s.id))
            .toList() ??
        [];
    if (stickers.isEmpty) return false;

    state = state.copyWith(isDownloading: true);
    try {
      final paths = await _downloadService.downloadStickers(
        stickers: stickers,
        targetDirectory: pack.directoryPath,
        convertToWebP: true,
      );
      if (paths.isNotEmpty) _updatePack(pack, paths);
      state = state.copyWith(selectedStickerIds: {});
      return paths.isNotEmpty;
    } catch (e) {
      state = state.copyWith(
        errorMessage: '${AppExceptions().errorDownloadingPack}: $e',
      );
      return false;
    } finally {
      state = state.copyWith(isDownloading: false);
    }
  }

  void _updatePack(LibraryPacksState pack, List<String> paths) {
    final packNotifier = ref.read(libraryPacksProvider.notifier);
    ApiPackHelper.updatePackGeneric(
      ref: ref,
      state: packNotifier.state,
      onUpdate: packNotifier.updatePack,
      pack: pack,
      paths: paths,
    );
  }
}

extension _StickerResponseExt on StickerResponseModel? {
  bool get hasData => this?.stickers.isNotEmpty ?? false;
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

typedef Fetcher = Future<StickerResponseModel> Function();

class LibraryNotifier extends Notifier<LibraryState> {
  late final StickerService _stickerService;
  late final FetchService _fetchService;
  late final StickerDownloadService _downloadService;
  Timer? _debounce;
  String? _currentQuery;

  @override
  LibraryState build() {
    final dataSource = KlipyDataSource(klipyApiKey);
    final repo = KlipyRepoImpl(dataSource);
    final useCase = GetKlipyStickers(repo);
    _stickerService = StickerService(useCase);
    _fetchService = FetchService();
    _downloadService = StickerDownloadService();

    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((isConnected) async {
        state = state.copyWith(isConnected: isConnected);
        if (isConnected &&
            !state.isLoading &&
            !(state.stickerResponse?.stickers.isNotEmpty ?? false)) {
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

  Future<void> loadTrending() async {
    state = await _fetchService.fetch(
      currentState: state,
      fetcher: () => _stickerService.getTrending(page: 1, perPage: 20),
      append: false,
    );
    _currentQuery = null;
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final trimmed = query.trim();
      _currentQuery = trimmed.isEmpty ? null : trimmed;

      state = await _fetchService.fetch(
        currentState: state,
        fetcher: trimmed.isEmpty
            ? () => _stickerService.getTrending(page: 1, perPage: 20)
            : () => _stickerService.search(trimmed, page: 1, perPage: 20),
        append: false,
      );
    });
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    if (!(state.stickerResponse?.stickers.isNotEmpty ?? false)) return;
    final nextPage = state.stickerResponse!.currentPage + 1;
    final fetcher = (_currentQuery?.isNotEmpty ?? false)
        ? () => _stickerService.search(
            _currentQuery!,
            page: nextPage,
            perPage: 20,
          )
        : () => _stickerService.getTrending(page: nextPage, perPage: 20);

    state = await _fetchService.fetch(
      currentState: state,
      fetcher: fetcher,
      append: true,
    );
  }

  void selectSticker(String stickerId) {
    final selection = Set<String>.from(state.selectedStickerIds);
    selection.contains(stickerId)
        ? selection.remove(stickerId)
        : selection.add(stickerId);
    state = state.copyWith(selectedStickerIds: selection);
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
      final paths = await _downloadStickers(stickers, pack.directoryPath);
      if (paths.isNotEmpty) {
        _updatePack(pack, paths);
      }
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

  Future<List<String>> _downloadStickers(
    List<StickerModel> stickers,
    String directory,
  ) {
    return _downloadService.downloadStickers(
      stickers: stickers,
      targetDirectory: directory,
      convertToWebP: true,
    );
  }

  void _updatePack(LibraryPacksState pack, List<String> paths) {
    final packNotifier = ref.read(libraryPacksProvider.notifier);
    final index = packNotifier.state.indexWhere(
      (p) => p.directoryPath == pack.directoryPath,
    );
    if (index == -1) return;
    final current = packNotifier.state[index];
    final updated = current.copyWith(
      stickerPaths: [...current.stickerPaths, ...paths],
      trayImagePath: current.stickerPaths.isEmpty
          ? paths.first
          : current.trayImagePath,
    );
    packNotifier.updatePack(index, updated);
  }
}

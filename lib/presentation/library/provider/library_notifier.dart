import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/models/models.dart';
import '/core/config/client.dart';
import '/data/data_source/klipy_data_source.dart';
import '/data/repo_impl/klipy_repo_impl.dart';
import '/domain/use_cases/get_klipy_stickers.dart';
import 'library_state.dart';

class LibraryNotifier extends Notifier<LibraryState> {
  late final GetKlipyStickers _getStickers;
  Timer? _debounce;
  String? _currentQuery;

  @override
  LibraryState build() {
    final dataSource = KlipyDataSource(klipyApiKey);
    final repo = KlipyRepoImpl(dataSource);
    _getStickers = GetKlipyStickers(repo);
    ref.onDispose(() {
      _debounce?.cancel();
    });
    return const LibraryState();
  }

  Future<void> loadTrending() {
    debugPrint('[LibraryNotifier] Loading trending stickers page 1');
    return _fetch(
      () => _getStickers.trending(page: 1, perPage: 20),
      append: false,
    )..then((_) {
      _currentQuery = null;
    });
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final trimmed = query.trim();
      _currentQuery = trimmed.isEmpty ? null : trimmed;
      if (trimmed.isEmpty) {
        debugPrint('[LibraryNotifier] Search cleared → loadTrending()');
        loadTrending();
      } else {
        debugPrint('[LibraryNotifier] Searching "$trimmed" page 1');
        _fetch(
          () => _getStickers.search(trimmed, page: 1, perPage: 20),
          append: false,
        );
      }
    });
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore) {
      debugPrint('[LibraryNotifier] Skipping loadMore (already loading)');
      return;
    }
    if (!(state.stickerResponse?.stickers.isNotEmpty ?? false)) {
      return;
    }
    if (!state.hasMore) {
      return;
    }
    final nextPage = state.stickerResponse!.currentPage + 1;
    if (_currentQuery != null && _currentQuery!.isNotEmpty) {
      await _fetch(
        () => _getStickers.search(_currentQuery!, page: nextPage, perPage: 20),
        append: true,
      );
    } else {
      await _fetch(
        () => _getStickers.trending(page: nextPage, perPage: 20),
        append: true,
      );
    }
  }

  Future<void> _fetch(
    Future<StickerResponseModel> Function() fetcher, {
    bool append = false,
  }) async {
    if (append) {
      state = state.copyWith(isLoadingMore: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }
    try {
      final res = await fetcher();
      if (append) {
        final existing = state.stickerResponse?.stickers ?? <StickerModel>[];
        final combined = [...existing, ...res.stickers];

        final mergedResponse = StickerResponseModel(
          stickers: combined,
          currentPage: res.currentPage,
          perPage: res.perPage,
          hasNext: res.hasNext,
        );

        state = state.copyWith(
          stickerResponse: mergedResponse,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(stickerResponse: res, errorMessage: null);
      }
    } catch (e) {
      if (append) {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          stickerResponse: StickerResponseModel(
            stickers: [],
            currentPage: 1,
            perPage: 0,
            hasNext: false,
          ),
        );
      }
      return;
    } finally {
      if (append) {
        state = state.copyWith(isLoadingMore: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}

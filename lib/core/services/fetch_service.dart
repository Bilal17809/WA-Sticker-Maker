import '/presentation/library/provider/library_state.dart';
import '/data/models/models.dart';

typedef Fetcher = Future<StickerResponseModel> Function();

class FetchService {
  Future<LibraryState> fetch({
    required LibraryState currentState,
    required Fetcher fetcher,
    bool append = false,
  }) async {
    var nextState = _startLoading(currentState, append);
    try {
      final response = await fetcher();
      nextState = _handleSuccess(response, nextState, append);
    } catch (e) {
      nextState = _handleError(e, nextState, append);
    }
    nextState = _finishLoading(nextState, append);
    return nextState;
  }

  LibraryState _startLoading(LibraryState state, bool append) {
    return append
        ? state.copyWith(isLoadingMore: true, errorMessage: null)
        : state.copyWith(isLoading: true, errorMessage: null);
  }

  LibraryState _handleSuccess(
    StickerResponseModel res,
    LibraryState state,
    bool append,
  ) {
    if (append) {
      final existing = state.stickerResponse?.stickers ?? <StickerModel>[];
      final combined = [...existing, ...res.stickers];
      final mergedResponse = StickerResponseModel(
        stickers: combined,
        currentPage: res.currentPage,
        perPage: res.perPage,
        hasNext: res.hasNext,
      );
      return state.copyWith(
        stickerResponse: mergedResponse,
        errorMessage: null,
      );
    } else {
      return state.copyWith(stickerResponse: res, errorMessage: null);
    }
  }

  LibraryState _handleError(Object e, LibraryState state, bool append) {
    if (append) {
      return state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    } else {
      return state.copyWith(
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
  }

  LibraryState _finishLoading(LibraryState state, bool append) {
    return append
        ? state.copyWith(isLoadingMore: false)
        : state.copyWith(isLoading: false);
  }
}

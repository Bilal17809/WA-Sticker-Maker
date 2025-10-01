import 'dart:async';
import 'package:flutter/material.dart';
import '/core/config/client.dart';
import '/data/data_source/klipy_data_source.dart';
import '/data/models/sticker_response_model.dart';
import '/data/repo_impl/klipy_repo_impl.dart';
import '/domain/use_cases/get_klipy_stickers.dart';

class StickerPage extends StatefulWidget {
  const StickerPage({super.key});

  @override
  State<StickerPage> createState() => _StickerPageState();
}

class _StickerPageState extends State<StickerPage> {
  late GetKlipyStickers getStickersUseCase;
  StickerResponseModel? stickerResponse;
  String? errorMessage;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final dataSource = KlipyDataSource(klipyApiKey);
    final repo = KlipyRepoImpl(dataSource);
    getStickersUseCase = GetKlipyStickers(repo);
    fetchTrending();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchStickers(_searchController.text);
    });
  }

  Future<void> fetchTrending() async {
    await _fetchStickers(() => getStickersUseCase.trending(perPage: 20));
  }

  Future<void> searchStickers(String query) async {
    if (query.isEmpty) {
      fetchTrending();
      return;
    }
    await _fetchStickers(() => getStickersUseCase.search(query, perPage: 20));
  }

  Future<void> _fetchStickers(
    Future<StickerResponseModel> Function() fetcher,
  ) async {
    setState(() {
      stickerResponse = null;
      errorMessage = null;
      isLoading = true;
    });

    try {
      final res = await fetcher();
      setState(() => stickerResponse = res);
    } catch (e, st) {
      print('Error fetching stickers: $e\n$st');
      setState(() {
        errorMessage = e.toString();
        stickerResponse = StickerResponseModel(
          stickers: [],
          currentPage: 1,
          totalPages: 1,
          perPage: 0,
          total: 0,
        );
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search stickers...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final stickers = stickerResponse?.stickers ?? [];

    if (errorMessage != null && stickers.isEmpty) {
      return _buildMessage(
        'Failed to load stickers',
        errorMessage!,
        'Retry',
        fetchTrending,
      );
    }

    if (stickers.isEmpty) {
      return _buildMessage(
        'No stickers available',
        '',
        'Refresh',
        fetchTrending,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: stickers.length,
      itemBuilder: (_, i) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          stickers[i].imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorBuilder: (_, error, __) => Container(
            color: Colors.grey.shade800,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
        ],
      ),
    );
  }
}

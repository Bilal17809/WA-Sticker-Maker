import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/local_storage/local_storage.dart';
import '/core/theme/theme.dart';
import '/core/providers/providers.dart';

class ThemeProvider extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    _loadTheme();
    return const ThemeState();
  }

  Future<void> _loadTheme() async {
    final isDark = await _localStorage.getBool('isDarkMode');
    if (isDark != null) {
      state = state.copyWith(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    state = state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
    await _localStorage.setBool('isDarkMode', isDark);
  }

  LocalStorage get _localStorage => ref.read(localStorageProvider);
}

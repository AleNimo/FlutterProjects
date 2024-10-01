import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/theme/app_theme.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  void setColorTheme(Color color) {
    state = state.copyWith(selectedColor: color);
  }
}

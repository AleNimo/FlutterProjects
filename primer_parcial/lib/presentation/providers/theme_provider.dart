import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/theme/app_theme.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorTheme(Color color) {
    state = state.copyWith(selectedColor: color);
  }
}

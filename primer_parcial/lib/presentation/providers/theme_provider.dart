import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  Color? selectedColor;
  bool? isDarkMode;

  ThemeNotifier({this.selectedColor, this.isDarkMode}) : super(AppTheme()) {
    state =
        state.copyWith(selectedColor: selectedColor, isDarkMode: isDarkMode);
  }

  void toggleDarkMode() async {
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setBool('dark_mode', !state.isDarkMode);
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorTheme(Color color) async {
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setInt('theme_color', color.value);
    state = state.copyWith(selectedColor: color);
  }
}

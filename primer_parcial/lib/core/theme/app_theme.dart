import 'package:flutter/material.dart';

class AppTheme {
  final Color selectedColor;
  final bool isDarkMode;

  AppTheme(
      {this.selectedColor = const Color.fromARGB(255, 255, 0, 0),
      this.isDarkMode = false});

  ThemeData getTheme() {
    return ThemeData(
        colorSchemeSeed: selectedColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ));
  }

  AppTheme copyWith({
    Color? selectedColor,
    bool? isDarkMode,
  }) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

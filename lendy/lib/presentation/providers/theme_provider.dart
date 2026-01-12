import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    // Handle system mode: check actual brightness and toggle accordingly
    if (state == ThemeMode.system) {
      // Get the current brightness from the system
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      // Toggle to the opposite of current system brightness
      state = brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Toggle between light and dark
      state = state == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    }
  }
}

final themeModeNotifierProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeModeNotifierProvider);
});

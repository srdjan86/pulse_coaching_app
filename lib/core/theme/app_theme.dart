import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({required Color seedColor}) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      useMaterial3: true,
    );
  }

  static Color seedColorForFlavor(String flavor) {
    return switch (flavor) {
      'prod' => Colors.indigo,
      'staging' => Colors.orange,
      _ => Colors.teal,
    };
  }
}

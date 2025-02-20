import 'package:flutter/material.dart';

class JWBThemes {
  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF233882),
    brightness: Brightness.dark,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.black54,
      selectionHandleColor: Colors.white,
    ),
  );
}

class JWBColors {
  static final txtEntryBG = const Color(0xFF232323);
  static final txtEntryFocused = const Color(0xFFBBBBBB);
  static final txtEntryUnfocused = const Color(0xFF66666D);

  static final systemNavbar = const Color(0xFF131313);
}
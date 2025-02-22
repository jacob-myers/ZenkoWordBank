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
  static const txtEntryBG = Color(0xFF232323);
  static const txtEntryFocused = Color(0xFFBBBBBB);
  static const txtEntryUnfocused = Color(0xFF66666D);

  static const systemNavbar = Color(0xFF131313);

  static const entryBackground = Color(0xFFA82E3E);
  static const entryTextMain = Color(0xFFFFFFFF);
  static const entryButton = Color(0xFFFFFFFF);
  
  static const navbarItemSelected = Color(0xFFFFFFFF);
  static const navbarItemUnselected = Color(0xFFAEAEAE);
}

class JWBGradients {
  static const entryGradient = LinearGradient(
      colors: <Color> [
        Color(0xFFBA2C41),
        Color(0xFF9E2232),
      ]
  );
}

class JWBTextStyles {
  static const termEnglish = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 22,
  );
  static const termJapMain = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 26
  );
  static const termReading = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 18
  );
  static const termRomaji = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 14
  );
}
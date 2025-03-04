import 'package:flutter/material.dart';

class JWBThemes {
  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF233882),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
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
  static const txtFaded = Color(0xFFA1A1A1);
  static const entryButton = Color(0xFFFFFFFF);
  
  static const navbarItemSelected = Color(0xFFFFFFFF);
  static const navbarItemUnselected = Color(0xFFAEAEAE);

  static const newTermButtonConfirm = Color(0xFFA82E3E);
  static const newTermButtonCancel = Color(0xFF575757);
  static const newTermDropdownBackground = Color(0xFF3E3E3E);

  static const autotranslateEnabled = Color(0xFFFFFFFF);
  static const autotranslateDisabled = Color(0xFFA1A1A1);
  static const autotranslateEnabledBG = Color(0xFF404040);
  static const autotranslateDisabledBG = Color(0xFF232323);

  static const translateResultBackground = Color(0xFF676767);
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
  static const bodyText = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 14,
  );
  static const headerText = TextStyle(
    color: JWBColors.txtFaded,
    fontSize: 24,
  );
  static const homeCardText = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 20,
  );

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

  static const newTermEnglish = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 22
  );
  static const newTermJap = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 26
  );
  static const newTermReading = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 22
  );
  static const newTermRomaji = TextStyle(
      color: JWBColors.txtFaded,
      fontSize: 18
  );
  static const termJapMainDropdown = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 22
  );
  static const termJapMainDropdownDefinition = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 16
  );
  static const newTermButton = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 16
  );

  static const translateResultEn = TextStyle(
    color: JWBColors.entryTextMain,
    fontSize: 14
  );
  static const translateResultMain = TextStyle(
      color: JWBColors.entryTextMain,
      fontSize: 30
  );
}
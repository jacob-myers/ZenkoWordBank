import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
import 'home.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

void main() {
  var style = const SystemUiOverlayStyle(
      systemNavigationBarColor: JWBColors.systemNavbar
  );
  SystemChrome.setSystemUIOverlayStyle(style);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenko Word Bank',
      theme: JWBThemes.darkTheme,
      home: const MyHomePage(title: 'Zenko Word Bank'),
    );
  }
}
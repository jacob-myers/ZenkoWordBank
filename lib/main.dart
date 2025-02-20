import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
import 'package:japanese_word_bank/themes.dart';

import 'home.dart';

void main() {
  var style = SystemUiOverlayStyle(
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
      title: 'Japanese Word Bank',
      theme: JWBThemes.darkTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
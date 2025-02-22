import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageTranslate extends StatefulWidget {
  const PageTranslate({super.key});

  @override
  State<StatefulWidget> createState() => _PageTranslate();
}

class _PageTranslate extends State<PageTranslate> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Card(
          child: Text("Hi"),
        )
      ],
    );
  }
}
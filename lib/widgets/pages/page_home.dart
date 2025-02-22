import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<StatefulWidget> createState() => _PageHome();
}

class _PageHome extends State<PageHome> {

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
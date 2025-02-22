import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageWords extends StatefulWidget {
  const PageWords({super.key});

  @override
  State<StatefulWidget> createState() => _PageWords();
}

class _PageWords extends State<PageWords> {
  List<TermEntry> entries = [
    TermEntry(en_term: "Hello", reading: "こんにちは"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ")
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView(
                children: List.generate(entries.length, (i) {
                  return TermCard(term: entries[i]);
                })
            )
        ),
        Container(
          decoration: BoxDecoration(
              color: JWBColors.txtEntryBG
          ),
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextField(
            style: TextStyle(
              fontSize: 20,
            ),
            maxLines: 1,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryUnfocused, width: 2),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                ),
                hintStyle: TextStyle(
                    color: JWBColors.txtEntryUnfocused
                ),
                hintText: "English or Romaji..."
            ),
          ),
        ),
      ],
    );
  }
}
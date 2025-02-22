import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/themes.dart';

class TermCard extends StatefulWidget {
  final TermEntry term;

  TermCard({
    required this.term,
  });

  @override
  State<StatefulWidget> createState() => _TermCard();
}

class _TermCard extends State<TermCard> {

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 2),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: JWBColors.entryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.term.en_term, style: JWBTextStyles.termEnglish),
                  Text(widget.term.ja_term, style: JWBTextStyles.termJapMain),
                  widget.term.k_term != null ? Text(widget.term.reading, style: JWBTextStyles.termReading) : Container(),
                  Text(widget.term.romaji, style: JWBTextStyles.termRomaji),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  child: Container(
                    child: const Icon(
                      Icons.edit,
                      color: JWBColors.entryButton,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
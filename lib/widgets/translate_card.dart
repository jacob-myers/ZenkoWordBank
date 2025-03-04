import 'package:flutter/material.dart';
import 'package:japanese_word_bank/classes/en_ja_pair.dart';

// Local
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class TranslateCard extends StatefulWidget {
  final EnJaPair term;

  TranslateCard({
    super.key,
    required this.term,
  });

  @override
  State<StatefulWidget> createState() => _TranslateCard();
}

class _TranslateCard extends State<TranslateCard> {
  int maxTextLen = 70;

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 2),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: JWBColors.translateResultBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.term.en_term.length > maxTextLen ? "${widget.term.en_term.substring(0, maxTextLen)}..." : widget.term.en_term,
                      style: JWBTextStyles.translateResultEn
                  ),
                  Text(widget.term.ja_term, style: JWBTextStyles.translateResultMain),
                  widget.term.k_term != null ? Text(widget.term.reading, style: JWBTextStyles.termReading) : Container(),
                  Text(widget.term.romaji, style: JWBTextStyles.termRomaji),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    size: 35,
                    color: JWBColors.entryButton,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return  Dialog.fullscreen(
                          child: TermEditor(
                            term: TermEntry.fromEnJaPair(widget.term),
                            onClose: () {
                              setState(() {});
                            }
                          ),
                        );
                      }
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
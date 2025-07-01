import 'dart:math';

import 'package:flutter/material.dart';
import 'package:japanese_word_bank/classes/en_ja_pair.dart';

// Local
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class TranslateCard extends StatefulWidget {
  final String? title;
  final String en;
  final String? kanji;
  final String reading;
  final String romaji;
  final Color cardColor;

  TranslateCard({
    super.key,
    this.title,
    required this.en,
    this.kanji,
    required this.reading,
    required this.romaji,
    this.cardColor = JWBColors.translateResultBackground,
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
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  widget.title != null ? Center(
                    child: Text(widget.title!, style: JWBTextStyles.translateResultTitle),
                  ) : Container(),
                  */
                  widget.title != null ? Text(widget.title!, style: JWBTextStyles.translateResultTitle) : Container(),
                  Text(
                    widget.en.length > maxTextLen ? "${widget.en.substring(0, maxTextLen)}..." : widget.en,
                    style: JWBTextStyles.translateResultEn
                  ),
                  widget.kanji != null ?
                    Text(widget.kanji!, style: JWBTextStyles.translateResultMain) :
                    Text(widget.reading, style: JWBTextStyles.translateResultMain),
                  widget.kanji != null ? Text(widget.reading, style: JWBTextStyles.termReading) : Container(),
                  Text(widget.romaji, style: JWBTextStyles.termRomaji),
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
                            term: TermEntry(en_term: widget.en, k_term: widget.kanji, reading: widget.reading),
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
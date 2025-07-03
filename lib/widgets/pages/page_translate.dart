import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';
import 'package:japanese_word_bank/classes/jisho_pair.dart';
import 'package:japanese_word_bank/functions/translate.dart';
import 'package:japanese_word_bank/functions/parse_jisho_response.dart';
import 'package:japanese_word_bank/widgets/translate_card.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageTranslate extends StatefulWidget {
  TextEditingController controller;
  List<EnJaPair> translationResults;
  Function(List<EnJaPair>) setTranslationResults;
  bool enToJa;
  Function(bool) setEnToJa;
  JishoPair? jishoResults;
  Function(JishoPair?) setJishoPair;

  PageTranslate({
    super.key,
    required this.controller,
    required this.translationResults,
    required this.setTranslationResults,
    required this.enToJa,
    required this.setEnToJa,
    this.jishoResults,
    required this.setJishoPair
  });

  @override
  State<StatefulWidget> createState() => _PageTranslate();
}

class _PageTranslate extends State<PageTranslate> {
  FocusNode translateEntryFocus = FocusNode();
  DateTime _mostRecentCall = DateTime.now();

  Future<void> _jishoTranslate(String term, DateTime stamp) async {
    widget.setJishoPair(null);
    await Future.delayed(const Duration(milliseconds: 500));
    if (stamp == _mostRecentCall) {
      final url = Uri.parse('https://jisho.org/api/v1/search/words?keyword=$term');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        widget.setJishoPair(parse_jisho_response(response, term));
      }
    }
  }

  Future<void> _translateFromEn(String en, DateTime stamp) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (stamp == _mostRecentCall) {
      DictDatabaseHelper.instance.translateToJaN(en, 10).then((result) {
        widget.setTranslationResults(result);
      });
    }
  }
  
  Future<void> _translateFromJa(String ja, DateTime stamp) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (stamp == _mostRecentCall) {
      DictDatabaseHelper.instance.translateToEnN(ja, 10).then((result) {
        widget.setTranslationResults(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // Listener ensures if list is interacted with, it unfocuses the text field.
          child: Listener(
            onPointerDown: (_) {
              FocusScope.of(context).unfocus();
            },

            // Translation result cards.
            child: widget.translationResults.isEmpty ? Container() :
              ListView(
                children: <Widget>[
                  widget.jishoResults != null ? TranslateCard(
                    title: 'Jisho Results',
                    cardColor: JWBColors.translateResultBackgroundJisho,
                    en: widget.jishoResults!.en_term,
                    kanji: widget.jishoResults!.k_term,
                    reading: widget.jishoResults!.reading,
                    romaji: widget.jishoResults!.romaji,
                  ) : Container()
                ] + List.generate(widget.translationResults.length, (i) {
                  return TranslateCard(
                    en: widget.translationResults[i].en_term,
                    kanji: widget.translationResults[i].k_term,
                    reading: widget.translationResults[i].reading,
                    romaji: widget.translationResults[i].romaji,
                  );
                }),
              )
          )
        ),

        // Text entry and language switch option.
        Container(
          decoration: const BoxDecoration(
            color: JWBColors.txtEntryBG,
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Column(
            children: [
              TextField(
                focusNode: translateEntryFocus,
                controller: widget.controller,
                style: const TextStyle(
                  fontSize: 20,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: JWBColors.txtEntryUnfocused, width: 2),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                  ),
                  hintStyle: const TextStyle(
                    color: JWBColors.txtEntryUnfocused
                  ),
                  hintText: "Word/Term to Translate...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      widget.setTranslationResults([]);
                    },
                    icon: const Icon(Icons.clear, size: 20,)
                  )
                ),
                onChanged: (String val) {
                  _mostRecentCall = DateTime.now();
                  if (widget.enToJa) {
                    _translateFromEn(val, _mostRecentCall);
                    _jishoTranslate(val, _mostRecentCall);
                  } else {
                    _translateFromJa(val, _mostRecentCall);
                    _jishoTranslate(val, _mostRecentCall);
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.enToJa ? "English" : "Japanese",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.setEnToJa(!widget.enToJa);
                        widget.controller.value = const TextEditingValue(text: '');
                        _translateFromEn("", DateTime.now());
                      });
                    },
                    icon: const Icon(Icons.swap_horiz)
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.enToJa ? "Japanese" : "English",
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              )
            ],
          )
        ),
      ],
    );
  }
}
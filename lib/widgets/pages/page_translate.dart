import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';
import 'package:japanese_word_bank/functions/translate.dart';
import 'package:japanese_word_bank/widgets/translate_card.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageTranslate extends StatefulWidget {
  TextEditingController controller;
  List<EnJaPair> translationResults;
  Function(List<EnJaPair>) setTranslationResults;

  PageTranslate({
    super.key,
    required this.controller,
    required this.translationResults,
    required this.setTranslationResults,
  });

  @override
  State<StatefulWidget> createState() => _PageTranslate();
}

class _PageTranslate extends State<PageTranslate> {
  bool _enToJa = true;
  FocusNode translateEntryFocus = FocusNode();

  void _translateFromEn(String en) async {
    final translations = await DictDatabaseHelper.instance.translateToJaN(en, 10);
    widget.setTranslationResults(translations);
  }
  
  void _translateFromJa(String ja) async {
    final translations = await DictDatabaseHelper.instance.translateToEnN(ja, 10);
    widget.setTranslationResults(translations);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Listener(
            onPointerDown: (_) {
              FocusScope.of(context).unfocus();
            },

            child: widget.translationResults.isEmpty ? Container() :
              ListView(
                children: List.generate(widget.translationResults.length, (i) {
                  return TranslateCard(
                      term: widget.translationResults[i]
                  );
                }),
              )
          )
        ),

        Container(
          decoration: const BoxDecoration(
            color: JWBColors.txtEntryBG,
          ),
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Column(
            children: [
              TextField(
                focusNode: translateEntryFocus,
                controller: widget.controller,
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
                  hintText: "Translate...",
                  suffixIcon: IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        widget.setTranslationResults([]);
                      },
                      icon: Icon(Icons.clear, size: 20,)
                  )
                ),
                onChanged: (String val) {
                  if (_enToJa) {
                    _translateFromEn(val);
                  } else {
                    _translateFromJa(val);
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _enToJa ? "English" : "Japanese",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _enToJa = !_enToJa;
                        });
                      },
                      icon: Icon(Icons.swap_horiz)
                  ),

                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _enToJa ? "Japanese" : "English",
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
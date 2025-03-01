import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

import '../../classes/en_ja_pair.dart';
import '../../functions/translate.dart';
import '../translate_card.dart';

class PageTranslate extends StatefulWidget {
  TextEditingController controller;

  PageTranslate({
    super.key,
    required this.controller
  });

  @override
  State<StatefulWidget> createState() => _PageTranslate();
}

class _PageTranslate extends State<PageTranslate> {
  //final _translateController = TextEditingController();
  final _enToJa = true;

  List<EnJaPair> translations = [];

  void _translateFromEn(String en) async {
    translations = await DictDatabaseHelper.instance.translateNResults(en, 10);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _translateFromEn(widget.controller.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: TextField(
            controller: widget.controller,
            style: TextStyle(
              fontSize: 20,
            ),
            maxLines: 1,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryUnfocused, width: 2),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
                ),
                hintStyle: TextStyle(
                    color: JWBColors.txtEntryUnfocused
                ),
                hintText: "Translate..."
            ),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (String val) {
              if (val.length > 2) {
                if (_enToJa) {
                  _translateFromEn(val);
                }
              }
            },
          ),
        ),

        SizedBox(height: 5),

        // English to Japanese.
        _enToJa && translations.isNotEmpty? Expanded(
          child: ListView(
            children: List.generate(translations.length, (i) {
              return TranslateCard(
                  term: translations[i]
              );
            }),
          ),
        ) :
        // Japanese to English.
        !_enToJa && translations.isNotEmpty? Expanded(
          child: Container(),
        ) :
        // No translations to show.
        Container()
      ],
    );
  }
}
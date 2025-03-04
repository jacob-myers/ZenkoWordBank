import 'package:flutter/material.dart';
import 'package:async/async.dart';

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
  CancelableOperation? _editingOperation;

  Future<void> _translateFromEn(String en) async {
    _editingOperation?.cancel();
    _editingOperation = CancelableOperation.fromFuture(
        DictDatabaseHelper.instance.translateToJaN(en, 10),
    );
    _editingOperation!.value.then((result) {
      widget.setTranslationResults(result);
    });
  }
  
  Future<void> _translateFromJa(String ja) async {
    _editingOperation?.cancel();
    _editingOperation = CancelableOperation.fromFuture(
        DictDatabaseHelper.instance.translateToEnN(ja, 10),
    );
    _editingOperation!.value.then((result) {
      widget.setTranslationResults(result);
    });
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
                children: List.generate(widget.translationResults.length, (i) {
                  return TranslateCard(
                    term: widget.translationResults[i]
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
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _enToJa = !_enToJa;
                        widget.controller.value = const TextEditingValue(text: '');
                        _translateFromEn("");
                      });
                    },
                    icon: const Icon(Icons.swap_horiz)
                  ),

                  const SizedBox(width: 10),
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
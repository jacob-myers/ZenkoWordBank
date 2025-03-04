import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:kana_kit/kana_kit.dart';

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/functions/translate.dart';
import 'package:japanese_word_bank/persistence.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class TermEditor extends StatefulWidget {
  int dropdownCount = 10;
  Function onClose;
  TermEntry? term;
  bool isEdit;

  TermEditor({
    super.key,
    required this.onClose,
    this.term,
    this.isEdit = false,
  });

  @override
  State<StatefulWidget> createState() => _TermEditor();
}

class _TermEditor extends State<TermEditor> {
  final _kanaKit = const KanaKit();
  bool _autotranslate = true;

  List<EnJaPair> ja_translations = [];
  CancelableOperation? _editingOperation;

  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _dropdownController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();
  String _romaji = "";

  TermEntry? _newTerm() {
    // No english entry or reading and dropdown are blank
    if (_englishController.value.text == "" || (_dropdownController.value.text == "" && _readingController.value.text == "")) {
      return null;
    }
    if (_readingController.value.text != "") {
      return TermEntry(
          en_term: _englishController.value.text,
          k_term: _dropdownController.value.text,
          reading: _readingController.value.text
      );
    }
    return TermEntry(
        en_term: _englishController.value.text,
        reading: _dropdownController.value.text
    );
  }

  void updateReading(EnJaPair? pair) {
    if (pair == null) {
      _readingController.value =  TextEditingValue(text: "");
      _romaji = "";
      return;
    }
    _readingController.value = pair.k_term == null ? TextEditingValue(text: "") :
    TextEditingValue(
      text: pair.reading,
      selection: TextSelection.fromPosition(
        TextPosition(offset: pair.reading.length),
      ),
    );
    _romaji = _kanaKit.toRomaji(pair.reading);
  }

  void _translateFrom(String value) async {
    _editingOperation?.cancel();
    _editingOperation = CancelableOperation.fromFuture(
      DictDatabaseHelper.instance.translateToJaN(value, widget.dropdownCount)
    );
    _editingOperation!.value.then((result) {
      ja_translations = result;
      if (ja_translations.isNotEmpty) {
        updateReading(ja_translations.first);
      } else {
        _dropdownController.value = TextEditingValue(text: "");
        updateReading(null);
      }
      setState(() {});
    });


    //ja_translations = await DictDatabaseHelper.instance.translateToJaN(value, widget.dropdownCount);

  }

  @override
  void initState() {
    super.initState();
    if (widget.term != null) {
      _autotranslate = false;
      _englishController.value = TextEditingValue(text: widget.term!.en_term);
      if (widget.term!.k_term != null) {
        _dropdownController.value = TextEditingValue(text: widget.term!.k_term!);
        _readingController.value = TextEditingValue(text: widget.term!.reading);
      } else {
        _dropdownController.value = TextEditingValue(text: widget.term!.reading);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: JWBColors.txtEntryBG
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        children: [
          //SizedBox(height: 30),
          SizedBox(height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _englishController,
                    autofocus: true,
                    style: JWBTextStyles.newTermEnglish,
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
                        hintText: "English..."
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (String value) async {
                      _translateFrom(value);
                    },
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: _autotranslate ? JWBColors.autotranslateEnabled : JWBColors.autotranslateDisabled
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: _autotranslate ? JWBColors.autotranslateEnabledBG : JWBColors.autotranslateDisabledBG
                    ),
                    child: Icon(
                      Icons.translate,
                      size: 30,
                      color: _autotranslate ? JWBColors.autotranslateEnabled : JWBColors.autotranslateDisabled,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _autotranslate = !_autotranslate;
                      if (_autotranslate) {
                        _translateFrom(_englishController.value.text);
                      }
                    });
                  },
                )
              ],
            ),
          ),

          SizedBox(height: 10),

          DropdownMenu(
            controller: _dropdownController,
            initialSelection: ja_translations.firstOrNull,
            menuHeight: 220,
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: true,
            textStyle: JWBTextStyles.newTermJap,
            dropdownMenuEntries: ja_translations.map((EnJaPair pair) {
              return DropdownMenuEntry<EnJaPair>(
                value: pair,
                label: pair.ja_term,
                labelWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pair.ja_term,
                      style: JWBTextStyles.termJapMainDropdown,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: Text(
                        pair.en_term,
                        style: JWBTextStyles.termJapMainDropdownDefinition,
                      ),
                    )
                  ],
                )
              );
            }).toList(),
            onSelected: (EnJaPair? pair) {
              FocusScope.of(context).unfocus();
              if (pair != null) {
                updateReading(pair);
              }
            },
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(JWBColors.newTermDropdownBackground)
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: JWBColors.txtEntryUnfocused, width: 2),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: JWBColors.txtEntryUnfocused, width: 5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: JWBColors.txtEntryFocused, width: 2),
              ),
            ),
          ),

          SizedBox(height: 10),

          TextField(
            controller: _readingController,
            style: JWBTextStyles.newTermReading,
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
              hintText: "Reading..."
            ),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),

          SizedBox(height: 2),

          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              _romaji,
              style: JWBTextStyles.newTermRomaji,
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                    backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonCancel),
                    foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    TermEntry? newTerm = _newTerm();
                    if (newTerm != null) {
                      // if it is editing, update term.
                      if (widget.isEdit && widget.term != null) {
                        newTerm.id = widget.term!.id;
                        WordsDatabaseHelper.instance.update(newTerm);
                      }
                      // If it is adding a new term, add term.
                      else {
                        WordsDatabaseHelper.instance.addTerm(newTerm);
                      }
                      widget.onClose();
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                    backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonConfirm),
                    foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                  ),
                  child: Text( widget.isEdit ? "Confirm" : "Add"),
                ),
              )
            ],
          )
        ],
      ),

    );
  }
}
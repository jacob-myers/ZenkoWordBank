import 'package:flutter/material.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/functions/translate.dart';

import '../themes.dart';

class NewWordDialogue extends StatefulWidget {
  const NewWordDialogue({super.key});

  @override
  State<StatefulWidget> createState() => _NewWordDialogue();
}

class _NewWordDialogue extends State<NewWordDialogue> {
  List<TermEntry> ja_translations = [
    TermEntry(en_term: "Hello", reading: "こんにちは"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Mimela splendens (metallic-green scarabaeid beetle)", k_term: "金亀子", reading: "コガネムシ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
    TermEntry(en_term: "Rice", k_term: "米", reading: "こめ"),
  ];

  TermEntry newTerm = TermEntry(en_term: "", reading: "");

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
          TextField(
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
              setState(() {
                //ja_translations = await DictDatabaseHelper.instance.translate(value);
              });
            },
          ),

          SizedBox(height: 10),

          DropdownMenu(
            menuHeight: 220,
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: true,
            textStyle: JWBTextStyles.newTermJap,
            dropdownMenuEntries: ja_translations.map((TermEntry term) {
              return DropdownMenuEntry<TermEntry>(
                value: term,
                label: term.ja_term,
                labelWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.ja_term,
                      style: JWBTextStyles.termJapMainDropdown,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: Text(
                        term.en_term,
                        style: JWBTextStyles.termJapMainDropdownDefinition,
                      ),
                    )
                  ],
                )
                //label: "${term.ja_term}\n ${term.en_term}",
                //style: MenuItemButton.styleFrom(textStyle: JWBTextStyles.termJapMainDropdown)
              );
            }).toList(),
            onSelected: (TermEntry? term) {
              FocusScope.of(context).unfocus();
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

          SizedBox(height: 10),

          Container(
            child: Text(""),
          ),

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

                  },
                  child: Text("Add"),
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                    backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonConfirm),
                    foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                  ),
                ),
              )
            ],
          )
        ],
      ),

    );
  }
}
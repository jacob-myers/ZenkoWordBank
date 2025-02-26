import 'package:flutter/material.dart';
import 'package:japanese_word_bank/functions/translate.dart';

// Local
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<StatefulWidget> createState() => _PageHome();
}

class _PageHome extends State<PageHome> {
  //TermEntry? dailyTerm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(
              "Word of the day",
            style: JWBTextStyles.headerText,
          ),
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder(
              future: DictDatabaseHelper.instance.getRandomWord(4),
              builder: (BuildContext context, AsyncSnapshot<TermEntry> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Loading..."));
                }
                //dailyTerm = snapshot.data;
                return Column(
                  children: [
                    TermCard(term: snapshot.data!),
                    SizedBox(height: 3),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return  Dialog.fullscreen(
                              child: TermEditor(
                                term: snapshot.data,
                                onClose: () {
                                  setState(() {});
                                }
                              ),
                            );
                          }
                        );
                      },
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                        backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonConfirm),
                        foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                      ),
                      child: Text( "Add to bank" ),
                    ),
                    //Spacer()
                  ],
                );
              }
          ),
        ),
        //SizedBox(height: 100),
        Card(
          margin: EdgeInsets.fromLTRB(5, 5, 70, 2),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: JWBColors.entryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios_new),
                  SizedBox(width: 10),
                  Text(
                    "Word Bank",
                    style: JWBTextStyles.homeCardText,
                  ),
                ],
              ),
            )
          ),
        ),
        Card(
          margin: EdgeInsets.fromLTRB(70, 5, 5, 2),
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: JWBColors.entryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Translator",
                      style: JWBTextStyles.homeCardText,
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}
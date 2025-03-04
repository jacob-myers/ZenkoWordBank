import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/functions/translate.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageHome extends StatefulWidget {
  final Function(int)? navigateToPageN;

  const PageHome({
    super.key,
    this.navigateToPageN
  });

  @override
  State<StatefulWidget> createState() => _PageHome();
}

class _PageHome extends State<PageHome> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: const Text(
              "Word of the day",
            style: JWBTextStyles.headerText,
          ),
        ),
        SizedBox(
          height: 270,
          child: FutureBuilder(
            future: DictDatabaseHelper.instance.getRandomWord(DateTime.now().millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24)),
            builder: (BuildContext context, AsyncSnapshot<TermEntry> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Loading..."));
              }
              return Column(
                children: [
                  TermCard(term: snapshot.data!),
                  const SizedBox(height: 3),
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
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                      backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonConfirm),
                      foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                    ),
                    child: Text( "Add to bank" ),
                  ),
                ],
              );
            }
          ),
        ),

        Card(
          margin: const EdgeInsets.fromLTRB(5, 5, 70, 2),
          child: InkWell(
            onTap: () { widget.navigateToPageN != null ? widget.navigateToPageN!(0) : null; },
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: JWBColors.entryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(
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
        ),

        Card(
          margin: const EdgeInsets.fromLTRB(70, 5, 5, 2),
          child: InkWell(
            onTap: () { widget.navigateToPageN != null ? widget.navigateToPageN!(2) : null; },
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: JWBColors.entryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(
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
          ),
        ),
      ],
    );
  }
}
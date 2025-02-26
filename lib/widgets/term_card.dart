import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/persistence.dart';
import 'package:japanese_word_bank/themes.dart';
import 'package:japanese_word_bank/widgets/delete_confirmation.dart';
import 'package:japanese_word_bank/widgets/word_text_entry.dart';

class TermCard extends StatefulWidget {
  Function onDelete;
  Function onEdit;
  final TermEntry term;

  TermCard({
    required this.term,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<StatefulWidget> createState() => _TermCard();
}

class _TermCard extends State<TermCard> {

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 2),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: JWBColors.entryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.term.en_term, style: JWBTextStyles.termEnglish),
                  Text(widget.term.ja_term, style: JWBTextStyles.termJapMain),
                  widget.term.k_term != null ? Text(widget.term.reading, style: JWBTextStyles.termReading) : Container(),
                  Text(widget.term.romaji, style: JWBTextStyles.termRomaji),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  child: const Icon(
                    Icons.close,
                    size: 35,
                    color: JWBColors.entryButton,
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteConfirmation(
                          delete: () async {
                            await WordsDatabaseHelper.instance.deleteTerm(widget.term.id!);
                            widget.onDelete();
                          },
                        );
                      }
                    );
                  },
                ),
                InkWell(
                  child: const Icon(
                    Icons.edit,
                    size: 28,
                    color: JWBColors.entryButton,
                  ),
                  onTap: () {
                    // TODO open word text entry with term.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog.fullscreen(
                          child: NewWordDialogue(
                            onClose: widget.onEdit,
                            term: widget.term,
                            isEdit: true,
                          )
                        );
                      }
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
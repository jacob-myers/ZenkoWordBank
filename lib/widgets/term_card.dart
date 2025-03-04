import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/functions/persistence.dart';
import 'package:japanese_word_bank/widgets/delete_confirmation.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class TermCard extends StatefulWidget {
  Function? onDelete;
  Function? onEdit;
  final TermEntry term;
  bool showButtons;

  TermCard({
    super.key,
    required this.term,
    this.onDelete,
    this.onEdit,
    this.showButtons = false
  });

  @override
  State<StatefulWidget> createState() => _TermCard();
}

class _TermCard extends State<TermCard> {
  int maxTextLen = 60;

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
                  Text(
                    widget.term.en_term.length > maxTextLen ? "${widget.term.en_term.substring(0, maxTextLen)}..." : widget.term.en_term,
                    style: JWBTextStyles.termEnglish
                  ),
                  Text(widget.term.ja_term, style: JWBTextStyles.termJapMain),
                  widget.term.k_term != null ? Text(widget.term.reading, style: JWBTextStyles.termReading) : Container(),
                  Text(widget.term.romaji, style: JWBTextStyles.termRomaji),
                ],
              ),
            ),
            // If showButtons, place buttons.
            !widget.showButtons ? Container() :
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
                            if (widget.onDelete != null) {
                              widget.onDelete!();
                            }
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog.fullscreen(
                          child: TermEditor(
                            onClose: widget.onEdit != null ? widget.onEdit! : () {},
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
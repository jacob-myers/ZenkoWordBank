import 'package:flutter/material.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class DeleteConfirmation extends StatefulWidget {
  Function delete;

  DeleteConfirmation({
    super.key,
    required this.delete
  });

  @override
  State<StatefulWidget> createState() => _DeleteConfirmation();
}

class _DeleteConfirmation extends State<DeleteConfirmation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: JWBColors.txtEntryBG,
      content: Container(
        height: 110,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: [
            const Text(
              "Are you sure you want to delete this term?",
              textAlign: TextAlign.center,
              style: JWBTextStyles.bodyText,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                      backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonCancel),
                      foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                    ),
                    child: Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.delete();
                    },
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(JWBTextStyles.newTermButton),
                      backgroundColor: WidgetStatePropertyAll(JWBColors.newTermButtonConfirm),
                      foregroundColor: WidgetStatePropertyAll(JWBColors.entryTextMain),
                    ),
                    child: Text("Delete"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
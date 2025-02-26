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
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: [
            Text(
              "Are you sure you want to delete this term?",
              textAlign: TextAlign.center,
              style: JWBTextStyles.bodyText,
            ),
            Spacer(),
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
                      Navigator.pop(context);
                      widget.delete();
                    },
                    child: Text("Delete"),
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
      ),
    );
  }

}
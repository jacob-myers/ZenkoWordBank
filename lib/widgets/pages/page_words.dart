import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/persistence.dart';
import 'package:japanese_word_bank/functions/search.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageWords extends StatefulWidget {
  const PageWords({super.key});

  @override
  State<StatefulWidget> createState() => _PageWords();
}

class _PageWords extends State<PageWords> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<TermEntry>> _entries;

  void _refreshTerms() async {
    _entries = WordsDatabaseHelper.instance.getTerms();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: _entries,
              builder: (BuildContext context, AsyncSnapshot<List<TermEntry>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text("Loading..."));
                }

                final searchIndex = TermSearch(snapshot.data!);
                final terms = searchIndex.search(_searchController.value.text);
                return ListView(
                  children: List.generate(terms.length, (i) {
                    return TermCard(
                      term: terms[i],
                      onDelete: () {
                        _refreshTerms();
                      },
                      onEdit: () {
                        _refreshTerms();
                      },
                      showButtons: true,
                    );
                  })
                );
              }
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: JWBColors.txtEntryBG
          ),
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (String val) { setState(() {}); },
                  style: TextStyle(
                    fontSize: 20,
                  ),
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
                      hintText: "Search..."
                  ),
                ),
              ),

              IconButton(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                icon: Icon(Icons.add_box_rounded, size: 40,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                        child: TermEditor(
                          onClose: () {
                            _refreshTerms();
                          },
                        )
                      );
                    }
                  );
                },
              )
            ],
          )
        ),
      ],
    );
  }
}
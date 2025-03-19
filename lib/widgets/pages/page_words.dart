import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/functions/persistence.dart';
import 'package:japanese_word_bank/functions/search.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/widgets/term_card.dart';
import 'package:japanese_word_bank/widgets/term_editor.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class PageWords extends StatefulWidget {
  List<bool> selectedSort;
  Function(int) setSort;

  PageWords({
    super.key,
    required this.selectedSort,
    required this.setSort,
  });

  @override
  State<StatefulWidget> createState() => _PageWords();
}

class _PageWords extends State<PageWords> {
  final TextEditingController _searchController = TextEditingController();
  List<String> sortOptions = ['ABC...', 'ZXY...', 'Newest', 'Oldest'];
  final List<bool> _selectedSort = [true, false, false, false];
  //Icon i = Icon(Icons.sort_by_alpha);
  //Icon j = Icon(Icons.late)

  late Future<List<TermEntry>> _entries;

  FocusNode _focusNode = FocusNode();

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
        Container(
          decoration: const BoxDecoration(
            color: JWBColors.txtEntryBG
          ),
          constraints: BoxConstraints(
            maxHeight: 40
          ),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                isSelected: widget.selectedSort,
                borderRadius: BorderRadius.circular(10),
                borderColor: JWBColors.sortButtonsSelectedBG,
                selectedBorderColor: JWBColors.sortButtonsSelectedBorder,
                selectedColor: JWBColors.sortButtonsSelected,
                color: JWBColors.sortButtonsUnSelected,
                fillColor: JWBColors.sortButtonsSelectedBG,
                onPressed: (int index) {
                  widget.setSort(index);
                },
                constraints: BoxConstraints(
                  minHeight: 25,
                  maxHeight: 25,
                  minWidth: 75,
                  maxWidth: 75
                ),
                children: List.generate(sortOptions.length, (i) {
                  return Text(sortOptions[i], textAlign: TextAlign.center,);
                }),
              ),
            ],
          )
        ),
        Expanded(
          child: FutureBuilder(
            future: _entries,
            builder: (BuildContext context, AsyncSnapshot<List<TermEntry>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Loading..."));
              }

              final searchIndex = TermSearch(snapshot.data!);
              final terms = searchIndex.search(_searchController.value.text);

              // Sort results based on which sort option is selected.
              if (widget.selectedSort[0]) {
                terms.sort((a, b) => a.en_term.compareTo(b.en_term));
              } else if (widget.selectedSort[1]) {
                terms.sort((a, b) => b.en_term.compareTo(a.en_term));
              } else if (widget.selectedSort[2]) {
                terms.sort((a, b) => b.id!.compareTo(a.id!));
              } else if (widget.selectedSort[3]) {
                terms.sort((a, b) => a.id!.compareTo(b.id!));
              }

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
          decoration: const BoxDecoration(
              color: JWBColors.txtEntryBG
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  showCursor: _focusNode.hasFocus,
                  onChanged: (String val) { setState(() {}); },
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  decoration: const InputDecoration(
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
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                icon: const Icon(Icons.add_box_rounded, size: 40,),
                onPressed: () {
                  _focusNode.unfocus();
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
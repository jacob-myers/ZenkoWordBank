import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';

import 'package:japanese_word_bank/widgets/pages/page_home.dart';
import 'package:japanese_word_bank/widgets/pages/page_translate.dart';
import 'package:japanese_word_bank/widgets/pages/page_words.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pc = PageController(initialPage: 1);
  final _translateController = TextEditingController();
  List<EnJaPair> translationResults = [];

  int _selectedIndex = 1;
  void _onNavbarItemTapped (int index) {
    setState(() {
      pc.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void _onPageChange (int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: PageView(
            controller: pc,
            onPageChanged: _onPageChange,
            children: [
              PageWords(),
              PageHome(
                navigateToPageN: _onNavbarItemTapped,
              ),
              PageTranslate(
                controller: _translateController,
                translationResults: translationResults,
                setTranslationResults: (List<EnJaPair> res) {
                  setState(() {
                    translationResults = res;
                  });
                },
              )
            ],
          )
        )
      ),

      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
          decoration: const BoxDecoration(
              color: JWBColors.txtEntryBG
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: BottomNavigationBar(
                  elevation: 0,
                  currentIndex: _selectedIndex,
                  onTap: _onNavbarItemTapped,
                  items: const <BottomNavigationBarItem> [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.storage),
                        label: "Words"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.translate),
                        label: "Translate"
                    ),
                  ],
                  backgroundColor: JWBColors.txtEntryBG,
                  selectedItemColor: JWBColors.navbarItemSelected,
                  unselectedItemColor: JWBColors.navbarItemUnselected,
                  selectedFontSize: 15,
                ),
              ),
            ],
          )
        ),
      ),

      /*
      // Development translation tester.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String en = "teacher";
          List<EnJaPair> res = await DatabaseHelper.instance.translateToJaN(en, 10);
          print(en);
          res.forEach(print);
        }
      ),
      */
    );
  }
}
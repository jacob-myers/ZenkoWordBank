import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/widgets/pages/page_home.dart';
import 'package:japanese_word_bank/widgets/pages/page_translate.dart';
import 'package:japanese_word_bank/widgets/pages/page_words.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pc = PageController(initialPage: 1);

  int _selectedIndex = 1;
  void _onNavbarItemTapped (int index) {
    setState(() {
      pc.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void _onPageChange (int index) {
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
            children: [
              PageWords(),
              PageHome(),
              PageTranslate()
            ],
            onPageChanged: _onPageChange,
          )
        )
      ),

      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
          decoration: BoxDecoration(
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
      )

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () async {


          //await DatabaseHelper.instance.truncate();
          //await DatabaseHelper.instance.readAndConvertXML();
          //print(await DatabaseHelper.instance.find_from_ja_value("ハローワーク"));

          String en = "teacher";
          List<EnJaPair> res = await DatabaseHelper.instance.translate(en);
          res = res.sublist(0, 10);
          print(en);
          res.forEach(print);

          //print(res.length);
          //ja.forEach(print);

          //await DatabaseHelper.instance.truncate();

          //await DatabaseHelper.instance.getJAfromEN(1);

          //await DatabaseHelper.instance.getEntries();

        }
      ),
      */

    );
  }
}
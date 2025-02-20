import 'package:flutter/material.dart';

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';
import 'package:japanese_word_bank/functions/RomParser.dart';
import 'package:japanese_word_bank/functions/translate.dart';

// Styles
import 'package:japanese_word_bank/themes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String hiriText = "konnichiha";
  String hiriMeaning = "Hello";
  String kataText = "amerika";
  String kataMeaning = "America";

  @override
  Widget build(BuildContext context) {

    String hiri = RomParser.toHirigana(hiriText);
    String kata = RomParser.toKatakana(kataText);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Text("$hiriText -> Hirigana", style: TextStyle(fontSize: 25)),
                      Text("(Meaning - $hiriMeaning)", style: TextStyle(fontSize: 15)),
                      Text(hiri, style: TextStyle(fontSize: 30)),
                      SizedBox(height: 20,),
                      Text("$kataText -> Katakana", style: TextStyle(fontSize: 25)),
                      Text("(Meaning - $kataMeaning)", style: TextStyle(fontSize: 15)),
                      Text(kata, style: TextStyle(fontSize: 30)),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: JWBColors.txtEntryBG
                ),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                child: TextField(
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
                    hintText: "English or Romaji..."
                  ),
                ),
              ),
            ],
          )
      ),

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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:string_similarity/string_similarity.dart';

// Local
import 'package:japanese_word_bank/classes/jisho_pair.dart';

JishoPair parse_jisho_response(http.Response response, String en) {
  final data = json.decode(response.body);
  final List results = data['data'];

  final top = results[0];
  String? kanji = top['japanese'][0]['word'];
  String reading = top['japanese'][0]['reading'];

  final sense = (top['senses'] as List).reduce((a, b) =>
  a['english_definitions'].toString().similarityTo(en) > b['english_definitions'].toString().similarityTo(en) ?
  a : b);
  final english = sense['english_definitions'].join(' / ');
  final part = (sense['parts_of_speech'] as List).join(' / ');

  return JishoPair(k_term: kanji, reading: reading, en_term: english, part: part);
}
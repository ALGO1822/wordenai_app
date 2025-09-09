import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worden_app/model/word.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<List<Word>> getSavedWords() async {
    final savedWordsJson = _prefs.getStringList('saved_words') ?? [];
    return savedWordsJson.map((wordJson) {
      return Word.fromJson(jsonDecode(wordJson));
    }).toList();
  }

  Future<void> saveWord(Word word) async {
    final savedWords = _prefs.getStringList('saved_words') ?? [];
    final wordJson = jsonEncode(word.toJson());

    if (!savedWords.contains(wordJson)) {
      savedWords.add(wordJson);
      await _prefs.setStringList('saved_words', savedWords);
    }
  }

  Future<void> deleteWord(Word word) async {
    final wordJson = jsonEncode(word.toJson());
    final savedWordsJson = _prefs.getStringList('saved_words') ?? [];
    savedWordsJson.remove(wordJson);
    await _prefs.setStringList('saved_words', savedWordsJson);
  }
}
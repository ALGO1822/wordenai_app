import 'package:worden_app/model/word.dart';
import 'package:worden_app/services/gemini_service.dart';
import 'package:worden_app/services/shared_prefs.dart';

class WordRepository {
  final GeminiService geminiService;
  final LocalStorageService localStorageService;

  WordRepository({
    required this.geminiService,
    required this.localStorageService,
  });

  Future<Word> getWordData(String word) async {
    return geminiService.getWordData(word);
  }

  Future<String> generateChatSimulation(String word, String definition, String example) async {
    return geminiService.generateChatSimulation(word, definition, example);
  }

  Future<List<Word>> getSavedWords() async {
    return localStorageService.getSavedWords();
  }

  Future<void> saveWord(Word word) async {
    return localStorageService.saveWord(word);
  }

  Future<void> deleteWord(Word word) async {
    return localStorageService.deleteWord(word);
  }
}
import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:worden_app/model/word.dart';

class GeminiService {
  final Gemini _gemini;

  GeminiService(this._gemini);

  Future<Word> getWordData(String word) async {
    final prompt = '''
      For the word "$word", identify its language and provide its definition, an example sentence, and synonyms. Return a single JSON object with the following keys: "language_code", "word", "definition", "example", and "synonyms" (which should be a list).

      If the word does not exist or you cannot find a definition, return the following exact string: "WORD_NOT_FOUND".
    ''';

    final response = await _gemini.text(prompt);
    final responseOutput = response?.output;

    if (responseOutput == null || responseOutput.isEmpty) {
      throw Exception('No data found for this word.');
    } else if (responseOutput.contains('WORD_NOT_FOUND')) {
      throw Exception('This is not a real word. Please try a different one.');
    } else {
      final jsonResponse = responseOutput
          .replaceAll('```json\n', '')
          .replaceAll('```', '')
          .trim();
      
      final data = json.decode(jsonResponse);
      return Word.fromJson(data);
    }
  }

  Future<String> generateChatSimulation(String word, String definition, String example) async {
    final prompt = '''
      Create a realistic chat dialogue that demonstrates the word "$word" which means "$definition".

      Example usage: "$example"

      Generate a natural conversation between two people with random names where they use "$word" correctly in context. Format as: "RandomName1: text\nRandomName2: text"
      
      Keep the conversation brief (4-6 exchanges total) and ensure the word "$word" is used naturally in context.
    ''';

    final response = await _gemini.text(prompt);
    final responseOutput = response?.output;

    if (responseOutput == null || responseOutput.isEmpty) {
      throw Exception('Could not generate a chat simulation');
    }

    return responseOutput;
  }
}
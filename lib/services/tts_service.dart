import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  TtsService() {
    _setTtsListeners();
  }

  void _setTtsListeners() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
    });
  }

  Future<void> speak(String text, {String? languageCode, double rate = 0.4}) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    
    if (languageCode != null) {
      await _setLanguage(languageCode);
    }
    
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _isSpeaking = false;
  }

  Future<void> _setLanguage(String languageCode) async {
    try {
      String fullLocale = _getFullLocale(languageCode);
      List<dynamic> supportedLanguages = await _flutterTts.getLanguages;

      if (supportedLanguages.contains(fullLocale)) {
        await _flutterTts.setLanguage(fullLocale);
      } else {
        // Try the base language code if full locale isn't supported
        String baseLanguage = languageCode.split('-')[0];
        String baseLocale = _getFullLocale(baseLanguage);
        
        if (supportedLanguages.contains(baseLocale)) {
          await _flutterTts.setLanguage(baseLocale);
        } else {
          // Fallback to English
          await _flutterTts.setLanguage('en-US');
        }
      }
    } catch (e) {
      // Fallback to English if there's an error
      await _flutterTts.setLanguage('en-US');
    }
  }

  String _getFullLocale(String languageCode) {
    final Map<String, String> commonLocales = {
      'en': 'en-US',    // English
      'es': 'es-ES',    // Spanish
      'fr': 'fr-FR',    // French
      'de': 'de-DE',    // German
      'it': 'it-IT',    // Italian
      'pt': 'pt-BR',    // Portuguese
      'ru': 'ru-RU',    // Russian
      'ja': 'ja-JP',    // Japanese
      'ko': 'ko-KR',    // Korean
      'zh': 'zh-CN',    // Chinese
      'ar': 'ar',       // Arabic
      'hi': 'hi-IN',    // Hindi
      'tr': 'tr-TR',    // Turkish
      'nl': 'nl-NL',    // Dutch
      'sv': 'sv-SE',    // Swedish
      'fi': 'fi-FI',    // Finnish
    };
    
    return commonLocales[languageCode] ?? '$languageCode-${languageCode.toUpperCase()}';
  }

  // Optional: Method to get available languages
  Future<List<dynamic>> getAvailableLanguages() async {
    return await _flutterTts.getLanguages;
  }

  // Optional: Method to set custom speech rate
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  // Optional: Method to set custom pitch
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  // Optional: Method to set volume
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  // Clean up resources
  void dispose() {
    _flutterTts.stop();
  }
}
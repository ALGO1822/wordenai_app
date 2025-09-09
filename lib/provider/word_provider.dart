import 'package:flutter/material.dart';
import 'package:worden_app/model/word.dart';
import 'package:worden_app/repository/word_repository.dart';
import 'package:worden_app/services/tts_service.dart';

class WordProvider extends ChangeNotifier {
  final WordRepository _wordRepository;
  final TtsService _ttsService;

  // State
  bool _isLoading = false;
  bool _isSpeaking = false;
  String? _errorMessage;
  String? _chatSimulation;
  String? _noticeMessage;
  Word? _currentWord;
  List<Word> _savedWords = [];
  String? _lastDetectedLanguage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSpeaking => _isSpeaking;
  String? get errorMessage => _errorMessage;
  String? get chatSimulation => _chatSimulation;
  String? get noticeMessage => _noticeMessage;
  Word? get currentWord => _currentWord;
  List<Word> get savedWords => _savedWords;

  WordProvider({
    required WordRepository wordRepository,
    required TtsService ttsService,
  })  : _wordRepository = wordRepository,
        _ttsService = ttsService {
    loadSavedWords();
  }

  Future<void> fetchWordDetails(String word) async {
    _isLoading = true;
    _errorMessage = null;
    _currentWord = null;
    _chatSimulation = null;
    _noticeMessage = null;
    notifyListeners();

    try {
      final wordData = await _wordRepository.getWordData(word);
      _currentWord = wordData;
      _lastDetectedLanguage = wordData.languageCode;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _currentWord = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateChatSimulation() async {
    if (_currentWord == null) return;

    _errorMessage = null;
    _chatSimulation = null;
    notifyListeners();

    try {
      final chat = await _wordRepository.generateChatSimulation(
        _currentWord!.word,
        _currentWord!.definition,
        _currentWord!.example,
      );
      _chatSimulation = chat;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _chatSimulation = null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveCurrentWord() async {
    if (_currentWord == null) return;

    try {
      await _wordRepository.saveWord(_currentWord!);
      _noticeMessage = 'Word saved successfully!';
      _errorMessage = null;
      await loadSavedWords(); // Refresh the saved words list
    } catch (e) {
      _errorMessage = 'Failed to save word: ${e.toString()}';
      _noticeMessage = null;
    }
    notifyListeners();
  }

  Future<void> loadSavedWords() async {
    try {
      _savedWords = await _wordRepository.getSavedWords();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load saved words: ${e.toString()}';
      _savedWords = [];
    }
    notifyListeners();
  }

  Future<void> deleteWord(Word word) async {
    try {
      await _wordRepository.deleteWord(word);
      _savedWords.remove(word);
      _noticeMessage = 'Word deleted successfully!';
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete word: ${e.toString()}';
      _noticeMessage = null;
    }
    notifyListeners();
  }

  // TTS Methods
  Future<void> pauseSpeaking() async {
    await _ttsService.stop();
    _isSpeaking = _ttsService.isSpeaking;
    notifyListeners();
  }

  Future<void> playSpeaking(String text) async {
    await speakWord(text);
    _isSpeaking = _ttsService.isSpeaking;
    notifyListeners();
  }

  Future<void> speakWord(String word) async {
    try {
      await _ttsService.speak(
        word,
        languageCode: _lastDetectedLanguage,
        rate: 0.3,
      );
      _isSpeaking = _ttsService.isSpeaking;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to speak word: ${e.toString()}';
      _isSpeaking = false;
    }
    notifyListeners();
  }

  Future<void> chatUsecase(String word) async {
    if (_isSpeaking) {
      await _ttsService.stop();
      return;
    }
    
    try {
      await _ttsService.speak(
        word,
        languageCode: _lastDetectedLanguage,
        rate: 0.4,
      );
      _isSpeaking = _ttsService.isSpeaking;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to speak: ${e.toString()}';
      _isSpeaking = false;
    }
    notifyListeners();
  }

  // Utility methods
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearNotice() {
    _noticeMessage = null;
    notifyListeners();
  }

  void clearChatSimulation() {
    _chatSimulation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}
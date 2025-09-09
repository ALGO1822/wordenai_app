class Word {
  final String languageCode;
  final String word;
  final String definition;
  final String example;
  final List<String> synonyms;

  const Word({
    required this.languageCode,
    required this.word,
    required this.definition,
    required this.example,
    required this.synonyms,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      languageCode: json['language_code'] ?? 'en',
      word: json['word'] ?? '',
      definition: json['definition'] ?? 'No definition available',
      example: json['example'] ?? 'No example available',
      synonyms: List<String>.from(json['synonyms'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'word': word,
      'definition': definition,
      'example': example,
      'synonyms': synonyms,
    };
  }
}
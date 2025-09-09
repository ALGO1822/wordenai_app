import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worden_app/constants/app_color.dart';
import 'package:worden_app/constants/custom_container.dart';
import 'package:worden_app/provider/word_provider.dart';

class SavedWordView extends StatefulWidget {
  const SavedWordView({super.key});

  @override
  State<SavedWordView> createState() => _SavedWordViewState();
}

class _SavedWordViewState extends State<SavedWordView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WordProvider>(context, listen: false).loadSavedWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Saved Words',
          style: TextStyle(fontSize: 30, color: AppColors.backgroundColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: AppColors.backgroundColor),
        ),
      ),
      body: Consumer<WordProvider>(
        builder: (context, wordProvider, child) {
          if (wordProvider.savedWords.isEmpty) {
            return const Center(
              child: Text(
                'No saved words yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                ),
              ),
            );
          } else {
            final savedWords = wordProvider.savedWords;
            return ListView.builder(
              itemCount: savedWords.length,
              itemBuilder: (context, index) {
                final word = savedWords[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                word.word,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final provider = Provider.of<WordProvider>(
                                  context,
                                  listen: false,
                                );
                                if (word.word.isNotEmpty) {
                                  provider.speakWord(word.word);
                                }
                              },
                              child: const Icon(
                                Icons.volume_up,
                                color: AppColors.secondary,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                wordProvider.deleteWord(word);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: AppColors.secondary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          word.definition,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          word.example,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Synonyms',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          word.synonyms.join(', '),
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
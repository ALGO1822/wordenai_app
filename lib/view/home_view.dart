import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worden_app/constants/app_color.dart';
import 'package:worden_app/constants/custom_button.dart';
import 'package:worden_app/constants/custom_container.dart';
import 'package:worden_app/constants/custom_fab.dart';
import 'package:worden_app/constants/custom_textfield.dart';
import 'package:worden_app/provider/word_provider.dart';
import 'package:worden_app/view/saved_word_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController wordController;
  
  @override
  void initState() {
    super.initState();
    wordController = TextEditingController();
  }

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Worden',
          style: TextStyle(fontSize: 30, color: AppColors.backgroundColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextfield(
                hintText: 'Enter a word',
                color: const Color(0xFF7d7b7d),
                controller: wordController,
              ),
              const SizedBox(height: 15),
              Consumer<WordProvider>(
                builder: (context, wordProvider, child) {
                  return CustomButton(
                    onPressed: wordProvider.isLoading
                        ? null
                        : () {
                            if (wordController.text.isNotEmpty) {
                              wordProvider.fetchWordDetails(wordController.text);
                            }
                          },
                    child: wordProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.backgroundColor,
                            ),
                          )
                        : const Text(
                            'Search',
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<WordProvider>(
                builder: (context, wordProvider, child) {
                  if (wordProvider.errorMessage != null) {
                    return Text(
                      wordProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    );
                  }

                  if (wordProvider.currentWord != null) {
                    final currentWord = wordProvider.currentWord!;
                    return CustomContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  currentWord.word,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: AppColors.textColor,
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
                                  if (currentWord.word.isNotEmpty) {
                                    provider.speakWord(currentWord.word);
                                  }
                                },
                                child: Icon(
                                  Icons.volume_up,
                                  color: AppColors.secondary,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentWord.definition,
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentWord.example,
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
                            currentWord.synonyms.join(', '),
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: CustomButton(
                                  text: 'Save',
                                  textColor: AppColors.backgroundColor,
                                  backgroundColor: AppColors.secondary,
                                  onPressed: () {
                                    final provider = Provider.of<WordProvider>(
                                      context,
                                      listen: false,
                                    );
                                    provider.saveCurrentWord().then((_) {
                                      final message = wordProvider.noticeMessage;
                                      if (message != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(message),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: CustomButton(
                                  text: 'Usecase',
                                  textColor: AppColors.primary,
                                  backgroundColor: AppColors.backgroundColor,
                                  onPressed: () async {
                                    final provider = Provider.of<WordProvider>(
                                      context,
                                      listen: false,
                                    );
                                    await provider.generateChatSimulation();
                                    final chatToSpeak = wordProvider.chatSimulation ?? '';
                                    if (chatToSpeak.isNotEmpty) {
                                      provider.chatUsecase(chatToSpeak);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 10),
              Consumer<WordProvider>(
                builder: (context, wordProvider, child) {
                  if (wordProvider.chatSimulation != null) {
                    return CustomContainer(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Usecase',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (wordProvider.chatSimulation != null) {
                                    if (wordProvider.isSpeaking) {
                                      wordProvider.pauseSpeaking();
                                    } else {
                                      wordProvider.playSpeaking(wordProvider.chatSimulation!);
                                    }
                                  }
                                },
                                child: Icon(
                                  wordProvider.isSpeaking ? Icons.pause : Icons.play_arrow,
                                  color: AppColors.secondary,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: double.infinity, child: Divider()),
                          const SizedBox(height: 10),
                          Text(
                            wordProvider.chatSimulation!,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFab(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SavedWordView()),
          );
        },
      ),
    );
  }
}
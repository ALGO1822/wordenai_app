import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worden_app/provider/word_provider.dart';
import 'package:worden_app/services/gemini_service.dart';
import 'package:worden_app/services/shared_prefs.dart';
import 'package:worden_app/services/tts_service.dart';
import 'package:worden_app/repository/word_repository.dart';
import 'package:worden_app/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  final String? apiKey = dotenv.env['GEMINI_API_KEY'];
  
  // Initialize shared preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Initialize Gemini
  Gemini.init(apiKey: apiKey!); 
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Create services
    final geminiService = GeminiService(Gemini.instance);
    final localStorageService = LocalStorageService(prefs);
    final ttsService = TtsService();
    
    // Create repository
    final wordRepository = WordRepository(
      geminiService: geminiService,
      localStorageService: localStorageService,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WordProvider(
            wordRepository: wordRepository, // Corrected line
            ttsService: ttsService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Worden App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
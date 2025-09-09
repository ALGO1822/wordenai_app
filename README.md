# Worden - The AI Vocabulary Builder

## Description

Worden is an intelligent mobile app designed to help you expand your vocabulary. Powered by the Gemini API, it provides instant definitions, example sentences, and synonyms for any word you search. The app also features a unique chat simulation to show how a word is used in a real conversation. With its built-in text-to-speech feature, you can listen to the correct pronunciation of words in multiple languages. You can also save words to a personal list for future review.

## Key Features

* **AI-Powered Definitions**: Get comprehensive word data (definition, examples, synonyms) from the Gemini API.
* **Chat Simulation**: See words used in a dynamic, AI-generated conversation to better understand their context.
* **Intelligent Pronunciation**: Listen to words with the correct accent and language, thanks to the integrated `flutter_tts` library.
* **Personalized Word List**: Save words to a local database using `shared_preferences` for easy offline access and a personalized learning experience.
* **Clean and Intuitive UI**: The app is built with a modern, user-friendly interface using Flutter.

## Technologies Used

* **Flutter**: The UI framework for building the cross-platform app.
* **Provider**: For state management following the MVVM pattern.
* **Gemini API**: To fetch word definitions, synonyms, and chat simulations.
* **flutter\_tts**: To provide text-to-speech functionality.
* **shared\_preferences**: For local data storage of saved words.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/worden.git
   ```

2. Navigate to the project directory:

   ```bash
   cd worden
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Generate your own free Gemini API key from [Google AI Studio](https://aistudio.google.com/).

   * Inside the root of the project, create a new folder named `assets`.
   * Inside the `assets` folder, create a file called `.env` and add your API key:

     ```env
     GEMINI_API_KEY=your_api_key_here
     ```

   > Note: The API key is **not included** in this repository. You must generate your own.

5. Run the app:

   ```bash
   flutter run
   ```

## Usage

* Search for any word to get instant definitions, examples, and synonyms.
* Explore AI-generated conversations to understand real-world usage.
* Save words to your personal list for future review.
* Use the text-to-speech feature to hear correct pronunciation.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or new features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Developed by **\[Favour]**

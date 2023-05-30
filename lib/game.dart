import 'dart:math';

class Hangman {
  late String word;
  late String hint;
  List<String> guessedLetters = [];
  int maxWrongGuesses = 6;
  int wrongGuesses = 0;

  Hangman() {
    var randomWordIndex = Random().nextInt(words.length);
    word = words[randomWordIndex];
    hint = hints[randomWordIndex];
  }

  String getCurrentState() {
    String currentState = '';
    for (int i = 0; i < word.length; i++) {
      String letter = word[i];
      if (guessedLetters.contains(letter)) {
        currentState += letter;
      } else {
        currentState += '_';
      }
      currentState += ' ';
    }
    return currentState.trim();
  }

  bool isGameOver() {
    return isWordGuessed() || wrongGuesses >= maxWrongGuesses;
  }

  bool isWordGuessed() {
    for (int i = 0; i < word.length; i++) {
      if (!guessedLetters.contains(word[i])) {
        return false;
      }
    }
    return true;
  }

  bool makeGuess(String letter) {
    letter = letter.toLowerCase();
    if (guessedLetters.contains(letter)) {
      return false;
    }
    guessedLetters.add(letter);
    if (!word.contains(letter)) {
      wrongGuesses++;
      return false;
    }
    return true;
  }
}

List<String> words = [
  'cheddar',
  'mozzarella',
  'swiss',
  'gouda',
  'parmesan',
  'brie',
  'feta',
  'camambert',
  'provolone',
];

List<String> hints = [
  'Yellowish cheese',
  'Italian cheese, often used on pizza',
  'Holey cheese',
  'Dutch cheese',
  'Hard, granular cheese',
  'Soft French cheese',
  'Greek cheese',
  'French cheese',
  'Italian cheese, often used in sandwiches',
];

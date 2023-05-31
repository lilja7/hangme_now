import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangme_now/hangman_man.dart';
import 'package:hangme_now/game.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman',
      theme: _buildTheme(Brightness.dark),
      home: const HangmanScreen(),
    );
  }
}

//Fontur fyrir allt - dökkt þema.
ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.pangolinTextTheme(baseTheme.textTheme),
  );
}

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  Hangman hangman = Hangman();
  int hangmanGraphicIndex = 0;
  bool showHint = false;
  bool wrongGuessIncrement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'H_NGM_N',
          style: TextStyle(fontSize: 27),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              //Svo hægt sé að skrolla.
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, //Höfum þetta allt í miðjunni
                  children: [
                    HangmanGraphic(
                        hangmanGraphicIndex: hangmanGraphicIndex), //mynd 0.
                    const SizedBox(height: 16),
                    Text(
                      'Word: ${hangman.getCurrentState()}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'the category is CHEESE!',
                      style: TextStyle(fontSize: 12),
                    ),
                    if (showHint) //Textinn sem byrtist þegar ýtt er á HINT takkann
                      Text(
                        'Hint: ${hangman.hint}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: GridView.count(
                        //'Lyklaborðið'
                        shrinkWrap: true,
                        crossAxisCount: 7,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        children: List.generate(26, (index) {
                          var letter = String.fromCharCode(index + 65);
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    makeGuess(letter);
                                  },
                                );
                              },
                              child: Text(
                                letter,
                                style: const TextStyle(fontSize: 16),
                              ));
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Wrong Guesses: ${hangman.wrongGuesses}/${hangman.maxWrongGuesses}', //Telur hversu margar villur
                      style: const TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      //GISK takki!
                      onPressed: () {
                        setState(
                          () {
                            showHint = true;
                            if (!wrongGuessIncrement) {
                              hangman.wrongGuesses += 1;
                              wrongGuessIncrement = true;
                            } //bæta við vitlaus gisk ++
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: const Text('Show Hint'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void makeGuess(String letter) {
    bool isWrongGuess = !hangman.makeGuess(letter);
    setState(() {
      if (isWrongGuess) {
        //Ef valið vitlaust þá bætist við 'hangmanninn' myndNr.0 , 1 , 2...
        hangmanGraphicIndex++;
      }
    });
    if (hangman.isGameOver()) {
      //Þegar leikurinn er búinn kemur popup
      hangmanGraphicIndex = 0;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Game Over!',
              style: TextStyle(fontSize: 30, color: Colors.pinkAccent),
            ),
            content: Text(
              hangman.isWordGuessed()
                  ? 'YAY, You did it! The word was: ${hangman.word}'
                      .toUpperCase()
                  : 'Game over loser! The word was: ${hangman.word}.'
                      .toUpperCase(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //Núllstilla allt fyrir nýjan leik
                  setState(
                    () {
                      hangman = Hangman();
                      hangmanGraphicIndex = 0;
                      showHint = false;
                      wrongGuessIncrement = false;
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Go Again'),
              ),
            ],
          );
        },
      );
    }
  }
}

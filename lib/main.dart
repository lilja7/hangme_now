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
    textTheme: GoogleFonts.cinzelTextTheme(
        baseTheme.textTheme), //cinzel eða pangolin??
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
  List<String> incorrectLetters = [];

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
                    const SizedBox(height: 12),
                    const Text(
                      'the category is CHEESE!',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    HangmanGraphic(
                        hangmanGraphicIndex: hangmanGraphicIndex), //mynd 0.png
                    const SizedBox(height: 12),
                    Text(
                      'Word: ${hangman.getCurrentState()}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Incorrect Letters: ${incorrectLetters.join(', ')}', //vitlausir stafir
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    if (showHint) //Textinn sem byrtist þegar ýtt er á HINT takkann
                      Text(
                        'Hint: ${hangman.hint}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 12),
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
                                backgroundColor:
                                    incorrectLetters.contains(letter)
                                        ? Colors.grey
                                        : Colors.black,
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              onPressed: incorrectLetters.contains(letter)
                                  ? null
                                  : () {
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
                    const SizedBox(height: 12),
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
        incorrectLetters.add(letter);
      }
    });
    if (hangman.isGameOver()) {
      //Þegar leikurinn er búinn kemur popup
      hangmanGraphicIndex = 0;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Game Over!',
                style: TextStyle(fontSize: 30, color: Colors.pinkAccent),
              ),
            ),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: hangman.isWordGuessed()
                        ? 'YAY, you did it! The word was: '
                        : 'Game over loser! The word was: ',
                  ),
                  TextSpan(
                    text: hangman.word.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
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
                      incorrectLetters.clear();
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Play Again'),
              ),
            ],
          );
        },
      );
    }
  }
}

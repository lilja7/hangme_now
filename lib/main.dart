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
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const HangmanScreen(),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'H_NGM_N',
          style: GoogleFonts.pangolin(textStyle: const TextStyle(fontSize: 27)),
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
                      style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'the category is CHEESE!',
                      style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(fontSize: 12)),
                    ),
                    if (showHint) //Takki með hint. ON eða OFF
                      Text(
                        'Hint: ${hangman.hint}',
                        style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(fontSize: 12),
                        ),
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
                            child: Text(letter),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Wrong Guesses: ${hangman.wrongGuesses}/${hangman.maxWrongGuesses}', //Telur hversu margar villur
                      style: GoogleFonts.pangolin(
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showHint;
                          hangman.wrongGuesses += 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          //Hint takkinn
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(showHint ? 'Hide Hint' : 'Show Hint',
                          style: GoogleFonts.pangolin()),
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
        //Ef valið vitlaust þá bætist við 'kallinn' myndNr.0 , 1 , 2...
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
            title: Text(
              'Game Over!',
              style: GoogleFonts.pangolin(
                textStyle:
                    const TextStyle(fontSize: 30, color: Colors.redAccent),
              ),
            ),
            content: Text(
              hangman.isWordGuessed()
                  ? 'YAY, You did it! The word was: ${hangman.word}'
                      .toUpperCase()
                  : 'Game over loser! The word was: ${hangman.word}.'
                      .toUpperCase(),
              style: GoogleFonts.pangolin(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hangman = Hangman();
                    hangmanGraphicIndex = 0;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Go Again', style: GoogleFonts.pangolin()),
              ),
            ],
          );
        },
      );
    }
  }
}

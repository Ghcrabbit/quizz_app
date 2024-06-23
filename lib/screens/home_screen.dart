import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../models/db_connect.dart';

class HomeScreen extends StatefulWidget {
  final String jsonPath;

  const HomeScreen({Key? key, required this.jsonPath}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions = [];
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    setState(() {
      loading = true;
    });
    var db = DbConnect();
    try {
      List<Question> questions = await db.fetchNewQuestions(widget.jsonPath);
      setState(() {
        _questions = questions;
        index = 0;
        score = 0;
        isPressed = false;
        isAlreadySelected = false;
        loading = false;
      });
    } catch (error) {
      print('Erro ao carregar perguntas: $error');
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Não foi possível carregar as perguntas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void nextQuestion() {
    if (index == _questions.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: _questions.length,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Selecione uma resposta'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool isCorrect) {
    if (isAlreadySelected) {
      return;
    }
    if (isCorrect) {
      score++;
    }
    setState(() {
      isPressed = true;
      isAlreadySelected = true;
    });
  }

  void startOver() {
    loadQuestions();
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _questions.isEmpty
              ? const Center(
                  child: Text('Nenhuma pergunta disponível.'),
                )
              : Column(
                  children: [
                    QuestionWidget(
                      indexAction: index,
                      questions: _questions[index].question,
                      totalQuestions: _questions.length,
                    ),
                    const Divider(color: neutral),
                    const SizedBox(height: 25.0),
                    for (int i = 0; i < _questions[index].options.length; i++)
                      GestureDetector(
                        onTap: () {
                          bool isCorrect = _questions[index].correctOption ==
                              _questions[index].options.values.toList()[i];
                          checkAnswerAndUpdate(isCorrect);
                        },
                        child: OptionCard(
                          option:
                              '${_questions[index].options.keys.toList()[i]}: ${_questions[index].options.values.toList()[i]}',
                          color: isPressed
                              ? _questions[index].correctOption ==
                                      _questions[index]
                                          .options
                                          .values
                                          .toList()[i]
                                  ? correct
                                  : incorrect
                              : neutral,
                        ),
                      ),
                  ],
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

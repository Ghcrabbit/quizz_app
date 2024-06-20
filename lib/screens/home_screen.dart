import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../models/db_connect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions = [];
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    var db = DbConnect();
    try {
      List<Question> questions =
          await db.fetchNewQuestions(); // Método para obter novas perguntas
      setState(() {
        _questions = questions;
        index = 0; // Reinicia o índice para a primeira pergunta
        score = 0; // Reinicia a pontuação
        isPressed = false; // Reinicia os estados de botão pressionado
        isAlreadySelected = false; // Reinicia o estado de seleção
      });
    } catch (error) {
      print('Erro ao carregar perguntas: $error');
      // Mostrar um feedback visual ao usuário em caso de erro
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
      // Mostra a caixa de resultados quando todas as perguntas são respondidas
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
    loadQuestions(); // Carrega novas perguntas
    setState(() {
      index = 0; // Reinicia o índice para a primeira pergunta
      score = 0; // Reinicia a pontuação
      isPressed = false; // Reinicia os estados de botão pressionado
      isAlreadySelected = false; // Reinicia o estado de seleção
    });
    Navigator.pop(
        context); // Fecha a caixa de diálogo de resultados, se estiver aberta
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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: _questions.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
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
                  // Display options A, B, C, D
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
                                    _questions[index].options.values.toList()[i]
                                ? correct
                                : incorrect // Ajusta a cor para respostas incorretas
                            : neutral, // Cor padrão para opções
                      ),
                    ),
                ],
              ),
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

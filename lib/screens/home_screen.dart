import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../helpers/shared_preferences_helper.dart'; // Importa o helper para salvar os resultados
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

  // Carregar perguntas do JSON
  void loadQuestions() async {
    setState(() {
      loading = true;
    });
    var db = DbConnect();
    try {
      List<Question> questions = await db.fetchNewQuestions(widget.jsonPath);
      if (questions.isEmpty) {
        throw 'Nenhuma pergunta disponível';
      }
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
      _showErrorDialog();
    }
  }

  // Mostrar diálogo de erro
  void _showErrorDialog() {
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

  // Navegar para a próxima pergunta ou mostrar os resultados
  void nextQuestion() {
    if (index == _questions.length - 1) {
      _saveResult(); // Salva o resultado ao final do quiz
      _showResultBox();
    } else {
      if (!isPressed) {
        // Verifica se uma resposta foi pressionada
        _showSelectAnswerMessage();
        return; // Evita a atualização do índice sem resposta
      }
      setState(() {
        index++;
        isPressed = false;
        isAlreadySelected = false;
      });
    }
  }

  // Mostrar mensagem para selecionar uma resposta
  void _showSelectAnswerMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Selecione uma resposta'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 20.0),
    ));
  }

  // Verificar e atualizar a resposta
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

  // Reiniciar o quiz
  void startOver() {
    loadQuestions(); // Já reinicializa o estado
    Navigator.pop(context); // Fecha a caixa de diálogo de resultados
  }

  // Salvar o resultado do quiz
  Future<void> _saveResult() async {
    try {
      await SharedPreferencesHelper.saveResult(widget.jsonPath, score);
    } catch (e) {
      print('Failed to save result: $e');
      _showSaveErrorDialog();
    }
  }

  // Mostrar caixa de diálogo de resultados
  void _showResultBox() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ResultBox(
        result: score,
        questionLength: _questions.length,
        onPressed: startOver,
      ),
    );
  }

  // Mostrar diálogo de erro ao salvar resultado
  void _showSaveErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: const Text('Não foi possível salvar o resultado.'),
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
          nextQuestion: isPressed
              ? nextQuestion
              : () {}, // Função vazia se não pressionado
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

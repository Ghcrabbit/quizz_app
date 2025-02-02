import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/db_connect.dart';

class QuestionScreen extends StatefulWidget {
  final String jsonPath;

  const QuestionScreen({Key? key, required this.jsonPath}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> _questions = [];
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  bool loading = true;
  int selectedOptionIndex = -1;
  List<String> _selectedAnswers =
      [];

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
        selectedOptionIndex = -1;
        _selectedAnswers =
            List.filled(questions.length, '');
      });
    } catch (error) {
      ('Erro ao carregar perguntas: $error');
      setState(() {
        loading = false;
      });
      _showErrorDialog('Erro ao carregar perguntas',
          'Por favor, verifique sua conexão e tente novamente.');
    }
  }


  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
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


  void nextQuestion() {
    if (index == _questions.length - 1) {
      _saveResultAndNavigate();
    } else {
      if (!isPressed) {
        _showSelectAnswerMessage();
        return;
      }

      setState(() {
        index++;
        isPressed = false;
        isAlreadySelected = false;
        selectedOptionIndex = -1;
      });
    }
  }


  void _showSelectAnswerMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selecione uma resposta'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20.0),
      ),
    );
  }


  void checkAnswerAndUpdate(bool isCorrect, int optionIndex) {
    if (isAlreadySelected) {
      return;
    }

    if (isCorrect) {
      score++;
    }


    _selectedAnswers[index] =
        _questions[index].options.keys.toList()[optionIndex];

    setState(() {
      isPressed = true;
      isAlreadySelected = true;
      selectedOptionIndex = optionIndex;
    });
  }


  void _saveResultAndNavigate() async {
    try {
      String filtered = resultScreenName(widget.jsonPath);

      await SharedPreferencesHelper.saveResult(
          filtered, score, _questions, _selectedAnswers,  );

      // Mostrar popup de aprovação/reprovação
      _showResultPopup();
    } catch (e) {
      ('Failed to save result: $e');
      _showErrorDialog('Erro', 'Não foi possível salvar o resultado.');
    }
  }

  void _showResultPopup() {
    bool isApproved = score >= 14; // Aprovado se acertou 14 ou mais
    String message = isApproved
        ? 'Parabéns! Você foi APROVADO no teste com $score pontos.'
        : 'Você foi REPROVADO no teste com $score pontos.';

    // Escolha da cor com base no resultado
    Color backgroundColor = isApproved ? Colors.green : Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: backgroundColor, // Define a cor de fundo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Bordas arredondadas
        ),
        title: Center( // Alinha o título ao centro
          child: Text(
            isApproved ? 'Aprovado!' : 'Reprovado!',
            style: const TextStyle(
              color: Colors.white, // Texto branco para contraste
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.white, // Texto branco para contraste
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center, // Alinha o texto ao centro
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                // Fechar o popup e voltar para a tela anterior
                Navigator.of(ctx).pop(); // Fecha o popup
                Navigator.of(context).pop(); // Retorna para a tela anterior (InitialScreen)
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Texto branco para contraste
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  String resultScreenName(String jsonPath) {
    String filtered = jsonPath.split('/').last;
    filtered = filtered.split('.').first;
    filtered = filtered.replaceAll('_', ' ');
    filtered = filtered.replaceRange(0, 1, filtered[0].toUpperCase());
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('ANAC FÁCIL'),
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      QuestionWidget(
                        indexAction: index,
                        questions: _questions[index].question,
                        totalQuestions: _questions.length,
                      ),
                      const Divider(color: neutral),
                      const SizedBox(height: 25.0),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double maxWidth = constraints.maxWidth;
                          return Column(
                            children: [
                              for (int i = 0;
                                  i < _questions[index].options.length;
                                  i++)
                                GestureDetector(
                                  onTap: () {
                                    bool isCorrect =
                                        _questions[index].correctOption ==
                                            _questions[index]
                                                .options
                                                .values
                                                .toList()[i];
                                    checkAnswerAndUpdate(isCorrect, i);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: isPressed
                                          ? (i == selectedOptionIndex ||
                                                  _questions[index]
                                                          .correctOption ==
                                                      _questions[index]
                                                          .options
                                                          .values
                                                          .toList()[i])
                                              ? (_questions[index]
                                                          .correctOption ==
                                                      _questions[index]
                                                          .options
                                                          .values
                                                          .toList()[i]
                                                  ? correct
                                                  : incorrect)
                                              : neutral
                                          : neutral,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width:
                                        maxWidth,
                                    padding: const EdgeInsets.all(16),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      '${_questions[index].options.keys.toList()[i]}: ${_questions[index].options.values.toList()[i]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: isPressed
              ? nextQuestion
              : () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

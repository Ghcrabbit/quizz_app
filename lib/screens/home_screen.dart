import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/db_connect.dart';
import './initial_screen.dart'; // Importe a tela inicial
import './results_screen.dart'; // Importe a tela de resultados

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
  int selectedOptionIndex = -1; // Para rastrear a opção selecionada
  List<String> _selectedAnswers =
      []; // Lista para salvar as respostas selecionadas

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
        selectedOptionIndex = -1;
        _selectedAnswers =
            List.filled(questions.length, ''); // Inicializa com strings vazias
      });
    } catch (error) {
      print('Erro ao carregar perguntas: $error');
      setState(() {
        loading = false;
      });
      _showErrorDialog('Erro ao carregar perguntas',
          'Por favor, verifique sua conexão e tente novamente.');
    }
  }

  // Mostrar diálogo de erro
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

  // Navegar para a próxima pergunta ou mostrar os resultados
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

  // Mostrar mensagem para selecionar uma resposta
  void _showSelectAnswerMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selecione uma resposta'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20.0),
      ),
    );
  }

  // Verificar e atualizar a resposta
  void checkAnswerAndUpdate(bool isCorrect, int optionIndex) {
    if (isAlreadySelected) {
      return;
    }

    if (isCorrect) {
      score++;
    }

    // Salvar a resposta selecionada
    _selectedAnswers[index] =
        _questions[index].options.keys.toList()[optionIndex];

    setState(() {
      isPressed = true;
      isAlreadySelected = true;
      selectedOptionIndex = optionIndex;
    });
  }

  // Salvar o resultado do quiz e navegar para InitialScreen
  void _saveResultAndNavigate() async {
    try {
      // Salvar o resultado do quiz
      await SharedPreferencesHelper.saveResult(widget.jsonPath, score);

      // Salvar as respostas selecionadas
      await SharedPreferencesHelper.saveSelectedAnswers(
          widget.jsonPath, _selectedAnswers);

      // Navegar para a tela inicial ou outra ação após salvar os resultados
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InitialScreen(),
        ),
      );
    } catch (e) {
      print('Failed to save result: $e');
      _showErrorDialog('Erro', 'Não foi possível salvar o resultado.');
    }
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
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navegar para a ResultsScreen ao clicar no ícone de histórico
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(),
                ),
              );
            },
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
                                        maxWidth, // Define a largura máxima disponível
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
              : () {}, // Função vazia se não pressionado
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

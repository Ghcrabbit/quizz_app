import 'package:flutter/material.dart';
import '../models/db_connect.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../constants.dart';

class ResultDetailScreen extends StatefulWidget {
  final String quizName;
  final int score;
  final String date;
  final List<String> selectedAnswers;

  const ResultDetailScreen({
    Key? key,
    required this.quizName,
    required this.score,
    required this.date,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  List<Question> _questions = [];
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
      List<Question> questions = await db.fetchNewQuestions(widget.quizName);
      setState(() {
        _questions = questions;
        loading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Resultado'),
      ),
      backgroundColor:
          Color.fromARGB(255, 0, 62, 119), // Altere para a cor desejada aqui
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quiz: ${widget.quizName}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Score: ${widget.score}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Data: ${widget.date}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: neutral),
                      const SizedBox(height: 25.0),
                      ...List.generate(_questions.length, (index) {
                        return Column(
                          children: [
                            QuestionWidget(
                              indexAction: index,
                              questions: _questions[index].question,
                              totalQuestions: _questions.length,
                            ),
                            const Divider(color: neutral),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double maxWidth = constraints.maxWidth;
                                return Column(
                                  children: [
                                    for (int i = 0;
                                        i < _questions[index].options.length;
                                        i++)
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              (widget.selectedAnswers[index] ==
                                                      _questions[index]
                                                          .options
                                                          .keys
                                                          .toList()[i])
                                                  ? (_questions[index]
                                                              .correctOption ==
                                                          _questions[index]
                                                              .options
                                                              .values
                                                              .toList()[i]
                                                      ? correct
                                                      : incorrect)
                                                  : neutral,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: maxWidth,
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          '${_questions[index].options.keys.toList()[i]}: ${_questions[index].options.values.toList()[i]}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
    );
  }
}

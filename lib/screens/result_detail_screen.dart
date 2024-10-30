  import 'package:flutter/material.dart';
  import '../models/db_connect.dart';
  import '../models/question_model.dart';
  import '../widgets/question_widget.dart';
  import '../constants.dart';

  class ResultDetailScreen extends StatefulWidget {
    final String quizName;
    final int score;
    final String date;
    final List<Question> questions;
    final List<String> selectedAnswers;

    const ResultDetailScreen({
      Key? key,
      required this.quizName,
      required this.score,
      required this.date,
      required this.questions,
      required this.selectedAnswers,
    }) : super(key: key);

    @override
    State<ResultDetailScreen> createState() => _ResultDetailScreenState();
  }

  class _ResultDetailScreenState extends State<ResultDetailScreen> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do Resultado'),
        ),
        backgroundColor: const Color.fromARGB(186, 66, 160, 202),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bloco: ${widget.quizName}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Resultado: ${widget.score}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Data: ${widget.date}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const Divider(color: neutral),
              const SizedBox(height: 25.0),
              ...List.generate(widget.questions.length, (index) {
                return Column(
                  children: [
                    QuestionWidget(
                      indexAction: index,
                      questions: widget.questions[index].question,
                      totalQuestions: widget.questions.length,
                    ),
                    const Divider(color: neutral),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth;
                        return Column(
                          children: List.generate(
                              widget.questions[index].options.length, (i) {
                            String optionKey =
                                widget.questions[index].options.keys.toList()[i];
                            String optionValue = widget
                                .questions[index].options.values
                                .toList()[i];

                            Color backgroundColor;
                            if (widget.selectedAnswers[index] == optionKey) {

                              if (optionValue ==
                                  widget.questions[index].correctOption) {
                                backgroundColor =
                                    correct;
                              } else {
                                backgroundColor =
                                    incorrect;
                              }
                            } else if (optionValue ==
                                widget.questions[index].correctOption) {

                              backgroundColor = correct.withOpacity(
                                  0.5);
                            } else {
                              // Opção neutra
                              backgroundColor = neutral;
                            }


                            return Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: maxWidth,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '$optionKey: $optionValue',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }),
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

import 'package:flutter/material.dart';
import '../constants.dart'; // aqui estão nossas cores

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    required this.questions,
    required this.indexAction,
    required this.totalQuestions,
  });

  final String questions;
  final int indexAction;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Questions ${indexAction + 1}/$totalQuestions: $questions',
        style: const TextStyle(
          fontSize: 24.0,
          color: neutral,
        ),
      ),
    );
  }
}

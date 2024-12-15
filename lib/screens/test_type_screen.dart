import 'package:flutter/material.dart';
import 'question_screen.dart';
import './results_screen.dart'; // Verifique o caminho correto se necessário

class TestTypeScreen extends StatelessWidget {
  final String title;
  final Map<String, String> course;

  const TestTypeScreen({
    Key? key,
    required this.title,
    required this.course,
  }) : super(key: key);

  void _navigateToQuestionScreen(BuildContext context, String jsonPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionScreen(jsonPath: jsonPath),
      ),
    );
  }

  void _navigateToResultsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            textStyle: const TextStyle(fontSize: 16.0),
            minimumSize: const Size(200, 50),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var entry in course.entries)
                _buildButton(
                  context,
                  entry.key,
                      () => _navigateToQuestionScreen(context, entry.value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

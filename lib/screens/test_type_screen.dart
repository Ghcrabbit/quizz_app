import 'package:flutter/material.dart';
import 'question_screen.dart';

class TestTypeScreen extends StatelessWidget {
  final String title;
  final Map<String, String> course;

  const TestTypeScreen({Key? key, required this.title, required this.course}) : super(key: key);

  void _navigateToQuestionScreen(BuildContext context, String jsonPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionScreen(jsonPath: jsonPath),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String jsonPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _navigateToQuestionScreen(context, jsonPath),
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
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: course.entries.map((entry) {
            final subject = entry.key;
            final jsonPath = entry.value;
            return _buildButton(context, subject, jsonPath);
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
  }) : super(key: key);

  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String message;
    Color backgroundColor;

    if (result >= 14) {
      message = 'Parabéns!';
      backgroundColor = correct;
    } else {
      message = 'Tente de novo';
      backgroundColor = incorrect;
    }

    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score',
              style: TextStyle(color: neutral, fontSize: 22.0),
            ),
            const SizedBox(height: 20.0),
            CircleAvatar(
              child: Text(
                '$result/$questionLength',
                style: TextStyle(fontSize: 30.0),
              ),
              radius: 70.0,
              backgroundColor: backgroundColor,
            ),
            const SizedBox(height: 20.0),
            Text(
              message,
              style: TextStyle(color: neutral),
            ),
            const SizedBox(height: 25.0),
            GestureDetector(
              onTap: onPressed,
              child: const Text(
                'Recomeçar',
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

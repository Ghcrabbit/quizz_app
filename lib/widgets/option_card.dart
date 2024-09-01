import 'package:flutter/material.dart';
import '../constants.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required this.option,
    required this.color,
  }) : super(key: key);

  final String option;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Color corTexto = color.red != color.green ? neutral : Colors.black;

    return Card(
      color: color,
      child: ListTile(
        title: Text(
          option,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            color: corTexto,
          ),
        ),
      ),
    );
  }
}

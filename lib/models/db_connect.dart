import 'dart:convert';
import 'package:flutter/services.dart';
import 'question_model.dart';
import 'dart:developer' as developer;

class DbConnect {
  Future<List<Question>> fetchNewQuestions(String jsonPath) async {
    try {
      String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> data = json.decode(jsonString);

      if (data['Question'] is List) {
        final List<dynamic> questionsJson = data['Question'];

        List<Question> allQuestions = questionsJson.map((jsonItem) {
          if (jsonItem is Map<String, dynamic>) {
            return Question.fromJson(jsonItem);
          } else {
            throw Exception(
                'Formato de pergunta inválido: não é um Map<String, dynamic>');
          }
        }).toList();

        allQuestions.shuffle();

        List<Question> selectedQuestions =
            allQuestions.take(20).toList(); // Seleciona 20 perguntas aleatórias

        return selectedQuestions;
      } else {
        throw Exception(
            'Formato de dados inesperado no JSON: "Question" não é uma lista');
      }
    } catch (e) {
      developer.log('Erro ao carregar novas perguntas do arquivo assets: $e',
          error: e);
      throw Exception('Erro ao carregar novas perguntas do arquivo assets: $e');
    }
  }
}

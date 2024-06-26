import 'dart:convert';
import 'package:flutter/services.dart';
import 'question_model.dart';
import 'dart:developer' as developer;

class DbConnect {
  Future<List<Question>> fetchNewQuestions(String jsonPath) async {
    try {
      // Carregar o arquivo JSON como string
      String jsonString = await rootBundle.loadString(jsonPath);

      // Decodificar o JSON em um mapa
      final Map<String, dynamic> data = json.decode(jsonString);

      // Verificar se o campo "Question" é uma lista
      if (data['Question'] is List) {
        final List<dynamic> questionsJson = data['Question'];

        // Converter a lista de JSONs em uma lista de objetos Question
        List<Question> allQuestions = questionsJson.map((jsonItem) {
          if (jsonItem is Map<String, dynamic>) {
            return Question.fromJson(jsonItem);
          } else {
            throw Exception(
                'Formato de pergunta inválido: não é um Map<String, dynamic>');
          }
        }).toList();

        // Embaralhar as perguntas
        allQuestions.shuffle();

        // Selecionar um número específico de perguntas
        List<Question> selectedQuestions = allQuestions.take(3).toList();

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

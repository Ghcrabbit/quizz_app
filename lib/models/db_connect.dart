import 'dart:convert';
import 'package:flutter/services.dart'; // Para carregar o JSON dos assets
import 'question_model.dart';
import 'dart:developer' as developer;

class DbConnect {
  Future<List<Question>> fetchQuestionsFromAssets() async {
    try {
      // Carrega o conteúdo do arquivo JSON dos assets
      String jsonString =
          await rootBundle.loadString('assets/data/updated-excel-to-json.json');

      // Decodifica o JSON para uma estrutura de dados
      final Map<String, dynamic> data = json.decode(jsonString);

      // Verifica se o JSON possui o campo "Question" como uma lista
      if (data['Question'] is List) {
        final List<dynamic> questionsJson = data['Question'];

        // Verificação de cada item da lista de perguntas
        List<Question> allQuestions = questionsJson.map((jsonItem) {
          if (jsonItem is Map<String, dynamic>) {
            return Question.fromJson(jsonItem);
          } else {
            throw Exception(
                'Formato de pergunta inválido: não é um Map<String, dynamic>');
          }
        }).toList();

        // Embaralha as perguntas
        allQuestions.shuffle();

        // Seleciona e retorna as primeiras 5 perguntas (ou menos, se houver menos de 5)
        List<Question> selectedQuestions = allQuestions.take(5).toList();

        return selectedQuestions;
      } else {
        throw Exception(
            'Formato de dados inesperado no JSON: "Question" não é uma lista');
      }
    } catch (e) {
      // Log de erro detalhado para ajudar na depuração
      developer.log('Erro ao carregar perguntas do arquivo assets: $e',
          error: e);
      throw Exception('Erro ao carregar perguntas do arquivo assets: $e');
    }
  }
}

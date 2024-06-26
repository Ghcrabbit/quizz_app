import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _keyResults = 'results';
  static const String _keySelectedAnswers = 'selected_answers';

  // Salvar resultado do quiz
  static Future<void> saveResult(String quizName, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      final newResult = {
        'quiz': quizName,
        'score': score,
        'date': DateTime.now().toIso8601String(),
      };

      results.add(json.encode(newResult));

      await prefs.setStringList(_keyResults, results);
    } catch (e) {
      print('Failed to save result: $e');
      throw Exception('Failed to save result: $e');
    }
  }

  // Carregar todos os resultados do quiz
  static Future<List<Map<String, dynamic>>> loadResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      return results
          .map((result) {
            try {
              final decodedResult = json.decode(result);

              if (decodedResult is Map<String, dynamic> &&
                  decodedResult['quiz'] is String &&
                  decodedResult['score'] is int &&
                  decodedResult['date'] is String) {
                return decodedResult;
              } else {
                return <String, dynamic>{};
              }
            } catch (e) {
              print('Failed to decode result: $e');
              return <String, dynamic>{};
            }
          })
          .where((result) => result.isNotEmpty)
          .toList();
    } catch (e) {
      print('Failed to load results: $e');
      throw Exception('Failed to load results: $e');
    }
  }

  // Limpar todos os resultados do quiz
  static Future<void> clearResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyResults);
    } catch (e) {
      print('Failed to clear results: $e');
      throw Exception('Failed to clear results: $e');
    }
  }

  // Remover um resultado específico do quiz
  static Future<void> removeResult(String quizName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      final updatedResults = results.where((result) {
        final decodedResult = json.decode(result);
        return decodedResult['quiz'] != quizName;
      }).toList();

      await prefs.setStringList(_keyResults, updatedResults);
    } catch (e) {
      print('Failed to remove result: $e');
      throw Exception('Failed to remove result: $e');
    }
  }

  // Salvar as respostas selecionadas para um quiz específico
  static Future<void> saveSelectedAnswers(
      String quizName, List<String> selectedAnswers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allSelectedAnswers = prefs.getString(_keySelectedAnswers);

      // Decodificar o JSON existente ou criar um novo Map se não houver dados salvos
      Map<String, dynamic> selectedAnswersMap =
          allSelectedAnswers != null ? json.decode(allSelectedAnswers) : {};

      // Atualizar ou adicionar as respostas selecionadas para o quiz atual
      selectedAnswersMap[quizName] = selectedAnswers;

      await prefs.setString(
          _keySelectedAnswers, json.encode(selectedAnswersMap));
    } catch (e) {
      print('Failed to save selected answers: $e');
      throw Exception('Failed to save selected answers: $e');
    }
  }

  // Carregar as respostas selecionadas para um quiz específico
  static Future<List<String>> loadSelectedAnswers(String quizName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allSelectedAnswers = prefs.getString(_keySelectedAnswers);

      if (allSelectedAnswers != null) {
        final selectedAnswersMap = json.decode(allSelectedAnswers);

        if (selectedAnswersMap[quizName] is List<dynamic>) {
          return List<String>.from(selectedAnswersMap[quizName]);
        }
      }

      return [];
    } catch (e) {
      print('Failed to load selected answers: $e');
      throw Exception('Failed to load selected answers: $e');
    }
  }
}

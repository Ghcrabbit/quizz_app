import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _keyResults = 'results';

  /// Salvar um resultado no SharedPreferences.
  static Future<void> saveResult(String quizName, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      // Novo resultado a ser salvo
      final newResult = {
        'quiz': quizName,
        'score': score,
        'date': DateTime.now().toIso8601String(),
      };

      // Adiciona o novo resultado à lista existente
      results.add(
          json.encode(newResult)); // Codifica o resultado como uma string JSON

      // Salva a lista atualizada no SharedPreferences
      await prefs.setStringList(_keyResults, results);
    } catch (e) {
      // Lida com exceções ou erros
      print('Failed to save result: $e');
      // Adicionar um tratamento adicional de erro ou notificação ao usuário, se necessário
      throw Exception('Failed to save result: $e');
    }
  }

  /// Carregar todos os resultados do SharedPreferences.
  static Future<List<Map<String, dynamic>>> loadResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      // Decodifica cada string salva de volta para um Map<String, dynamic>
      return results
          .map((result) {
            try {
              final Map<String, dynamic> decodedResult = json.decode(result);

              // Verifica se 'quiz', 'score' e 'date' não são nulos
              if (decodedResult != null &&
                  decodedResult['quiz'] != null &&
                  decodedResult['score'] != null &&
                  decodedResult['date'] != null) {
                return decodedResult;
              } else {
                // Retorna um Map vazio se qualquer campo necessário for nulo
                return <String, dynamic>{};
              }
            } catch (e) {
              print('Failed to decode result: $e');
              return <String,
                  dynamic>{}; // Retorna um Map<String, dynamic> vazio em caso de erro de decodificação
            }
          })
          .where((result) => result.isNotEmpty)
          .toList(); // Filtra mapas vazios
    } catch (e) {
      // Lida com exceções ou erros
      print('Failed to load results: $e');
      // Adicionar um tratamento adicional de erro ou notificação ao usuário, se necessário
      throw Exception('Failed to load results: $e');
    }
  }

  /// Limpar todos os resultados do SharedPreferences.
  static Future<void> clearResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyResults);
    } catch (e) {
      // Lida com exceções ou erros
      print('Failed to clear results: $e');
      // Adicionar um tratamento adicional de erro ou notificação ao usuário, se necessário
      throw Exception('Failed to clear results: $e');
    }
  }
}

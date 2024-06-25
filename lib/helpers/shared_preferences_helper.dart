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
              final decodedResult = json.decode(result);

              // Verifica se o resultado tem a estrutura correta
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
              return <String,
                  dynamic>{}; // Retorna um Map<String, dynamic> vazio em caso de erro de decodificação
            }
          })
          .where((result) => result.isNotEmpty)
          .toList(); // Filtra mapas vazios
    } catch (e) {
      // Lida com exceções ou erros
      print('Failed to load results: $e');
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
      throw Exception('Failed to clear results: $e');
    }
  }

  /// Remover um resultado específico do SharedPreferences.
  static Future<void> removeResult(String quizName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final results = prefs.getStringList(_keyResults) ?? [];

      // Filtra os resultados que não correspondem ao quizName
      final updatedResults = results.where((result) {
        final decodedResult = json.decode(result);
        return decodedResult['quiz'] != quizName;
      }).toList();

      // Atualiza os resultados no SharedPreferences
      await prefs.setStringList(_keyResults, updatedResults);
    } catch (e) {
      print('Failed to remove result: $e');
      throw Exception('Failed to remove result: $e');
    }
  }
}

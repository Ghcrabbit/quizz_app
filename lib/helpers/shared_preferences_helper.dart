import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:app_cms_ghc/models/question_model.dart';

class SharedPreferencesHelper {
  static const String _keyResults = 'results';
  static const String _keySelectedAnswers = 'selected_answers';

  static Future<void> saveResult(
      String quizName,
      int score,
      List<Question> questions,
      List<String> selectedAnswers,
      [String? course]) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Caso o curso não tenha sido fornecido, busque o salvo
      course ??= prefs.getString('selected_course') ?? 'Curso Desconhecido';

      final results = prefs.getStringList(_keyResults) ?? [];
      final color = score >= 14 ? Colors.green[200]?.value : Colors.red[200]?.value;

      final newResult = {
        'quiz': quizName,
        'score': score,
        'date': DateTime.now().toIso8601String(),
        'questions': questions.map((q) => q.toJson()).toList(),
        'selectedAnswers': selectedAnswers,
        'color': color,
        'course': course, // Campo do curso
      };

      results.add(json.encode(newResult));
      await prefs.setStringList(_keyResults, results);
    } catch (e) {
      print('Failed to save result: $e');
      throw Exception('Failed to save result: $e');
    }
  }
  Future<String?> getSelectedCourse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_course');
  }

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


  static Future<void> clearResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyResults);
    } catch (e) {
      print('Failed to clear results: $e');
      throw Exception('Failed to clear results: $e');
    }
  }




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


  static Future<void> updateResults(List<Map<String, dynamic>> results) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedResults =
          results.map((result) => json.encode(result)).toList();
      await prefs.setStringList(_keyResults, encodedResults);
    } catch (e) {
      print('Failed to update results: $e');
      throw Exception('Failed to update results: $e');
    }
  }


  static Future<void> saveSelectedAnswers(
      String quizName, List<String> selectedAnswers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allSelectedAnswers = prefs.getString(_keySelectedAnswers);


      Map<String, dynamic> selectedAnswersMap =
          allSelectedAnswers != null ? json.decode(allSelectedAnswers) : {};


      selectedAnswersMap[quizName] = selectedAnswers;

      await prefs.setString(
          _keySelectedAnswers, json.encode(selectedAnswersMap));
    } catch (e) {
      print('Failed to save selected answers: $e');
      throw Exception('Failed to save selected answers: $e');
    }
  }


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


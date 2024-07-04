import 'dart:developer' as developer;

class Question {
  final int id;
  final String question;
  final String subject;
  final Map<String, String> options;
  final String correctOption;

  Question({
    required this.id,
    required this.question,
    required this.subject,
    required this.options,
    required this.correctOption,
  });

  // Função auxiliar para converter qualquer valor para String
  static String toStringValue(dynamic value) {
    if (value == null) {
      return '';
    } else if (value is String) {
      return value;
    } else if (value is int || value is double || value is bool) {
      return value.toString();
    } else {
      throw Exception("Valor inesperado: $value");
    }
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      // Extraindo as opções
      Map<String, String> options = {
        'A': toStringValue(json['A']),
        'B': toStringValue(json['B']),
        'C': toStringValue(json['C']),
        'D': toStringValue(json['D']),
      };

      // Extraindo a resposta correta (RESP)
      String correctOptionKey = toStringValue(json['RESP']).toUpperCase();

      // Verificando se a resposta correta está entre as chaves das opções
      if (!options.containsKey(correctOptionKey)) {
        throw Exception(
            "A resposta correta não está entre as opções fornecidas.");
      }

      // Retornando a instância de Question
      return Question(
        id: int.parse(json['ID'].toString()),
        question: toStringValue(json['PERGUNTA']),
        subject: toStringValue(json['MATÉRIA']),
        options: options,
        correctOption: options[correctOptionKey]!,
      );
    } catch (e) {
      developer.log('Erro ao converter JSON para Question: $e');
      throw Exception('Erro ao converter JSON para Question: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'PERGUNTA': question,
      'MATÉRIA': subject,
      'A': options['A'],
      'B': options['B'],
      'C': options['C'],
      'D': options['D'],
      'RESP': options.keys.firstWhere((key) => options[key] == correctOption),
    };
  }

  @override
  String toString() {
    return 'Question(id: $id, question: $question, subject: $subject, options: $options, correctOption: $correctOption)';
  }
}

import 'package:flutter/material.dart';
import '../helpers/shared_preferences_helper.dart';
import 'result_detail_screen.dart';
import 'package:intl/intl.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  void _loadResults() async {
    try {
      List<Map<String, dynamic>> results =
          await SharedPreferencesHelper.loadResults();
      setState(() {
        _results = results.reversed.toList();
      });
    } catch (e) {
      print('Failed to load results: $e');
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Anteriores'),
      ),
      backgroundColor: Colors.grey[200], // Altere para a cor desejada aqui
      body: _results.isEmpty
          ? Center(
              child: Text('Nenhum resultado disponível.'),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.quiz,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      result['quiz'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${_formatDate(result['date'])} - Resultado: ${result['score']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Implementar ação de compartilhar
                      },
                    ),
                    onTap: () async {
                      // Carregar as respostas selecionadas para o quiz específico
                      List<String> selectedAnswers =
                          await SharedPreferencesHelper.loadSelectedAnswers(
                              result['quiz']);

                      // Navegar para ResultDetailScreen ao clicar no resultado
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultDetailScreen(
                            quizName: result['quiz'],
                            score: result['score'],
                            date: _formatDate(result['date']),
                            selectedAnswers: selectedAnswers,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

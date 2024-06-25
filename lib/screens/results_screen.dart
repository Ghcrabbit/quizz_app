import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/shared_preferences_helper.dart';

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
        _results =
            results.reversed.toList(); // Invertendo a ordem dos resultados
      });
    } catch (e) {
      print('Failed to load results: $e');
      // Tratar erro de carregamento aqui, se necessário
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy - HH:mm').format(date); // Formato desejado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Anteriores'),
      ),
      body: _results.isEmpty
          ? const Center(
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
                      '${_formatDate(result['date'])} - Resultado alterado: ${result['score']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Implementar ação de compartilhar
                      },
                    ),
                    onTap: () {
                      // Implementar ação ao clicar no resultado
                    },
                  ),
                );
              },
            ),
    );
  }
}

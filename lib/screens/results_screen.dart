import 'package:flutter/material.dart';
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
        // Invertendo a ordem dos resultados para exibir os últimos primeiro
        _results = results.reversed.toList();
      });
    } catch (e) {
      print('Failed to load results: $e');
      // Tratar erro de carregamento aqui, se necessário
    }
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
                    title: Text(
                      result['quiz'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${result['date']} - Resultado: ${result['score']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      // Implemente aqui o que deseja fazer ao clicar no resultado
                    },
                  ),
                );
              },
            ),
    );
  }
}

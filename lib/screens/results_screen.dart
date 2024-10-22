import 'package:flutter/material.dart';
import '../helpers/shared_preferences_helper.dart';
import 'result_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:app_cms_ghc/models/question_model.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, dynamic>> _results = [];
  bool _isSelecting = false;
  List<Map<String, dynamic>> _selectedResults = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      final results = await SharedPreferencesHelper.loadResults();
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


  void _deleteSelectedResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir os testes selecionados?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _results.removeWhere((result) => _selectedResults.contains(result));
                });
                await SharedPreferencesHelper.updateResults(_results);
                setState(() {
                  _selectedResults.clear();
                  _isSelecting = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


  void _deleteAllResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir tudo'),
          content: const Text('Tem certeza que deseja excluir todos os testes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _results.clear();
                });
                await SharedPreferencesHelper.updateResults(_results);
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


  void _selectAllResults(bool select) {
    setState(() {
      select ? _selectedResults.addAll(_results) : _selectedResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelecting ? 'Selecionar Testes' : 'Resultados Anteriores'),
        actions: _isSelecting
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _selectedResults.isEmpty ? null : _deleteSelectedResults,
          ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () {
              if (_selectedResults.length == _results.length) {
                _selectAllResults(false);
              } else {
                _selectAllResults(true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                _isSelecting = false;
                _selectedResults.clear();
              });
            },
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _results.isEmpty ? null : _deleteAllResults,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _results.isEmpty
                ? null
                : () {
              setState(() {
                _isSelecting = true;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _results.isEmpty
          ? const Center(child: Text('Nenhum resultado disponível.'))
          : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final isSelected = _selectedResults.contains(result);

          return Card(
            color: result.containsKey('color')
                ? Color(result['color'])
                : (result['score'] >= 14 ? Colors.green[200] : Colors.red[200]),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: _isSelecting
                  ? Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    value ?? false
                        ? _selectedResults.add(result)
                        : _selectedResults.remove(result);
                  });
                },
              )
                  : null,
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  result['quiz'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Center(
                child: Text(
                  '${_formatDate(result['date'])} - Acertos: ${result['score']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (_isSelecting) {
                  setState(() {
                    isSelected
                        ? _selectedResults.remove(result)
                        : _selectedResults.add(result);
                  });
                } else {
                  final questions = (result['questions'] as List)
                      .map((q) => Question.fromJson(q))
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultDetailScreen(
                        quizName: result['quiz'],
                        score: result['score'],
                        date: _formatDate(result['date']),
                        questions: questions,
                        selectedAnswers: List<String>.from(result['selectedAnswers']),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

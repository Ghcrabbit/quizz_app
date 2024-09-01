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

  void _deleteSelectedResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content:
              Text('Tem certeza que deseja excluir os testes selecionados?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () async {
                setState(() {
                  _results.removeWhere(
                      (result) => _selectedResults.contains(result));
                });

                // Atualizar o SharedPreferences com a nova lista de resultados
                await SharedPreferencesHelper.updateResults(_results);

                setState(() {
                  _selectedResults.clear();
                  _isSelecting = false;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectAllResults(bool select) {
    setState(() {
      if (select) {
        _selectedResults.addAll(_results);
      } else {
        _selectedResults.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isSelecting ? 'Selecionar Testes' : 'Resultados Anteriores'),
        actions: _isSelecting
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteSelectedResults();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _selectedResults.clear();
                      _isSelecting = false;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: () {
                    _selectAllResults(true);
                  },
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    setState(() {
                      _isSelecting = true;
                    });
                  },
                ),
              ],
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
                final isSelected = _selectedResults.contains(result);

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
                    trailing: _isSelecting
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null && value) {
                                  _selectedResults.add(result);
                                } else {
                                  _selectedResults.remove(result);
                                }
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Implementar ação de compartilhar
                            },
                          ),
                    onTap: () async {
                      if (_isSelecting) {
                        setState(() {
                          if (isSelected) {
                            _selectedResults.remove(result);
                          } else {
                            _selectedResults.add(result);
                          }
                        });
                      } else {
                        // Converter perguntas de volta do JSON
                        List<Question> questions = (result['questions'] as List)
                            .map((q) => Question.fromJson(q))
                            .toList();

                        // Navegar para ResultDetailScreen ao clicar no resultado
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultDetailScreen(
                              quizName: result['quiz'],
                              score: result['score'],
                              date: _formatDate(result['date']),
                              questions: questions,
                              selectedAnswers:
                                  List<String>.from(result['selectedAnswers']),
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_type_screen.dart';
import './results_screen.dart'; // Verifique o caminho correto se necessário


// Constantes para melhorar a manutenção
const String pilotoPrivadoTitle = 'Piloto Privado Avião';
const String comissarioDeVooTitle = 'Comissário de Voo';
const String resultadosTitle = 'Ver Resultados Anteriores';

// Widget de botão personalizado
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            textStyle: const TextStyle(fontSize: 16.0),
            minimumSize: const Size(200, 50),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  // Método para salvar o curso selecionado
  Future<void> _saveSelectedCourseAndNavigate(BuildContext context, String course) async {
    await saveSelectedCourse(course); // Chama o método para salvar o curso selecionado
    _navigateToTypeTest(context, course);
  }

  // Navegação para a tela de TestTypeScreen
  void _navigateToTypeTest(BuildContext context, String title) {
    final Map<String, String> blocks = title == pilotoPrivadoTitle
        ? {
      'Conhecimentos Técnicos': 'assets/data/conhecimentos tecnicos.json',
      'Meteorologia': 'assets/data/meteorologia.json',
      'Navegação': 'assets/data/navegacao.json',
      'Regulamentos de Voo': 'assets/data/regulamentos.json',
      'Teoria de Voo': 'assets/data/teoria de voo.json',
    }
        : {
      'Emergência e Segurança': 'assets/data/Emergência e Segurança.json',
      'Regulamentação da Profissão': 'assets/data/Regulamentação da Profissão.json',
      'Primeiros Socorros': 'assets/data/Primeiros Socorros.json',
      'Conhecimento Gerais': 'assets/data/Conhecimento Gerais.json',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestTypeScreen(
          title: title,
          course: blocks,
        ),
      ),
    );
  }

  // Navegação para a tela de resultados
  void _navigateToResultsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultsScreen(),
      ),
    );
  }

  // Construção do botão customizado
  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Menu Principal',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildButton(
                context,
                pilotoPrivadoTitle,
                    () => _saveSelectedCourseAndNavigate(context, pilotoPrivadoTitle), // Salva o curso e navega
              ),
              _buildButton(
                context,
                comissarioDeVooTitle,
                    () => _saveSelectedCourseAndNavigate(context, comissarioDeVooTitle), // Salva o curso e navega
              ),
              _buildButton(
                context,
                resultadosTitle,
                    () => _navigateToResultsScreen(context), // Apenas navega
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> saveSelectedCourse(String course) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_course', course);
  }
}

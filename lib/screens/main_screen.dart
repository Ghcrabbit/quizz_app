import 'package:flutter/material.dart';
import 'test_type_screen.dart';
import './results_screen.dart'; // Verifique o caminho correto se necessário

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void _navigateToTypeTestPilotoPrivado(BuildContext context) {
    final Map<String, String> pilotoPrivadoBlocks = {
      'Conhecimentos Técnicos': 'assets/data/conhecimentos tecnicos.json',
      'Meteorologia': 'assets/data/meteorologia.json',
      'Navegação': 'assets/data/navegacao.json',
      'Regulamentos de Voo': 'assets/data/regulamentos.json',
      'Teoria de Voo': 'assets/data/teoria de voo.json',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestTypeScreen(
          title: 'Piloto Privado Avião',
          blocks: pilotoPrivadoBlocks,
        ),
      ),
    );
  }

  void _navigateToInitialScreenCMS(BuildContext context) {
    final Map<String, String> cmsBlocks = {
      'Regulamentos de Voo': 'assets/data/regulamentos.json',
      'Teoria de Voo': 'assets/data/teoria de voo.json',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestTypeScreen(
          title: 'Comissário de Voo',
          blocks: cmsBlocks,
        ),
      ),
    );
  }

  void _navigateToResultsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
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
                'Piloto Privado Avião',
                    () => _navigateToTypeTestPilotoPrivado(context),
              ),
              _buildButton(
                context,
                'Comissário de Voo',
                    () => _navigateToInitialScreenCMS(context),
              ),
              _buildButton(
                context,
                'Ver Resultados Anteriores',
                    () => _navigateToResultsScreen(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

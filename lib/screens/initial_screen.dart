import 'package:flutter/material.dart';
import 'question_screen.dart';
import './results_screen.dart'; // Verifique o caminho correto se necessário

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  static const String bloco1Path = 'assets/data/bloco_1.json';
  static const String bloco2Path = 'assets/data/bloco_2.json';
  static const String bloco3Path = 'assets/data/bloco_3.json';
  static const String bloco4Path = 'assets/data/bloco_4.json';

  void _navigateToHomeScreen(BuildContext context, String jsonPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(jsonPath: jsonPath),
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

  Widget _buildButton(BuildContext context, String text,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
        title: const PreferredSize(
          preferredSize: Size.fromHeight(120.0), // Altura do AppBar com padding
          child: Padding(
            padding: EdgeInsets.only(top: 40.0), // Ajusta a distância do título para baixo
            child: Text(
              'Escolha o bloco',
              style: TextStyle(fontSize: 20.0), // Estilize o texto se necessário
            ),
          ),
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
                'Bloco 1 - Emergência e Segurança de voo',
                    () => _navigateToHomeScreen(context, bloco1Path),
              ),
              _buildButton(
                context,
                'Bloco 2 - Regulamentação',
                    () => _navigateToHomeScreen(context, bloco2Path),
              ),
              _buildButton(
                context,
                'Bloco 3 - Primeiros Socorros',
                    () => _navigateToHomeScreen(context, bloco3Path),
              ),
              _buildButton(
                context,
                'Bloco 4 - Conhecimentos gerais da aeronave',
                    () => _navigateToHomeScreen(context, bloco4Path),
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

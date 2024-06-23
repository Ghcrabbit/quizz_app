import 'package:flutter/material.dart';
import './home_screen.dart';
import './results_screen.dart'; // Importe o arquivo results_screen.dart

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
        builder: (context) => const ResultsScreen(),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity, // O botão ocupará toda a largura disponível
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            textStyle: const TextStyle(fontSize: 16.0),
            minimumSize:
                const Size(200, 50), // Define o tamanho mínimo do botão
          ),
          child: Text(
            text,
            textAlign: TextAlign.center, // Centraliza o texto
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o bloco'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  20.0), // Adicionei padding para centralizar os botões na tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Os botões vão se esticar para ocupar toda a largura disponível
            children: [
              _buildButton(context, 'Bloco 1 - Emergência e Segurança de voo',
                  () => _navigateToHomeScreen(context, bloco1Path)),
              _buildButton(context, 'Bloco 2 - Regulamentação',
                  () => _navigateToHomeScreen(context, bloco2Path)),
              _buildButton(context, 'Bloco 3 - Primeiros Socorros',
                  () => _navigateToHomeScreen(context, bloco3Path)),
              _buildButton(
                  context,
                  'Bloco 4 - Conhecimentos gerais da aeronave',
                  () => _navigateToHomeScreen(context, bloco4Path)),
              _buildButton(context, 'Ver Resultados Anteriores',
                  () => _navigateToResultsScreen(context)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'initial_screen.dart'; // Certifique-se de que o caminho está correto

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void _navigateToInitialScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InitialScreen(),
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
                    () => _navigateToInitialScreen(context),
              ),
              _buildButton(
                context,
                'Em breve',
                    () {
                  // Ação a ser definida no futuro
                },
              ),
              _buildButton(
                context,
                'Em breve',
                    () {
                  // Ação a ser definida no futuro
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

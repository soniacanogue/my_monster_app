import 'package:flutter/material.dart';

class SelectorView extends StatelessWidget {
  const SelectorView({super.key});

  // Navega a la vista de flashcards, enviando la cantidad de cartas
  void _irAFlashcards(BuildContext context, int cantidad) {
    Navigator.pushNamed(
      context,
      '/flashcards',
      arguments: cantidad,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A15E0), // Fondo azul intenso
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona tu mazo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              _botonMazo(context, '7 cartas', 7),
              _botonMazo(context, '10 cartas', 10),
              _botonMazo(context, '20 cartas', 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para crear cada botón de selección de mazo
  Widget _botonMazo(BuildContext context, String texto, int cantidad) {
    return GestureDetector(
      onTap: () => _irAFlashcards(context, cantidad),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7232), // Color del botón (naranja)
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3), // Sombra inferior derecha
              offset: Offset(12, 12),
              blurRadius: 18,
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.6), // Luz superior izquierda
              offset: Offset(-9, -8),
              blurRadius: 18,
            ),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

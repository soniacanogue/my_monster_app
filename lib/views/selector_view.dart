import 'package:flutter/material.dart';
import '../controllers/selector_controller.dart';

class SelectorView extends StatefulWidget {
  const SelectorView({super.key});

  @override
  State<SelectorView> createState() => _SelectorViewState();
}

class _SelectorViewState extends State<SelectorView> {
  late SelectorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SelectorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Navega a la vista de flashcards, enviando la cantidad de cartas
  void _irAFlashcards(BuildContext context, int cantidad) async {
    try {
      await _controller.cargarMazo(cantidad);
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/flashcards',
          arguments: cantidad,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A15E0),
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
                  ..._controller.mazos.map((mazo) => 
                    _botonMazo(
                      context, 
                      mazo['nombre'], 
                      mazo['cantidad']
                    )
                  ),
                  if (_controller.isLoading) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget para crear cada botón de selección de mazo
  Widget _botonMazo(BuildContext context, String texto, int cantidad) {
    return GestureDetector(
      onTap: _controller.isLoading ? null : () => _irAFlashcards(context, cantidad),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: _controller.isLoading 
              ? Colors.grey 
              : const Color(0xFFFF7232),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              offset: Offset(12, 12),
              blurRadius: 18,
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.6),
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

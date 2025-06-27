import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';

class FlashcardsView extends StatefulWidget {
  const FlashcardsView({Key? key}) : super(key: key);

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> {
  List<FlashCard> _cartas = [];
  int _indiceActual = 0;
  bool _mostrarFrente = true;

  @override
  void initState() {
    super.initState();
    _cargarCartas();
  }

  void _cargarCartas() async {
    final servicio = FlashCardService();
    final cartas = await servicio.cargarCartasDesdeJson();

    setState(() {
      _cartas = cartas.take(10).toList(); // puedes cambiar a 7 o 20
    });
  }

  void _voltearCarta() {
    setState(() {
      _mostrarFrente = !_mostrarFrente;
    });
  }

  void _siguienteCarta() {
    if (_indiceActual < _cartas.length - 1) {
      setState(() {
        _indiceActual++;
        _mostrarFrente = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡Terminaste!'),
          content: const Text('Has visto todas las cartas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cartas.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final carta = _cartas[_indiceActual];
    final Color fondo = _mostrarFrente ? const Color(0xFF0A15E0) : Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: _voltearCarta,
          onDoubleTap: _siguienteCarta,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Container(
              key: ValueKey(_mostrarFrente),
              width: 400,
              height: 500,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: fondo,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: _mostrarFrente
                    ? Text(
                        carta.titulo,
                        style: const TextStyle(
                          color: Color(0xFFFF7232),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            carta.definicion,
                            style: const TextStyle(
                              color: Color(0xFFFF7232),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Ejemplo:\n${carta.ejemplo}',
                            style: const TextStyle(
                              color: Color(0xFFFF7232),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

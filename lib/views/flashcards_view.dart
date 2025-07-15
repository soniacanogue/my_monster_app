import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../models/flashcard.dart';
import '../controllers/flashcards_controller.dart';

class FlashcardsView extends StatefulWidget {
  final FlashcardsController controller;
  const FlashcardsView({Key? key, required this.controller}) : super(key: key);

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> with SingleTickerProviderStateMixin {
  late FlashcardsController _controller;

  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _slideController.reset();
        _controller.avanzarCarta();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _mostrarDespedida() {
    showDialog(
      context: context,
      barrierDismissible: false, // No permitir cerrar tocando fuera
      builder: (context) => AlertDialog(
        title: const Text('¡Terminaste!'),
        content: const Text('Has visto todas las cartas.'),
        actions: [
          TextButton(
            onPressed: () async {
              // Cerrar el diálogo
              Navigator.pop(context);
              // Guardar progreso y navegar a la vista de gracias
              await _guardarProgresoYMostrarDespedida();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarProgresoYMostrarDespedida() async {
    await _controller.guardarProgreso();
    if (mounted) {
      Navigator.pushNamed(context, '/gracias');
    }
  }

  void _onDoubleTap() {
    if (_cardKey.currentState != null && !_cardKey.currentState!.isFront) {
      _cardKey.currentState!.toggleCard();
      Future.delayed(const Duration(milliseconds: 300), () {
        _slideController.forward();
      });
    } else {
      _slideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_controller.cartas.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('No hay cartas disponibles')),
          );
        }

        final carta = _controller.cartaActual!;

        // Mostrar despedida si es la última carta
        if (_controller.esUltimaCarta && _controller.indiceActual == _controller.cartas.length - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mostrarDespedida();
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A15E0),
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '${_controller.indiceActual + 1} / ${_controller.totalCartas}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Salir y guardar',
                  onPressed: _guardarProgresoYMostrarDespedida,
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: () {
                  if (_cardKey.currentState != null) {
                    _cardKey.currentState!.toggleCard();
                  }
                },
                onDoubleTap: _onDoubleTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: FlipCard(
                    key: _cardKey,
                    flipOnTouch: false,
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardContent(carta.titulo, true),
                    back: _buildCardContent('${carta.definicion}\n\nEjemplo:\n${carta.ejemplo}', false),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //  Carta con efecto plastilina realista y drop shadows más intensas
  Widget _buildCardContent(String texto, bool esFrente) {
    return Container(
      width: double.infinity,
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: esFrente ? null : Colors.white,
        gradient: esFrente
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B18F0), // luz azul
                  Color(0xFF0A15E0), // azul medio
                  Color(0xFF080FC8), // sombra azul
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4), // sombra profunda
            offset: const Offset(14, 14),
            blurRadius: 28,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4), // luz difusa
            offset: const Offset(-10, -10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Center(
        child: Text(
          texto,
          style: TextStyle(
            color: const Color(0xFFFF7232),
            fontSize: esFrente ? 32 : 20,
            fontWeight: esFrente ? FontWeight.bold : FontWeight.normal,
            fontStyle: esFrente ? FontStyle.normal : FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

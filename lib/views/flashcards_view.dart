import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';

class FlashcardsView extends StatefulWidget {
  const FlashcardsView({Key? key}) : super(key: key);

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> with SingleTickerProviderStateMixin {
  List<FlashCard> _cartas = [];
  int _indiceActual = 0;
  int _cantidad = 10;

  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
        _avanzarCarta();
      }
    });

    Future.delayed(Duration.zero, () {
      final cantidad = ModalRoute.of(context)?.settings.arguments as int? ?? 10;
      _cantidad = cantidad;
      _cargarCartas(cantidad);
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _cargarCartas(int cantidad) async {
    final prefs = await SharedPreferences.getInstance();
    final indexGuardado = prefs.getInt('indice_guardado') ?? 0;

    final servicio = FlashCardService();
    final cartas = await servicio.cargarCartasDesdeJson();

    setState(() {
      _cartas = cartas.take(cantidad).toList();
      _indiceActual = indexGuardado < cantidad ? indexGuardado : 0;
    });
  }

  void _avanzarCarta() {
    if (_indiceActual < _cartas.length - 1) {
      setState(() {
        _indiceActual++;
      });
    } else {
      _mostrarDespedida();
    }
  }

  void _mostrarDespedida() {
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

  Future<void> _guardarProgresoYMostrarDespedida() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('indice_guardado', _indiceActual);
    await prefs.setInt('cantidad_guardada', _cantidad);
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
    if (_cartas.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final carta = _cartas[_indiceActual];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A15E0),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            '${_indiceActual + 1} / ${_cartas.length}',
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
              padding: const EdgeInsets.symmetric(horizontal: 48.0), //  Más espacio lateral
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

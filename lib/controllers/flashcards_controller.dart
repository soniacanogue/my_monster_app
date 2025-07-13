import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';

class FlashcardsController extends ChangeNotifier {
  List<FlashCard> _cartas = [];
  int _indiceActual = 0;
  int _cantidad = 10;
  bool _isLoading = true;

  // Getters
  List<FlashCard> get cartas => _cartas;
  int get indiceActual => _indiceActual;
  int get cantidad => _cantidad;
  bool get isLoading => _isLoading;
  FlashCard? get cartaActual => _cartas.isNotEmpty && _indiceActual < _cartas.length 
      ? _cartas[_indiceActual] 
      : null;
  bool get esUltimaCarta => _indiceActual >= _cartas.length - 1;
  int get totalCartas => _cartas.length;

  void inicializar(int cantidad) {
    _cantidad = cantidad;
    _cargarCartas(cantidad);
  }

  Future<void> _cargarCartas(int cantidad) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final indexGuardado = prefs.getInt('indice_guardado') ?? 0;

      final servicio = FlashCardService();
      final cartas = await servicio.cargarCartasDesdeJson();

      _cartas = cartas.take(cantidad).toList();
      _indiceActual = indexGuardado < cantidad ? indexGuardado : 0;
    } catch (e) {
      // Manejar errores si es necesario
      debugPrint('Error cargando cartas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void avanzarCarta() {
    if (_indiceActual < _cartas.length - 1) {
      _indiceActual++;
      notifyListeners();
    } else {
      _mostrarDespedida();
    }
  }

  void _mostrarDespedida() {
    // Esta función se manejará en la vista ya que requiere contexto
    // El controlador solo notifica que se debe mostrar la despedida
    notifyListeners();
  }

  Future<void> guardarProgreso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('indice_guardado', _indiceActual);
    await prefs.setInt('cantidad_guardada', _cantidad);
  }

  void resetearProgreso() {
    _indiceActual = 0;
    notifyListeners();
  }

  bool get puedeAvanzar => _indiceActual < _cartas.length - 1;
} 
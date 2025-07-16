import 'package:flutter/material.dart';
// SharedPreferences eliminado, solo Firebase
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


  void inicializar([int? cantidad]) async {
    if (cantidad != null) {
      _cantidad = cantidad;
    }
    await _cargarCartas(_cantidad);
  }

  Future<void> _cargarCartas(int cantidad) async {
    _isLoading = true;
    notifyListeners();
    try {
      final servicio = FlashCardService();
      final cartas = await servicio.cargarCartasDesdeJson();
      _cartas = cartas.take(cantidad).toList();
    } catch (e) {
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
    // Guardar solo en Firestore si el usuario está autenticado
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
        'progreso': {
          'indice': _indiceActual,
          'cantidad': _cantidad,
        },
      });
    }
  }

  void resetearProgreso() {
    _indiceActual = 0;
    notifyListeners();
  }

  bool get puedeAvanzar => _indiceActual < _cartas.length - 1;


  // Método eliminado: limpiarProgresoLocal

  /// Carga el progreso del usuario actual desde Firestore y las cartas
  Future<void> cargarProgresoDesdeFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['progreso'] != null) {
        final progreso = data['progreso'];
        _indiceActual = progreso['indice'] ?? 0;
        _cantidad = progreso['cantidad'] ?? 10;
        await _cargarCartas(_cantidad);
        notifyListeners();
      }
    }
  }
} 
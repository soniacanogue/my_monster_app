import 'package:flutter/material.dart';

class SelectorController extends ChangeNotifier {
  // Opciones de mazos disponibles
  static const List<Map<String, dynamic>> mazosDisponibles = [
    {'nombre': '7 cartas', 'cantidad': 7},
    {'nombre': '10 cartas', 'cantidad': 10},
    {'nombre': '20 cartas', 'cantidad': 20},
  ];

  int? _mazoSeleccionado;
  bool _isLoading = false;

  // Getters
  int? get mazoSeleccionado => _mazoSeleccionado;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get mazos => mazosDisponibles;

  void seleccionarMazo(int cantidad) {
    _mazoSeleccionado = cantidad;
    notifyListeners();
  }

  void limpiarSeleccion() {
    _mazoSeleccionado = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Validar si la cantidad es válida
  bool esCantidadValida(int cantidad) {
    return mazosDisponibles.any((mazo) => mazo['cantidad'] == cantidad);
  }

  // Obtener información del mazo por cantidad
  Map<String, dynamic>? obtenerMazoPorCantidad(int cantidad) {
    try {
      return mazosDisponibles.firstWhere((mazo) => mazo['cantidad'] == cantidad);
    } catch (e) {
      return null;
    }
  }

  // Simular carga de mazo (para futuras funcionalidades)
  Future<void> cargarMazo(int cantidad) async {
    if (!esCantidadValida(cantidad)) {
      throw Exception('Cantidad de cartas no válida');
    }

    setLoading(true);
    
    // Simular tiempo de carga
    await Future.delayed(const Duration(milliseconds: 500));
    
    seleccionarMazo(cantidad);
    setLoading(false);
  }
} 
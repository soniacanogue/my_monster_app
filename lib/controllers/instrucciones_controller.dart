import 'package:flutter/material.dart';

class InstruccionesController extends ChangeNotifier {
  bool _isLoading = false;
  int _pasoActual = 0;

  // Lista de instrucciones
  static const List<Map<String, dynamic>> instrucciones = [
    {
      'titulo': '¡Bienvenido a My Monster App! 🎉',
      'descripcion': 'Tu app de estudio de programación con JavaScript',
      'icono': Icons.code,
      'color': Color(0xFF0A15E0),
    },
    {
      'titulo': 'Navegación por Cartas',
      'descripcion': '• Un tap: Gira la carta de adelante hacia atrás\n• Doble tap: Cambia a la siguiente carta',
      'icono': Icons.touch_app,
      'color': Color(0xFFFF7232),
    },
    {
      'titulo': 'Funcionalidades',
      'descripcion': '• Selecciona mazos de 7, 10 o 20 cartas\n• Tu progreso se guarda automáticamente\n• Puedes continuar desde donde lo dejaste',
      'icono': Icons.school,
      'color': Color(0xFF0A15E0),
    },
  ];

  // Getters
  bool get isLoading => _isLoading;
  int get pasoActual => _pasoActual;
  List<Map<String, dynamic>> get pasos => instrucciones;
  bool get esUltimoPaso => _pasoActual >= instrucciones.length - 1;
  bool get esPrimerPaso => _pasoActual == 0;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void actualizarPasoActual(int paso) {
    _pasoActual = paso;
    notifyListeners();
  }

  void siguientePaso() {
    if (_pasoActual < instrucciones.length - 1) {
      _pasoActual++;
      notifyListeners();
    }
  }

  void pasoAnterior() {
    if (_pasoActual > 0) {
      _pasoActual--;
      notifyListeners();
    }
  }

  void irAlSelector() {
    setLoading(true);
    // Simular carga breve
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
    });
  }

  void saltarInstrucciones() {
    setLoading(true);
    // Simular carga breve
    Future.delayed(const Duration(milliseconds: 300), () {
      setLoading(false);
    });
  }
} 
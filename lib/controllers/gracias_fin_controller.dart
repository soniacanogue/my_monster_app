import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flashcards_controller.dart';

class GraciasFinController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Cerrar sesión completamente (borra datos de login)
  Future<bool> cerrarSesion() async {
    setLoading(true);
    _errorMessage = null;

    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Limpiar progreso local
      await FlashcardsController.limpiarProgresoLocal();

      final prefs = await SharedPreferences.getInstance();
      
      // Borra solo los datos de login
      await prefs.remove('user_email');
      await prefs.remove('user_pass');

      setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión: $e';
      setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Volver al selector manteniendo progreso y sesión
  Future<bool> volverAlSelector() async {
    setLoading(true);
    _errorMessage = null;

    try {
      // No borra los datos de login, solo mantiene el progreso
      // El usuario sigue logueado y puede volver al selector
      setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Error al volver al selector: $e';
      setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Verificar si hay progreso guardado
  Future<bool> tieneProgresoGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indiceGuardado = prefs.getInt('indice_guardado');
      final cantidadGuardada = prefs.getInt('cantidad_guardada');
      
      return indiceGuardado != null && cantidadGuardada != null;
    } catch (e) {
      return false;
    }
  }

  // Obtener información del progreso guardado
  Future<Map<String, int>?> obtenerProgresoGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indiceGuardado = prefs.getInt('indice_guardado');
      final cantidadGuardada = prefs.getInt('cantidad_guardada');
      
      if (indiceGuardado != null && cantidadGuardada != null) {
        return {
          'indice': indiceGuardado,
          'cantidad': cantidadGuardada,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


      // Borra solo los datos de login si es necesario
      // ...existing code...

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


  // Verificar si hay progreso guardado en Firebase
  Future<bool> tieneProgresoGuardado() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['progreso'] != null && data['progreso']['indice'] != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  // Obtener información del progreso guardado desde Firebase
  Future<Map<String, int>?> obtenerProgresoGuardado() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['progreso'] != null) {
          final progreso = data['progreso'];
          return {
            'indice': progreso['indice'] ?? 0,
            'cantidad': progreso['cantidad'] ?? 10,
          };
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 
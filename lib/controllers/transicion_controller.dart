import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flashcards_controller.dart';

class TransicionController extends ChangeNotifier {
  bool _isLoading = false;
  bool _tieneProgreso = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get tieneProgreso => _tieneProgreso;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Detecta si el usuario tiene progreso guardado en Firestore
  Future<void> detectarProgresoGuardado() async {
    setLoading(true);
    clearError();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _tieneProgreso = false;
        setLoading(false);
        return;
      }

      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['progreso'] != null && data['progreso']['indice'] != null) {
          _tieneProgreso = true;
        } else {
          _tieneProgreso = false;
        }
      } else {
        _tieneProgreso = false;
      }
    } catch (e) {
      _errorMessage = 'Error al detectar progreso: $e';
      _tieneProgreso = false;
    } finally {
      setLoading(false);
    }
  }

  /// Crea y retorna un controlador de flashcards con el progreso cargado
  Future<FlashcardsController?> crearControladorConProgreso() async {
    try {
      final flashcardsController = FlashcardsController();
      await flashcardsController.cargarProgresoDesdeFirestore();
      return flashcardsController;
    } catch (e) {
      _errorMessage = 'Error al cargar progreso: $e';
      notifyListeners();
      return null;
    }
  }
} 
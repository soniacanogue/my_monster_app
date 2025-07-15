import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CargandoController extends ChangeNotifier {
  bool _isLoading = true;
  int _tiempoRestante = 3; // segundos
  String _mensaje = 'Hi, I\'m a monster too... grrwmm!';

  // Getters
  bool get isLoading => _isLoading;
  int get tiempoRestante => _tiempoRestante;
  String get mensaje => _mensaje;

  void iniciarCarga() {
    _isLoading = true;
    _tiempoRestante = 3;
    notifyListeners();

    // Simular cuenta regresiva
    _contarRegresivamente();
  }

  void _contarRegresivamente() {
    if (_tiempoRestante > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        _tiempoRestante--;
        notifyListeners();
        _contarRegresivamente();
      });
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  void finalizarCarga() {
    _isLoading = false;
    notifyListeners();
  }

  void cambiarMensaje(String nuevoMensaje) {
    _mensaje = nuevoMensaje;
    notifyListeners();
  }

  // Simular diferentes tipos de carga
  void simularCargaRapida() {
    _tiempoRestante = 1;
    _mensaje = 'Loading quickly...';
    notifyListeners();
  }

  void simularCargaLenta() {
    _tiempoRestante = 5;
    _mensaje = 'Loading slowly...';
    notifyListeners();
  }

  // Verificar si la carga ha terminado
  bool get cargaCompletada => !_isLoading && _tiempoRestante == 0;

  // Nuevo: Detectar si el usuario tiene progreso guardado en Firestore
  Future<bool> tieneProgresoGuardadoFirestore() async {
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
  }
} 
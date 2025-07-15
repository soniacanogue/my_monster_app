import 'package:firebase_auth/firebase_auth.dart'; // ✅ Firebase Auth
import 'package:flutter/material.dart';
import 'flashcards_controller.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _validateFields() {
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _errorMessage = 'Por favor completa todos los campos';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = 'Por favor ingresa un email válido';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<bool> login({FlashcardsController? flashcardsController}) async {
    if (!_validateFields()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final email = emailController.text.trim();
    final pass = passController.text.trim();

    try {
      // ✅ Autenticación con Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Limpiar progreso local del usuario anterior
      await FlashcardsController.limpiarProgresoLocal();

      // Cargar progreso desde Firestore si se pasa el controlador
      if (flashcardsController != null) {
        await flashcardsController.cargarProgresoDesdeFirestore();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // ✅ Errores comunes de Firebase
      if (e.code == 'user-not-found') {
        _errorMessage = 'Usuario no encontrado. Verifica el correo.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Contraseña incorrecta.';
      } else {
        _errorMessage = 'Error: ${e.message}';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearFields() {
    emailController.clear();
    passController.clear();
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}

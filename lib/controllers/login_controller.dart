import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Validación básica de email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = 'Por favor ingresa un email válido';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<bool> login() async {
    if (!_validateFields()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('user_email');
      final savedPass = prefs.getString('user_pass');

      final email = emailController.text.trim();
      final pass = passController.text.trim();

      // Verificar si el usuario existe
      if (savedEmail == null || savedPass == null) {
        _errorMessage = 'No hay usuarios registrados. Por favor regístrate primero.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Verificar credenciales
      if (email == savedEmail && pass == savedPass) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Correo o contraseña incorrectos';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al iniciar sesión: $e';
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
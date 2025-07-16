import 'package:firebase_auth/firebase_auth.dart'; // ✅ Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore
import 'package:flutter/material.dart';
import 'flashcards_controller.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
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
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      _errorMessage = 'Por favor completa todos los campos';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = 'Por favor ingresa un email válido';
      notifyListeners();
      return false;
    }

    if (pass.length < 6) {
      _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<bool> register({FlashcardsController? flashcardsController}) async {
    if (!_validateFields()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    try {
      // ✅ Crear usuario en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      // ✅ Obtener UID del nuevo usuario
      final uid = userCredential.user!.uid;

      // ✅ Crear documento del usuario en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nombre': name,
        'email': email,
        'progreso': {}, // espacio reservado para guardar avance
        'creado': FieldValue.serverTimestamp(),
      });


      // Cargar progreso desde Firestore si se pasa el controlador
      if (flashcardsController != null) {
        await flashcardsController.cargarProgresoDesdeFirestore();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'Este correo ya está registrado';
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
    nameController.clear();
    emailController.clear();
    passController.clear();
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}

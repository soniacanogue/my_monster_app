
import 'package:flutter/material.dart';

import '../controllers/register_controller.dart';
import '../controllers/flashcards_controller.dart';
import '../views/flashcards_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final flashcardsController = FlashcardsController();
    final success = await _controller.register(flashcardsController: flashcardsController);

    if (success && mounted) {
      _controller.clearFields(); // ✅ Limpiar campos solo si el registro fue exitoso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('¡Registro exitoso!'),
          content: const Text('Tu cuenta ha sido creada correctamente. Ahora puedes iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pushReplacementNamed(context, '/'); // Ir a login
              },
              child: const Text('Ir a login'),
            ),
          ],
        ),
      );
    } else if (mounted && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_controller.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Crear Cuenta",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF7232),
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildClayInput(
                      controller: _controller.nameController,
                      label: 'Nombre',
                    ),
                    const SizedBox(height: 20),

                    _buildClayInput(
                      controller: _controller.emailController,
                      label: 'Correo electrónico',
                    ),
                    const SizedBox(height: 20),

                    _buildClayInput(
                      controller: _controller.passController,
                      label: 'Contraseña',
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: _controller.isLoading ? null : _handleRegister,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: _controller.isLoading
                              ? Colors.grey
                              : const Color(0xFFFF7232),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-8, -8),
                              blurRadius: 16,
                            ),
                            BoxShadow(
                              color: Color(0xFFB06C52),
                              offset: Offset(8, 8),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: _controller.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Registrarme',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: '¿Ya tienes cuenta? ',
                          style: TextStyle(
                            color: Color(0xFF0A15E0),
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Inicia sesión',
                              style: TextStyle(
                                color: Color(0xFF0A15E0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClayInput({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFDADADA),
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _controller.obscurePassword : false,
        style: const TextStyle(color: Color(0xFFFF7232)),
        cursorColor: const Color(0xFFFF7232),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFFF7232)),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _controller.obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFFFF7232),
                  ),
                  onPressed: _controller.togglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}

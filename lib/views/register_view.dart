import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_pass', pass);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Registro exitoso!')),
    );

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco total
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
                    color: Color(0xFFFF7232), // Naranja
                  ),
                ),
                const SizedBox(height: 40),

                _buildClayInput(
                  controller: _nameController,
                  label: 'Nombre',
                ),
                const SizedBox(height: 20),

                _buildClayInput(
                  controller: _emailController,
                  label: 'Correo electrónico',
                ),
                const SizedBox(height: 20),

                _buildClayInput(
                  controller: _passController,
                  label: 'Contraseña',
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: _register,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7232),
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
                    child: const Text(
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
                        color: Color(0xFF0A15E0), // Azul
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
            color: Color(0xFFDADADA), // sombra gris muy clara
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        style: const TextStyle(color: Color(0xFFFF7232)),
        cursorColor: const Color(0xFFFF7232),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFFF7232)),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFFFF7232),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraciasFinView extends StatelessWidget {
  const GraciasFinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 36.0,
              vertical: 40.0,
            ), // mas   espacio a los lados
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B18F0),
                  Color(0xFF0A15E0),
                  Color(0xFF080FC8),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  offset: Offset(12, 12),
                  blurRadius: 24,
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  offset: Offset(-10, -10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, size: 100, color: Colors.white),
                const SizedBox(height: 30),
                const Text(
                  '¡Gracias por estudiar hoy!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tu progreso fue guardado correctamente.\n\n'
                  '¡Nos vemos en la próxima sesión, monstru@! 👾',
                  style: TextStyle(
                    color: Color(0xFFFF7232),
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // negrita
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    // Borra solo los datos de login
                    await prefs.remove('user_email');
                    await prefs.remove('user_pass');

                    // Redirige al login
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },

                  icon: const Icon(Icons.logout, size: 28),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7232),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    // Elimina solo los datos de login
                    await prefs.remove('user_email');
                    await prefs.remove('user_pass');

                    // Mantiene el progreso (no borra indice_guardado ni cantidad_guardada)
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/',
                      ); // Va al login
                    }
                  },

                  child: const Text(
                    'Volver al selector de mazo',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
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
}

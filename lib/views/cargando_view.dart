import 'package:flutter/material.dart';

class CargandoView extends StatefulWidget {
  // ignore: use_super_parameters
  const CargandoView({Key? key}) : super(key: key);

  @override
  State<CargandoView> createState() => _CargandoViewState();
}

class _CargandoViewState extends State<CargandoView> {
  @override
  void initState() {
    super.initState();

    // Simulamos carga de 1 min antes de ir a las flashcards
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/flashcards'); // 👈 próxima pantalla
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Puedes reemplazar esto por una imagen/gif si tienes uno
            const Icon(Icons.bug_report, size: 100, color: Color(0xFF0A15E0)),
            const SizedBox(height: 20),
            const Text(
              'Cargando tu monstruo...',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFF7232),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Color(0xFFFF7232)),
          ],
        ),
      ),
    );
  }
}

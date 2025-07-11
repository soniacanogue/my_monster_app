import 'package:flutter/material.dart';

class CargandoView extends StatefulWidget {
  const CargandoView({Key? key}) : super(key: key);

  @override
  State<CargandoView> createState() => _CargandoViewState();
}

class _CargandoViewState extends State<CargandoView> {
  @override
  void initState() {
    super.initState();

    // Simulamos una carga de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/selector');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco puro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor claymorphic para el ícono
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-8, -8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: Color(0xFFDADADA), // Sombra suave
                    offset: Offset(8, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bug_report,
                size: 100,
                color: Color(0xFF0A15E0), // Azul
              ),
            ),

            const SizedBox(height: 30),

            // Texto monstruo
            const Text(
              'Hi, I\'m a monster too... grrwmm!',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFF7232), // Naranja
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Circular progress claymorphic (dentro de un contenedor con sombra)
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
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
              child: const CircularProgressIndicator(
                strokeWidth: 4,
                color: Color(0xFFFF7232), // Naranja
              ),
            ),
          ],
        ),
      ),
    );
  }
}

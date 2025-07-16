import 'package:flutter/material.dart';
import '../controllers/cargando_controller.dart';

class CargandoView extends StatefulWidget {
  const CargandoView({Key? key}) : super(key: key);

  @override
  State<CargandoView> createState() => _CargandoViewState();
}

class _CargandoViewState extends State<CargandoView> {
  late CargandoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CargandoController();
    _controller.iniciarCarga();

    // Al terminar la carga, navegar a la vista de transición
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/transicion');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Texto tierno encima de la imagen
                const Text(
                  '¡Soy un monstruo grrw!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF0A15E0),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Imagen del monstruo
                Image.asset(
                  'assets/my_monster.png',
                  width: 360,
                  height: 360,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                // Mostrar tiempo restante si es mayor a 0
                if (_controller.tiempoRestante > 0) ...[
                  const SizedBox(height: 20),
                  Text(
                    '${_controller.tiempoRestante}s',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0A15E0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

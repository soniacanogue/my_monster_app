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
                        color: Color(0xFFDADADA),
                        offset: Offset(8, 8),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    size: 100,
                    color: Color(0xFF0A15E0),
                  ),
                ),

                const SizedBox(height: 30),

                // Texto monstruo
                Text(
                  _controller.mensaje,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFF7232),
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
                    color: Color(0xFFFF7232),
                  ),
                ),

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

import 'package:flutter/material.dart';
import '../controllers/gracias_fin_controller.dart';
import '../controllers/flashcards_controller.dart';
import '../views/flashcards_view.dart';

class GraciasFinView extends StatefulWidget {
  const GraciasFinView({Key? key}) : super(key: key);

  @override
  State<GraciasFinView> createState() => _GraciasFinViewState();
}

class _GraciasFinViewState extends State<GraciasFinView> {
  late GraciasFinController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GraciasFinController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleCerrarSesion() async {
    final success = await _controller.cerrarSesion();
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/');
    } else if (mounted && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.errorMessage!)),
      );
    }
  }

  Future<void> _handleVolverAlSelector() async {
    final success = await _controller.volverAlSelector();
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/selector');
    } else if (mounted && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36.0,
                  vertical: 40.0,
                ),
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
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Botón de volver a flashcards
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                      tooltip: 'Volver a flashcards',
                      onPressed: () async {
                        final flashcardsController = FlashcardsController();
                        await flashcardsController.cargarProgresoDesdeFirestore();
                        flashcardsController.inicializar(flashcardsController.cantidad);
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardsView(controller: flashcardsController),
                            ),
                          );
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: _controller.isLoading ? null : _handleCerrarSesion,
                      icon: _controller.isLoading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.logout, size: 28),
                      label: Text(
                        _controller.isLoading ? 'Cerrando...' : 'Cerrar sesión',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controller.isLoading 
                            ? Colors.grey 
                            : const Color(0xFFFF7232),
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
                      onPressed: _controller.isLoading ? null : _handleVolverAlSelector,
                      child: Text(
                        _controller.isLoading ? 'Procesando...' : 'Volver al selector de mazo',
                        style: const TextStyle(
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
      },
    );
  }
}

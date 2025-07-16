import 'package:flutter/material.dart';
import '../controllers/transicion_controller.dart';
import '../controllers/flashcards_controller.dart';
import '../views/flashcards_view.dart';

class TransicionView extends StatefulWidget {
  const TransicionView({Key? key}) : super(key: key);

  @override
  State<TransicionView> createState() => _TransicionViewState();
}

class _TransicionViewState extends State<TransicionView> {
  late TransicionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransicionController();
    _inicializar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _inicializar() async {
    await _controller.detectarProgresoGuardado();
  }

  Future<void> _continuarDondeQuedaste() async {
    _controller.setLoading(true);
    
    try {
      final flashcardsController = await _controller.crearControladorConProgreso();
      if (flashcardsController != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardsView(controller: flashcardsController),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.errorMessage ?? 'Error al cargar progreso')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      _controller.setLoading(false);
    }
  }

  void _comenzarDeNuevo() {
    Navigator.pushReplacementNamed(context, '/instrucciones');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Mostrar indicador de carga mientras se detecta el progreso
        if (_controller.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text('Cargando...', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        }
        // Cuando ya se detectó el progreso, mostrar la UI principal
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                    const Icon(Icons.school, size: 100, color: Colors.white),
                    const SizedBox(height: 30),
                    Text(
                      _controller.tieneProgreso 
                          ? '¡Bienvenido de vuelta!'
                          : '¡Bienvenido a My Monster App!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _controller.tieneProgreso
                          ? 'Tienes una sesión pendiente. ¿Qué quieres hacer?'
                          : '¿Listo para empezar a estudiar?',
                      style: const TextStyle(
                        color: Color(0xFFFF7232),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    if (_controller.tieneProgreso) ...[
                      // Botón para continuar donde quedaste
                      ElevatedButton.icon(
                        onPressed: _controller.isLoading ? null : _continuarDondeQuedaste,
                        icon: _controller.isLoading 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow, size: 28),
                        label: Text(
                          _controller.isLoading ? 'Cargando...' : 'Continuar donde quedaste',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    ],
                    
                    // Botón para comenzar de nuevo
                    ElevatedButton(
                      onPressed: _controller.isLoading ? null : _comenzarDeNuevo,
                      child: Text(
                        _controller.tieneProgreso ? 'Comenzar de nuevo' : 'Empezar',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A15E0),
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
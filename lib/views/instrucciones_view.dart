import 'package:flutter/material.dart';
import '../controllers/instrucciones_controller.dart';

class InstruccionesView extends StatefulWidget {
  const InstruccionesView({Key? key}) : super(key: key);

  @override
  State<InstruccionesView> createState() => _InstruccionesViewState();
}

class _InstruccionesViewState extends State<InstruccionesView> with TickerProviderStateMixin {
  late InstruccionesController _controller;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = InstruccionesController();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _siguientePaso() {
    if (_controller.esUltimoPaso) {
      _irAlSelector();
    } else {
      _controller.siguientePaso();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pasoAnterior() {
    if (!_controller.esPrimerPaso) {
      _controller.pasoAnterior();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _irAlSelector() {
    _controller.irAlSelector();
    Navigator.pushReplacementNamed(context, '/selector');
  }

  void _saltarInstrucciones() {
    _controller.saltarInstrucciones();
    Navigator.pushReplacementNamed(context, '/selector');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header con botón de saltar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicadores de progreso
                      Row(
                        children: List.generate(
                          _controller.pasos.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _controller.pasoActual
                                  ? const Color(0xFFFF7232)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      // Botón saltar
                      TextButton(
                        onPressed: _saltarInstrucciones,
                        child: const Text(
                          'Saltar',
                          style: TextStyle(
                            color: Color(0xFF0A15E0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contenido principal
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _controller.actualizarPasoActual(index);
                    },
                    itemCount: _controller.pasos.length,
                    itemBuilder: (context, index) {
                      final paso = _controller.pasos[index];
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icono con efecto clay
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
                                child: Icon(
                                  paso['icono'],
                                  size: 80,
                                  color: paso['color'],
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Título
                              Text(
                                paso['titulo'],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A15E0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Descripción
                              Text(
                                paso['descripcion'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Botones de navegación
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón anterior
                      if (!_controller.esPrimerPaso)
                        TextButton(
                          onPressed: _pasoAnterior,
                          child: const Text(
                            'Anterior',
                            style: TextStyle(
                              color: Color(0xFF0A15E0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 80),
                      
                      // Botón siguiente/comenzar
                      ElevatedButton(
                        onPressed: _controller.isLoading ? null : _siguientePaso,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7232),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.3),
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
                            : Text(
                                _controller.esUltimoPaso ? '¡Comenzar!' : 'Siguiente',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 
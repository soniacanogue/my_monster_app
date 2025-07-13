import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/cargando_view.dart';
import 'views/flashcards_view.dart';
import 'views/register_view.dart'; // ✅ Ruta nueva para registro
import 'views/selector_view.dart'; // Importa la vista del selector
import 'views/gracias_fin_view.dart'; // Importa la vista de agradecimiento al finalizar
import 'views/instrucciones_view.dart'; // Importa la vista de instrucciones


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Monster App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF0A15E0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A15E0),
          primary: const Color(0xFF0A15E0),
          secondary: const Color(0xFFFF7232),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF0A15E0),
            fontSize: 18,
          ),
          titleLarge: TextStyle(
            color: Color(0xFFFF7232),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/register': (context) => const RegisterView(), // ✅ Ruta nueva
        '/cargando': (context) => const CargandoView(),
        '/selector': (context) => const SelectorView(), // Ruta para el selector
        '/flashcards': (context) => const FlashcardsView(),
        '/gracias': (context) => const GraciasFinView(),  // Ruta para la vista de agradecimiento al finalizar
        '/instrucciones': (context) => const InstruccionesView(), // Ruta para la vista de instrucciones
      },
    );
  }
}

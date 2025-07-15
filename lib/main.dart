import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'firebase/firebase_options.dart';


// Importa Vistas
import 'views/login_view.dart';
import 'views/cargando_view.dart';
import 'views/flashcards_view.dart';
import 'views/register_view.dart'; // ✅ Ruta nueva para registro
import 'views/selector_view.dart'; // Importa la vista del selector
import 'views/gracias_fin_view.dart'; // Importa la vista de agradecimiento al finalizar
import 'views/instrucciones_view.dart'; // Importa la vista de instrucciones
import 'views/transicion_view.dart'; // Importa la vista de transición


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Necesario antes de inicializar Firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializa Firebase con las opciones por defecto
  );// Esto es clave para webcorige error 
  runApp(const MyApp());  // Corre la app
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
        '/transicion': (context) => const TransicionView(), // Ruta para la vista de transición
        '/selector': (context) => const SelectorView(), // Ruta para el selector
        '/gracias': (context) => const GraciasFinView(),  // Ruta para la vista de agradecimiento al finalizar
        '/instrucciones': (context) => const InstruccionesView(), // Ruta para la vista de instrucciones
      },
    );
  }
}

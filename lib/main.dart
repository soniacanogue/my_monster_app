import 'package:flutter/material.dart';
import 'views/login_view.dart';
// ignore: unused_import
import 'views/cargando_view.dart'; // 👈 nuevo import
import 'views/flashcards_view.dart';

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
      theme: ThemeData(primaryColor: const Color(0xFF0A15E0)),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/cargando': (context) => const CargandoView(), // ✅ aquí el cambio
        '/flashcards': (context) => const FlashcardsView(),
      },
    );
  }
}

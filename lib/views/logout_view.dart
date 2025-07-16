import 'package:flutter/material.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      Navigator.pushReplacementNamed(context, '/'); // Ir a la ruta de login
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen personalizada de despedida
            Image.asset(
              'assets/despedida_luz_edificio_bye_ventana.png',
              width: 320,
              height: 480,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            const Text(
              '¡Hasta pronto!',
              style: TextStyle(
                color: Color(0xFFFF7232),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

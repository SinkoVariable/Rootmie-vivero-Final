import 'package:flutter/material.dart';
import 'package:frontend/ui/login/login_screen.dart'; // <-- Importación absoluta usando el nombre de tu proyecto

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // <-- Ahora sí lo reconocerá como la clase de tu pantalla
    );
  }
}
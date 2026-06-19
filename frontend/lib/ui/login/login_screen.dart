import 'package:flutter/material.dart';
import 'package:frontend/ui/login/login_viewmodel.dart';
import 'package:frontend/ui/catalog/catalog_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_florist_rounded, size: 100, color: Colors.green[700]),
                  const SizedBox(height: 16),
                  Text('Rootmie', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.green[900], letterSpacing: 1.2)),
                  const Text('Tu vivero digital', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 40),
                  TextField(
                    onChanged: _viewModel.setEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.green[700]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: _viewModel.setPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.green[700]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 35),
                  _viewModel.isLoading
                      ? CircularProgressIndicator(color: Colors.green[700])
                      : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        String rol = await _viewModel.loginUsuario();
                        if (mounted) {
                          // Siempre viaja al Catálogo, pero enviando el "rol" obtenido
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CatalogScreen(userRole: rol),
                            ),
                          );
                        }
                      },
                      child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
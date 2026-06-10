import 'package:flutter/material.dart';
import 'package:frontend/ui/login/login_viewmodel.dart'; // <-- Importación absoluta para evitar fallos

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instanciamos el ViewModel correctamente
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListenableBuilder( // Usamos el Builder nativo de Flutter para escuchar los cambios
          listenable: _viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono botánico de Rootmie
                  Icon(
                    Icons.local_florist_rounded,
                    size: 100,
                    color: Colors.green[700],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rootmie',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Tu vivero digital',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // Campo de texto: Correo
                  TextField(
                    onChanged: _viewModel.setEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.green[700]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de texto: Contraseña
                  TextField(
                    onChanged: _viewModel.setPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.green[700]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Botón de Ingreso con cambio de estado dinámico
                  _viewModel.isLoading
                      ? CircularProgressIndicator(color: Colors.green[700])
                      : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        String? resultado = await _viewModel.loginUsuario();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green[900],
                              content: Text('¡Éxito! Entrando como: $resultado'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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
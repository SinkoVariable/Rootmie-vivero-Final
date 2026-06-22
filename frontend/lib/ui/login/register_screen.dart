import 'package:flutter/material.dart';
import 'login_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginViewModel _viewModel = LoginViewModel();
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: Colors.green[800])),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_florist_rounded, size: 80, color: Colors.green[700]),
              const SizedBox(height: 16),
              Text('Crear Cuenta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[900])),
              const Text('Únete a la comunidad Rootmie', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 35),

              // Campo Nombre
              TextField(
                onChanged: (val) => _name = val,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.green[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Correo
              TextField(
                onChanged: (val) => _email = val,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.green[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Contraseña
              TextField(
                onChanged: (val) => _password = val,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.green[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 35),

              _isLoading
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
                    if (_email.isEmpty || _password.isEmpty || _name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor llena todos los campos'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    setState(() => _isLoading = true);

                    // Registra en Firebase Auth + Firestore de forma real
                    bool success = await _viewModel.registrarUsuarioReal(_email, _password, _name);

                    setState(() => _isLoading = false);

                    if (mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Cuenta creada! Ya puedes iniciar sesión 🌿'), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context); // Regresa al Login
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al registrar. Intenta con otro correo.'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: const Text('Registrarse', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
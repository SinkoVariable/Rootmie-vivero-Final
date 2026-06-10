import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
  }

  void setPassword(String value) {
    _password = value;
  }

  // Simulación de respuesta del servidor (Mock Data)
  Future<String?> loginUsuario() async {
    if (_email.isEmpty || _password.isEmpty) return 'Por favor llena todos los campos';

    _isLoading = true;
    notifyListeners(); // Muestra el círculo de carga

    // Simulamos una espera de red de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners(); // Quita el círculo de carga

    // Evaluamos roles ficticios para probar el Frontend
    if (_email.contains('admin')) {
      return 'ADMINISTRADOR';
    } else {
      return 'CLIENTE';
    }
  }
}
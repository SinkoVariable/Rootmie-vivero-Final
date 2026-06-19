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

  Future<String> loginUsuario() async {
    _isLoading = true;
    notifyListeners();

    // Simular retraso de red
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();

    // Filtro simulado para desarrollo del Frontend
    if (_email.contains('admin')) {
      return 'ADMIN';
    } else if (_email.contains('auxiliar')) {
      return 'AUXILIAR';
    } else {
      return 'CLIENTE';
    }
  }
}
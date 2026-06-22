import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  // 🔐 LOGIN REAL CON FIREBASE AUTH & FIRESTORE ROLES
  Future<String> loginUsuarioReal() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Autenticar con Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );

      // 2. Buscar el rol del usuario en la colección 'usuarios' de Cloud Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      _isLoading = false;
      notifyListeners();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['rol'] ?? 'CLIENTE'; // Retorna: ADMIN, AUXILIAR o CLIENTE
      }

      return 'CLIENTE'; // Rol por defecto si no se encuentra en Firestore
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'ERROR';
    }
  }

  //  REGISTRO REAL
  Future<bool> registrarUsuarioReal(String email, String password, String name) async {
    try {
      // 1. Crear usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. Guardar su perfil y rol de CLIENTE en Cloud Firestore de forma síncrona
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'nombre': name.trim(),
        'correo': email.trim(),
        'rol': 'CLIENTE', // Todos los registros de la app nacen como Clientes
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
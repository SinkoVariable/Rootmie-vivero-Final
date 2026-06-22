import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 Necesario para consultar el rol
import 'firebase_options.dart';
import 'ui/login/login_screen.dart';
import 'ui/catalog/catalog_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rootmie Vivero',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {

          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          }


          if (authSnapshot.hasData && authSnapshot.data != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(authSnapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator(color: Colors.green)),
                  );
                }


                String rolReal = 'CLIENTE';
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final data = userSnapshot.data!.data() as Map<String, dynamic>;
                  rolReal = data['rol'] ?? 'CLIENTE';
                }


                return CatalogScreen(userRole: rolReal);
              },
            );
          }


          return const LoginScreen();
        },
      ),
    );
  }
}
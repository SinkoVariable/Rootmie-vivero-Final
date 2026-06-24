import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_orders_screen.dart';
import '../profile/help_screen.dart';
import '../profile/botanic_consult_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? usuarioActual = FirebaseAuth.instance.currentUser;
    final String correoUsuario = usuarioActual?.email ?? 'sin_correo@rootmie.com';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Mi Perfil Rootmie',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: usuarioActual == null
          ? const Center(child: Text('No hay ninguna sesión activa.'))
          : FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(usuarioActual.uid).get(),
        builder: (context, snapshot) {

          String nombreUsuario = usuarioActual.displayName ?? 'Cliente Rootmie 🌿';


          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            nombreUsuario = data['nombre'] ?? data['name'] ?? data['nombreCompleto'] ?? nombreUsuario;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.only(bottom: 35, top: 10),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.green[50],
                            child: Icon(Icons.person_outline, size: 55, color: Colors.green[800]),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                            child: const Icon(Icons.eco, size: 16, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        nombreUsuario,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        correoUsuario,
                        style: TextStyle(color: Colors.green[100], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis Compras y Logística',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 1,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                            child: const Icon(Icons.receipt_long_outlined, color: Colors.green),
                          ),
                          title: const Text('Mis Pedidos', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Consulta tus órdenes activas e historial de compras'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CustomerOrdersScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 1,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                            child: const Icon(Icons.psychology_alt_outlined, color: Colors.green),
                          ),
                          title: const Text('Asesoría Botánica', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Programa una cita virtual para el cuidado de tus plantas'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BotanicConsultScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Soporte',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 1,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.amber[50], shape: BoxShape.circle),
                            child: Icon(Icons.help_outline, color: Colors.amber[800]),
                          ),
                          title: const Text('Centro de Ayuda', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('¿Problemas con tu despacho? Escríbenos'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
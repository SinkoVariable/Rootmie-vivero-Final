import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_product_screen.dart';
import 'select_product_screen.dart';
import 'alerts_config_screen.dart';
import 'admin_orders_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text(
          'Acciones del Sistema',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
        ),
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          tooltip: 'Volver al Catálogo',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('¿Cerrar Sesión?'),
                    content: const Text('Tendrás que volver a ingresar tus credenciales para acceder al panel.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Salir', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // 1️ Agregar Nuevo Producto
            _buildMenuCard(
              context: context,
              title: 'Agregar Nuevo Producto ',
              subtitle: 'Sube nuevas plantas al catálogo comercial.',
              icon: Icons.add_photo_alternate_outlined,
              iconColor: Colors.green[700]!,
              iconBgColor: Colors.green[50]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2️ Modificar o Inhabilitar
            _buildMenuCard(
              context: context,
              title: 'Modificar o Inhabilitar ',
              subtitle: 'Cambia precios, descripciones o estados.',
              icon: Icons.edit_note_rounded,
              iconColor: Colors.orange[700]!,
              iconBgColor: Colors.orange[50]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectProductScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 📦 Gestión de Pedidos
            _buildMenuCard(
              context: context,
              title: 'Gestión de Pedidos ',
              subtitle: 'Valida pagos de clientes y actualiza stock atómicamente.',
              icon: Icons.receipt_long_rounded,
              iconColor: Colors.blue[700]!,
              iconBgColor: Colors.blue[50]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminOrdersScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 3️ Configurar Umbrales de Alertas
            _buildMenuCard(
              context: context,
              title: 'Configurar Umbrales de Alertas ',
              subtitle: 'Define el stock mínimo permitido.',
              icon: Icons.notifications_none_rounded,
              iconColor: Colors.red[700]!,
              iconBgColor: Colors.red[50]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlertsConfigScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 4️ Validar Reembolsos / Cancelaciones
            _buildMenuCard(
              context: context,
              title: 'Validar Reembolsos/\nCancelaciones ',
              subtitle: 'Aprobar o rechazar solicitudes de clientes.',
              icon: Icons.assignment_turned_in_outlined,
              iconColor: Colors.purple[700]!,
              iconBgColor: Colors.purple[50]!,
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: iconBgColor,
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}
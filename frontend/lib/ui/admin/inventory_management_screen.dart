import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'select_product_screen.dart';
import 'alerts_config_screen.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text(
          'Gestión de Inventario',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
        ),
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Opción: Agregar
            _buildSubMenuCard(
              context: context,
              title: 'Agregar Nuevo Producto',
              subtitle: 'Sube nuevas plantas e insumos al catálogo comercial.',
              icon: Icons.add_photo_alternate_outlined,
              iconColor: Colors.green[700]!,
              iconBgColor: Colors.green[50]!,
              destination: const AddProductScreen(),
            ),
            const SizedBox(height: 12),

            // Opción: Modificar / Inhabilitar
            _buildSubMenuCard(
              context: context,
              title: 'Modificar o Inhabilitar',
              subtitle: 'Cambia precios, descripciones, stocks o estados.',
              icon: Icons.edit_note_rounded,
              iconColor: Colors.orange[700]!,
              iconBgColor: Colors.orange[50]!,
              destination: const SelectProductScreen(),
            ),
            const SizedBox(height: 12),

            // Opción: Configurar Alertas
            _buildSubMenuCard(
              context: context,
              title: 'Configurar Umbrales de Alertas',
              subtitle: 'Define el stock mínimo permitido para evitar quiebres.',
              icon: Icons.notifications_none_rounded,
              iconColor: Colors.red[700]!,
              iconBgColor: Colors.red[50]!,
              destination: const AlertsConfigScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Widget destination,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
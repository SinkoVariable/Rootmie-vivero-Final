import 'package:flutter/material.dart';
import 'add_product_screen.dart'; // <-- Importar pantalla de agregar
import 'select_product_screen.dart'; // <-- CAMBIADO: Ahora importamos la pantalla de selección visual

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Panel Administrator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido, Admin! 🛠️',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            const Text('Control global de Rootmie', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            Row(
              children: [
                _buildStatCard('Productos', '142', Colors.blue, Icons.inventory_2),
                const SizedBox(width: 15),
                _buildStatCard('Alertas Stock', '5', Colors.orange, Icons.warning_amber_rounded),
              ],
            ),
            const SizedBox(height: 25),

            const Text('Acciones del Sistema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // 1. Botón: Agregar nuevo producto o insumo
            _buildActionButton(
              Icons.add_photo_alternate_outlined,
              'Agregar Nuevo Producto',
              'Sube nuevas plantas o insumos al catálogo comercial.',
              Colors.green,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen())),
            ),

            // 2. Botón: Modificar o Inhabilitar (INTEGRADO CON LA SELECCIÓN VISUAL)
            _buildActionButton(
              Icons.edit_note_rounded,
              'Modificar o Inhabilitar',
              'Selecciona visualmente un item para cambiar sus datos o estado.',
              Colors.amber[700]!,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectProductScreen())),
            ),

            // 3. Botón: Configuración de umbrales
            _buildActionButton(
              Icons.notifications_active_outlined,
              'Configurar Umbrales de Alertas',
              'Define el stock mínimo permitido.',
              Colors.red,
                  () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Módulo Alertas: Próximamente'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
            const SizedBox(height: 15),
            Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap, // Ejecuta la navegación dinámica
      ),
    );
  }
}
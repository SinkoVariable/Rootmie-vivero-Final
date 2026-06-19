import 'package:flutter/material.dart';

class BotanicScreen extends StatelessWidget {
  const BotanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Auxiliar Botánico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco_rounded, size: 35, color: Colors.teal[700]),
                const SizedBox(width: 10),
                const Text(
                  'Operaciones de Vivero',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text('Consulta y registro físico de plantas en stock (RF001-3)', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            // Barra de búsqueda bonita
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar planta por nombre o ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Lista de simulación de stock manual
            Expanded(
              child: ListView(
                children: [
                  _buildInventoryItem('Monstera Deliciosa', 'Stock actual: 14 unidades', Colors.green),
                  _buildInventoryItem('Helecho Boston', 'Stock actual: 3 unidades', Colors.orange), // Alerta visual
                  _buildInventoryItem('Suculenta Cebra', 'Stock actual: 45 unidades', Colors.green),
                  _buildInventoryItem('Árbol de Jade', 'Stock actual: 0 unidades', Colors.red), // Agotado visual
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String name, String stock, Color badgeColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(width: 6, height: 40, decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(stock, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[50], elevation: 0),
              icon: Icon(Icons.edit, size: 14, color: Colors.teal[700]),
              label: Text('+ Consolidar', style: TextStyle(color: Colors.teal[700], fontSize: 12)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
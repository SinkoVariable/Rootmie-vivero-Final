import 'package:flutter/material.dart';
import 'edit_product_screen.dart';

// Definimos un modelo de datos simple para representar el inventario actual
class InventoryItem {
  final String name;
  final double price;
  final int stock;
  final String category;
  final String description;
  final IconData icon;

  InventoryItem({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.icon,
  });
}

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulada de los productos actuales en la base de datos de Rootmie
    final List<InventoryItem> currentInventory = [
      InventoryItem(
        name: 'Monstera Deliciosa',
        price: 25000,
        stock: 14,
        category: 'Planta de interior',
        description: 'Planta de sombra ideal para interiores, requiere riego moderado una vez a la semana.',
        icon: Icons.eco_outlined,
      ),
      InventoryItem(
        name: 'Fertilizante Orgánico Humus 5Kg',
        price: 16000,
        stock: 35,
        category: 'Fertilizante',
        description: 'Nutrición 100% natural para el crecimiento radicular y fortalecimiento de hojas.',
        icon: Icons.science_outlined,
      ),
      InventoryItem(
        name: 'Cactus de Pascua',
        price: 9000,
        stock: 8,
        category: 'Cactus',
        description: 'Pequeño cactus ornamental con flores coloridas de fácil cuidado bajo el sol.',
        icon: Icons.wb_sunny_outlined, // <-- CORREGIDO: Usamos un ícono directo y válido
      ),
      InventoryItem(
        name: 'Tijeras de Poda Professional',
        price: 42000,
        stock: 5,
        category: 'Herramientas',
        description: 'Hojas de acero inoxidable de alta precisión para ramas de hasta 2cm.',
        icon: Icons.handyman_outlined,
      ),
      InventoryItem(
        name: 'Maceta de Arcilla Clásica',
        price: 12000,
        stock: 22,
        category: 'Macetas',
        description: 'Maceta de barro cocido con excelente filtración de agua para proteger raíces.',
        icon: Icons.layers_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Seleccionar Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué ítem deseas editar? ✏️',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                SizedBox(height: 6),
                Text('Toca cualquier producto de la lista para modificar sus datos o inhabilitarlo.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: currentInventory.length,
              itemBuilder: (context, index) {
                final item = currentInventory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[50],
                      child: Icon(item.icon, color: Colors.green[800]),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Stock: ${item.stock} uds',
                            style: TextStyle(
                              fontSize: 13,
                              color: item.stock <= 5 ? Colors.red[700] : Colors.grey[600],
                              fontWeight: item.stock <= 5 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                      ],
                    ),
                    onTap: () {
                      // 🚀 ¡AQUÍ OCURRE LA MAGIA! Al tocarlo, viajamos al formulario pasándole las propiedades reales
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProductScreen(
                            initialName: item.name,
                            initialPrice: item.price,
                            initialStock: item.stock,
                            initialCategory: item.category,
                            initialDescription: item.description,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
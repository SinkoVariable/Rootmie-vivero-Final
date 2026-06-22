import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../inventory/inventory_viewmodel.dart';

class ManageStatusScreen extends StatefulWidget {
  const ManageStatusScreen({super.key});

  @override
  State<ManageStatusScreen> createState() => _ManageStatusScreenState();
}

class _ManageStatusScreenState extends State<ManageStatusScreen> {
  final InventoryViewModel _inventoryVM = InventoryViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Baja Lógica de Catálogo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos en el inventario 🌿'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final String id = doc.id;
              final String nombre = data['nombre'] ?? 'Sin nombre';
              final String sku = data['sku'] ?? 'S/K';
              final bool activo = data['activo'] ?? true;
              final String url = data['imagenUrl'] ?? '';

              return Card(

                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: url.isNotEmpty
                        ? Image.network(url, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.eco, color: Colors.green),
                  ),
                  title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('SKU: $sku'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activo ? 'Visible' : 'Oculto',
                        style: TextStyle(
                            color: activo ? Colors.green[700] : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12
                        ),
                      ),
                      Switch(
                        value: activo,
                        activeColor: Colors.green[700],
                        onChanged: (bool valorNuevo) async {
                          await _inventoryVM.inhabilitarProducto(id, valorNuevo);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/product_model.dart';
import '../inventory/inventory_viewmodel.dart';
import 'edit_product_screen.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InventoryViewModel inventoryVM = InventoryViewModel();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Seleccionar Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('productos').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay productos en la base de datos 🌿'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final String id = doc.id;
                    final String nombre = data['nombre'] ?? 'Sin nombre';
                    final String categoria = data['categoria'] ?? 'Plantas de Interior';
                    final double precio = (data['precio'] ?? 0).toDouble();
                    final int stock = data['stock'] ?? 0;
                    final String url = data['imagenUrl'] ?? '';
                    final bool activo = data['activo'] ?? true;

                    final productoReal = ProductModel(
                      id: id,
                      nombre: nombre,
                      categoria: categoria,
                      precio: precio,
                      stock: stock,
                      descripcion: data['descripcion'] ?? '',
                      sku: data['sku'] ?? '',
                      imagenUrl: url,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _mostrarOpciones(context, inventoryVM, productoReal, activo);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[50],
                                child: Icon(_obtenerIconoCategoria(categoria), color: Colors.green[800]),
                              ),
                              const SizedBox(width: 16),

                              // 🟢 EXPANDED CENTRAL: Protege que el nombre y metadatos no empujen la UI
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nombre,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),

                                    // 🟢 ROW COMPARTIDO INTERNO CON CONTENCIÓN
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              categoria,
                                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Stock: $stock uds',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: stock <= 5 ? Colors.red[700] : Colors.grey[600],
                                            fontWeight: stock <= 5 ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 🟢 BLOQUE DE PRECIO SEGURO Y FLEXIBLE
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '\$${precio.toStringAsFixed(0)}',
                                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 15),
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarOpciones(BuildContext context, InventoryViewModel inventoryVM, ProductModel producto, bool activo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.eco_outlined, color: Colors.green),
                title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(activo ? 'Estado: Visible en Catálogo' : 'Estado: Oculto (Inhabilitado)'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.blue),
                title: const Text('Modificar datos del producto'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductScreen(producto: producto),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  activo ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: activo ? Colors.red : Colors.green,
                ),
                title: Text(activo ? 'Inhabilitar del catálogo' : 'Habilitar en catálogo'),
                onTap: () async {
                  Navigator.pop(context);
                  await inventoryVM.inhabilitarProducto(producto.id, !activo);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(activo ? 'Producto ocultado con éxito 🚫' : 'Producto habilitado con éxito 🌿'),
                        backgroundColor: activo ? Colors.red : Colors.green,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _obtenerIconoCategoria(String categoria) {
    switch (categoria.toLowerCase().trim()) {
      case 'plantas de interior': return Icons.home_max_outlined;
      case 'exterior': return Icons.nature_people_outlined;
      case 'cactus': return Icons.tsunami_outlined;
      case 'fertilizantes': return Icons.science_outlined;
      case 'herramientas': return Icons.handyman_outlined;
      case 'tratamiento': return Icons.health_and_safety_outlined;
      case 'macetas': return Icons.inventory_2_outlined;
      case 'decoraciones': return Icons.wb_sunny_outlined;
      case 'sustratos': return Icons.layers_rounded;
      default: return Icons.eco_rounded;
    }
  }
}
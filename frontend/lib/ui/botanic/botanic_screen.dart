import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BotanicScreen extends StatelessWidget {
  const BotanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Auxiliar Botánico',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF00796B),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Pedidos'),
              Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Vivero'),
              Tab(icon: Icon(Icons.video_camera_front_outlined), text: 'Asesorías'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PedidosTab(),
            _ViveroStockTab(),
            _AsesoriasTab(),
          ],
        ),
      ),
    );
  }
}


class _PedidosTab extends StatelessWidget {
  const _PedidosTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pedidos')
          .orderBy('fechaCreacion', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No hay solicitudes de pedidos entrantes 📥',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          );
        }

        final pedidos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            final doc = pedidos[index];
            final data = doc.data() as Map<String, dynamic>;

            final String id = doc.id;
            final String estado = data['estado'] ?? 'EN DESPACHO';
            final double total = (data['totalPagar'] ?? 0).toDouble();
            final String nombreCliente = data['cliente']?['nombre'] ?? 'Cliente';
            final List<dynamic> items = data['items'] ?? [];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text('Pedido #${id.substring(0, 6).toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Cliente: $nombreCliente\nTotal: \$${total.toStringAsFixed(0)} COP'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌱 Productos:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...items.map((item) => Text('• ${item['cantidad']}x ${item['nombre']}')),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Estado del pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              value: ['EN DESPACHO', 'EN CAMINO', 'ENTREGADO', 'CANCELADO'].contains(estado) ? estado : 'EN DESPACHO',
                              items: <String>['EN DESPACHO', 'EN CAMINO', 'ENTREGADO', 'CANCELADO']
                                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                              onChanged: (nuevoEstado) async {
                                if (nuevoEstado != null) {
                                  await FirebaseFirestore.instance.collection('pedidos').doc(id).update({'estado': nuevoEstado});
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}


class _ViveroStockTab extends StatelessWidget {
  const _ViveroStockTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.eco, color: Color(0xFF00796B), size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Operaciones de Vivero',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Consulta y registro físico de plantas en stock (RF001-3)',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar planta por nombre o ID...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('productos').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No hay productos en la base de datos 🍃'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  final String id = doc.id;
                  final String nombre = data['nombre'] ?? 'Planta';
                  final int stock = data['stock'] ?? 0;

                  Color indicadorColor = Colors.green;
                  if (stock <= 5 && stock > 0) indicadorColor = Colors.orange;
                  if (stock == 0) indicadorColor = Colors.red;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7FC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            decoration: BoxDecoration(
                              color: indicadorColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stock actual: $stock unidades',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: TextButton.icon(
                              onPressed: () => _mostrarDialogoConsolidacion(context, id, nombre, stock),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFE0F2F1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.edit, size: 16, color: Color(0xFF00796B)),
                              label: const Text(
                                '+ Consolidar',
                                style: TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _mostrarDialogoConsolidacion(BuildContext context, String productoId, String nombrePlanta, int stockActual) {
    final cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Consolidar Inventario\n$nombrePlanta', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ingresa la cantidad física que vas a añadir al stock actual ($stockActual uds).'),
            const SizedBox(height: 16),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(
                labelText: 'Unidades entrantes',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B)),
            onPressed: () async {
              final int? ingresado = int.tryParse(cantidadController.text);
              if (ingresado != null && ingresado > 0) {
                await FirebaseFirestore.instance
                    .collection('productos')
                    .doc(productoId)
                    .update({'stock': stockActual + ingresado});
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


class _AsesoriasTab extends StatelessWidget {
  const _AsesoriasTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.indigo.withOpacity(0.1),
            child: const Icon(Icons.video_camera_front_outlined, size: 45, color: Colors.indigo),
          ),
          const SizedBox(height: 24),
          const Text(
            'Administración de Asesorías',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Desde aquí podrás gestionar las asesorias agendadas por los clientes y asignar los expertos del vivero.',
              textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.3),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.lock_open_rounded, color: Colors.white),
              label: const Text(
                'Abrir Panel de Citas',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hola'),
                    backgroundColor: Colors.indigo,
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
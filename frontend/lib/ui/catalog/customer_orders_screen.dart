import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
              'Mis Pedidos Rootmie 📦',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
          ),
          backgroundColor: Colors.green[800],
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Activos'),
              Tab(icon: Icon(Icons.history), text: 'Historial'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ListaPedidosUsuario(verActivos: true),
            _ListaPedidosUsuario(verActivos: false),
          ],
        ),
      ),
    );
  }
}

class _ListaPedidosUsuario extends StatelessWidget {
  final bool verActivos;

  const _ListaPedidosUsuario({required this.verActivos});

  @override
  Widget build(BuildContext context) {
    final List<String> estadosFiltro = verActivos
        ? ['EN DESPACHO', 'EN CAMINO']
        : ['ENTREGADO', 'CANCELADO'];

    final String? emailUsuarioActual = FirebaseAuth.instance.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pedidos')
          .where('cliente.email', isEqualTo: emailUsuarioActual)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  verActivos ? 'No tienes pedidos en camino 🚚' : 'Tu historial está vacío 📄',
                  style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }


        final docsOrdenados = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        docsOrdenados.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final Timestamp? fechaA = dataA['fechaCreacion'] as Timestamp?;
          final Timestamp? fechaB = dataB['fechaCreacion'] as Timestamp?;
          if (fechaA == null) return 1;
          if (fechaB == null) return -1;
          return fechaB.compareTo(fechaA);
        });

        // Filtramos localmente sobre la lista ordenada
        final pedidosFiltrados = docsOrdenados.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final String estado = data['estado'] ?? 'EN DESPACHO';
          return estadosFiltro.contains(estado);
        }).toList();

        if (pedidosFiltrados.isEmpty) {
          return Center(
            child: Text(
              verActivos ? 'No hay pedidos activos actualmente.' : 'No hay pedidos finalizados todavía.',
              style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pedidosFiltrados.length,
          itemBuilder: (context, index) {
            final pedidoDoc = pedidosFiltrados[index];
            final data = pedidoDoc.data() as Map<String, dynamic>;

            final String estado = data['estado'] ?? 'EN DESPACHO';
            final String metodoPago = data['metodoPago'] ?? 'Tarjeta';
            final List<dynamic> items = data['items'] ?? [];
            final double total = (data['totalPagar'] ?? 0).toDouble();

            Color estadoColor = Colors.blue;
            IconData estadoIcon = Icons.inventory_2_outlined;

            if (estado == 'EN CAMINO') {
              estadoColor = Colors.orange;
              estadoIcon = Icons.local_shipping_outlined;
            } else if (estado == 'ENTREGADO') {
              estadoColor = Colors.green;
              estadoIcon = Icons.check_circle_outline;
            } else if (estado == 'CANCELADO') {
              estadoColor = Colors.red;
              estadoIcon = Icons.cancel_outlined;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: estadoColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(estadoIcon, color: estadoColor),
                ),
                title: Text(
                  'Pedido #${pedidoDoc.id.substring(0, 5).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Estado: $estado',
                  style: TextStyle(color: estadoColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                trailing: Text(
                  '\$${total.toStringAsFixed(0)} COP',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    key: ValueKey(pedidoDoc.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 4),
                        Text('👤 Destinatario: ${data['cliente']?['nombre'] ?? "N/A"}', style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('📍 Envío a: ${data['cliente']?['direccion'] ?? "N/A"}', style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('💳 Pago mediante: $metodoPago', style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 12),
                        const Text(
                          'Resumen de Productos:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '• ${item['cantidad']}x ${item['nombre']}',
                                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                                  ),
                                ),
                                Text(
                                  '\$${(item['subtotal'] ?? 0).toStringAsFixed(0)} COP',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 4),
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
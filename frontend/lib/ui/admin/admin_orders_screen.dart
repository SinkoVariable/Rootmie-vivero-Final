import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<void> _cambiarEstadoLogistico(String pedidoId, String nuevoEstado) async {
    await FirebaseFirestore.instance.collection('pedidos').doc(pedidoId).update({
      'estado': nuevoEstado,
      'ultimaActualizacion': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<String> estadosLogiticos = ['EN DESPACHO', 'EN CAMINO', 'ENTREGADO', 'CANCELADO'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Control de Pedidos Rootmie', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pedidos').orderBy('fechaCreacion', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay pedidos registrados en el sistema. 📄'));
          }

          final pedidos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              final data = pedido.data() as Map<String, dynamic>;


              final String estadoCrudo = data['estado'] ?? 'EN DESPACHO';
              final String estado = estadosLogiticos.contains(estadoCrudo) ? estadoCrudo : 'EN DESPACHO';

              final String metodo = data['metodoPago'] ?? 'No especificado';
              final List<dynamic> items = data['items'] ?? [];

              Color estadoColor = Colors.blue;
              if (estado == 'ENTREGADO') estadoColor = Colors.green;
              if (estado == 'CANCELADO') estadoColor = Colors.red;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  leading: Icon(Icons.local_shipping, color: estadoColor),
                  title: Text('Pedido #${pedido.id.substring(0, 7).toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Estado: $estado • Vía: $metodo', style: TextStyle(color: estadoColor, fontWeight: FontWeight.w600, fontSize: 12)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Text('📍 Cliente: ${data['cliente']?['nombre'] ?? "No registrado"}'),
                          Text('📍 Dirección: ${data['cliente']?['direccion'] ?? "No registrada"}'),
                          Text('📞 Teléfono: ${data['cliente']?['telefono'] ?? "No registrado"}'),
                          const SizedBox(height: 10),
                          const Text('Productos:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...items.map((item) => Text('• ${item['cantidad']}x ${item['nombre']} (\$${item['subtotal']})')),
                          const Divider(),
                          Text('Total Pagado: \$${data['totalPagar']} COP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 15),


                          if (estado != 'CANCELADO' && estado != 'ENTREGADO') ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('⚙️ Actualizar Estado :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: estado,
                                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder()),
                                    items: estadosLogiticos.map((est) => DropdownMenuItem(value: est, child: Text(est))).toList(),
                                    onChanged: (nuevoEst) => _cambiarEstadoLogistico(pedido.id, nuevoEst!),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Center(child: Text('📦 Finalizado con estado: $estado', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
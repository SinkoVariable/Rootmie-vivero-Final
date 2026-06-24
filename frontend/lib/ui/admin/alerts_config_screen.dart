import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsConfigScreen extends StatelessWidget {
  const AlertsConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text(
          'Configurar Umbrales',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
        ),
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestión de Alertas de Stock 🔔',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                SizedBox(height: 4),
                Text(
                  'Define los límites permitidos para automatizar las alertas de reabastecimiento.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
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
                  return const Center(child: Text('No hay productos registrados para configurar 🌿'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final String id = doc.id;
                    final String nombre = data['nombre'] ?? 'Sin nombre';
                    final int stockActual = data['stock'] ?? 0;


                    final int stockMinimo = data['stockMinimo'] ?? 5;
                    final int stockMaximo = data['stockMaximo'] ?? 50;

                    // Validación visual rápida del estado de stock actual
                    bool estaEnAlerta = stockActual <= stockMinimo;

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: estaEnAlerta ? Colors.red[50] : Colors.green[50],
                          child: Icon(
                            estaEnAlerta ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                            color: estaEnAlerta ? Colors.red[700] : Colors.green[700],
                          ),
                        ),
                        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Actual: $stockActual uds  |  Mín: $stockMinimo  |  Máx: $stockMaximo',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.tune_rounded, color: Colors.blueGrey),
                          tooltip: 'Configurar Parámetros',
                          onPressed: () {
                            _mostrarFormularioAlertas(context, id, nombre, stockMinimo, stockMaximo);
                          },
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


  void _mostrarFormularioAlertas(BuildContext context, String productoId, String nombre, int minActual, int maxActual) {
    final formKey = GlobalKey<FormState>();
    int nuevoMinimo = minActual;
    int nuevoMaximo = maxActual;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Alertas: $nombre',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.notifications_active_outlined, color: Colors.amber),
                  ],
                ),
                const Divider(height: 24),
                const SizedBox(height: 8),

                Row(
                  children: [

                    Expanded(
                      child: TextFormField(
                        initialValue: minActual.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock Mínimo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          helperText: 'Nivel crítico / pedido',
                        ),
                        validator: (val) {
                          if (val == null || int.tryParse(val) == null) return 'Número inválido';
                          final ingresado = int.parse(val);
                          if (ingresado < 0) return 'No puede ser negativo';
                          nuevoMinimo = ingresado;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Campo: Stock Máximo
                    Expanded(
                      child: TextFormField(
                        initialValue: maxActual.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Stock Máximo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          helperText: 'Límite de capacidad',
                        ),
                        validator: (val) {
                          if (val == null || int.tryParse(val) == null) return 'Número inválido';
                          final ingresado = int.parse(val);
                          if (ingresado < nuevoMinimo) {
                            return 'Debe ser mayor al mínimo';
                          }
                          nuevoMaximo = ingresado;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),


                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {

                        await FirebaseFirestore.instance.collection('productos').doc(productoId).update({
                          'stockMinimo': nuevoMinimo,
                          'stockMaximo': nuevoMaximo,
                        });

                        if (context.mounted) {
                          Navigator.pop(context); // Cierra modal
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Parámetros de alerta actualizados inmediatamente 🔔'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Confirmar Configuración', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
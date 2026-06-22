import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String clienteEmail;
  final List<dynamic> items; // Lista de productos comprados
  final double total;
  final String estado; // 'PENDIENTE', 'PREPARANDO', 'DESPACHADO', 'ENTREGADO'
  final DateTime fecha;

  OrderModel({
    required this.id,
    required this.clienteEmail,
    required this.items,
    required this.total,
    required this.estado,
    required this.fecha,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      clienteEmail: data['clienteEmail'] ?? 'Anónimo',
      items: data['items'] ?? [],
      total: (data['total'] ?? 0).toDouble(),
      estado: data['estado'] ?? 'PENDIENTE',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
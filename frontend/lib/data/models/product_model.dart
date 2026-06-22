import 'package:cloud_firestore/cloud_firestore.dart';
class ProductModel {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final double precio;
  final int stock;
  final String sku;
  final String imagenUrl;

  ProductModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.sku,
    required this.imagenUrl,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      categoria: data['categoria'] ?? 'General',
      precio: (data['precio'] ?? 0.0).toDouble(),
      stock: data['stock'] ?? 0,
      sku: data['sku'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
      'sku': sku,
      'imagenUrl': imagenUrl,
      'fechaActualizacion': FieldValue.serverTimestamp(),
    };
  }
}
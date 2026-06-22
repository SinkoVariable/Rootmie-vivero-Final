import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../data/models/product_model.dart';

class InventoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  List<ProductModel> _productos = [];

  bool get isLoading => _isLoading;
  List<ProductModel> get productos => _productos;


  void escucharInventario() {
    _isLoading = true;

    _firestore
        .collection('productos')
        .snapshots()
        .listen((snapshot) {
      _productos = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          categoria: data['categoria'] ?? 'Interior',
          precio: (data['precio'] ?? 0).toDouble(),
          stock: data['stock'] ?? 0,
          descripcion: data['descripcion'] ?? '',
          sku: data['sku'] ?? '',
          imagenUrl: data['imagenUrl'] ?? '',
        );
      }).toList();
      _isLoading = false;
      notifyListeners();
    });
  }


  Future<String> subirImagen(File imagenFile, String sku) async {
    try {
      Reference ref = _storage.ref().child('productos/$sku.jpg');
      UploadTask uploadTask = ref.putFile(imagenFile);
      TaskSnapshot snapshot = await uploadTask;
      String urlDescarga = await snapshot.ref.getDownloadURL();
      return urlDescarga;
    } catch (e) {
      debugPrint("Error al subir imagen en Storage: $e");
      return '';
    }
  }

  // AGREGAR NUEVO INSUMO / PLANTA
  Future<bool> agregarProducto({
    required String nombre,
    required String descripcion,
    required String categoria,
    required double precio,
    required int stock,
    required String sku,
    required String imagenUrl,
  }) async {
    try {
      DocumentReference nuevoDocRef = _firestore.collection('productos').doc();
      String idUnico = nuevoDocRef.id;

      Map<String, dynamic> datosProducto = {
        'id': idUnico,
        'nombre': nombre,
        'descripcion': descripcion,
        'categoria': categoria,
        'precio': precio,
        'stock': stock,
        'sku': sku,
        'imagenUrl': imagenUrl,
        'activo': true, // 🌿 Todo producto nuevo entra Habilitado
        'fechaActualizacion': FieldValue.serverTimestamp(),
      };

      await nuevoDocRef.set(datosProducto);
      return true;
    } catch (e) {
      debugPrint("Error al agregar producto en Firestore: $e");
      return false;
    }
  }

  //  INHABILITAR PRODUCTO
  Future<bool> inhabilitarProducto(String id, bool nuevoEstado) async {
    try {
      await _firestore.collection('productos').doc(id).update({
        'activo': nuevoEstado,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint("Error al cambiar estado del producto: $e");
      return false;
    }
  }

  //  ACTUALIZAR STOCK, PRECIO O IMAGEN
  Future<bool> actualizarProducto(String id, ProductModel producto) async {
    try {
      await _firestore.collection('productos').doc(id).update(producto.toMap());
      return true;
    } catch (e) {
      debugPrint("Error al actualizar producto en Firestore: $e");
      return false;
    }
  }

  //  ELIMINAR DEL INVENTARIO
  Future<bool> eliminarProducto(String id) async {
    try {
      await _firestore.collection('productos').doc(id).delete();
      return true;
    } catch (e) {
      debugPrint("Error al eliminar producto en Firestore: $e");
      return false;
    }
  }
}
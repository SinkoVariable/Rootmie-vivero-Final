import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/product_model.dart';

class CatalogViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredPlants = [];
  String _selectedCategory = 'Todas';
  int _cartCount = 0;


  List<ProductModel> get filteredPlants => _filteredPlants;
  String get selectedCategory => _selectedCategory;
  int get cartCount => _cartCount;

  CatalogViewModel() {
    _listenToProducts();
  }


  void _listenToProducts() {

    _firestore.collection('productos').snapshots().listen((snapshot) {

      debugPrint("📦 Conexión establecida. Documentos encontrados: ${snapshot.docs.length}");

      _allProducts = snapshot.docs.map((doc) {
        final data = doc.data();


        debugPrint("📄 Datos del Doc [${doc.id}]: $data");


        final String nombreDetectado = data['nombre'] ?? data['name'] ?? 'Sin nombre';
        final String descripcionDetectada = data['descripcion'] ?? data['description'] ?? '';
        final String categoriaDetectada = data['categoria'] ?? data['category'] ?? 'Plantas de Interior';
        final double precioDetectado = (data['precio'] ?? data['price'] ?? 0).toDouble();
        final int stockDetectado = data['stock'] ?? 0;
        final String skuDetectado = data['sku'] ?? '';
        final String imagenUrlDetectada = data['imagenUrl'] ?? data['imageUrl'] ?? '';

        return ProductModel(
          id: doc.id,
          nombre: nombreDetectado,
          descripcion: descripcionDetectada,
          categoria: categoriaDetectada,
          precio: precioDetectado,
          stock: stockDetectado,
          sku: skuDetectado,
          imagenUrl: imagenUrlDetectada,
        );
      }).toList();


      _applyFilter();
    }, onError: (error) {
      debugPrint("❌ ERROR AL LEER FIRESTORE: $error");
    });
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
  }


  void _applyFilter() {
    if (_selectedCategory.trim().toLowerCase() == 'todas') {
      _filteredPlants = List.from(_allProducts);
    } else {
      _filteredPlants = _allProducts.where((product) {
        final productoCat = product.categoria.trim().toLowerCase();
        final filtroCat = _selectedCategory.trim().toLowerCase();
        return productoCat == filtroCat;
      }).toList();
    }


    notifyListeners();
  }


  void addToCart() {
    _cartCount++;
    notifyListeners();
  }

  void clearCart() {
    _cartCount = 0;
    notifyListeners();
  }
}
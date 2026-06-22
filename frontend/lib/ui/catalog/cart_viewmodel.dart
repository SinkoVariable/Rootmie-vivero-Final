import 'package:flutter/material.dart';
import 'package:frontend/data/models/product_model.dart';
import 'package:frontend/ui/models/cart_item_model.dart';
class CartViewModel extends ChangeNotifier {

  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();


  final Map<String, CartItemModel> _items = {};


  List<CartItemModel> get cartItems => _items.values.toList();


  int get totalUnidades => _items.values.fold(0, (suma, item) => suma + item.cantidad);


  int get itemTypeCount => _items.length;


  double get totalPagar => _items.values.fold(0.0, (suma, item) => suma + item.subtotal);


  void agregarProducto(ProductModel producto, {int cantidadSolicitada = 1}) {
    if (_items.containsKey(producto.id)) {

      int nuevaCantidad = _items[producto.id]!.cantidad + cantidadSolicitada;
      if (nuevaCantidad <= producto.stock) {
        _items[producto.id]!.cantidad = nuevaCantidad;
      } else {
        _items[producto.id]!.cantidad = producto.stock;
      }
    } else {

      _items[producto.id] = CartItemModel(
        product: producto,
        cantidad: cantidadSolicitada > producto.stock ? producto.stock : cantidadSolicitada,
      );
    }
    notifyListeners();
  }


  void incrementarItem(String productoId) {
    if (_items.containsKey(productoId)) {
      bool exito = _items[productoId]!.incrementar();
      if (exito) notifyListeners();
    }
  }


  void decrementarItem(String productoId) {
    if (_items.containsKey(productoId)) {
      bool exito = _items[productoId]!.decrementar();
      if (exito) {
        notifyListeners();
      } else {

        removerItem(productoId);
      }
    }
  }


  void removerItem(String productoId) {
    _items.remove(productoId);
    notifyListeners();
  }


  void vaciarCarrito() {
    _items.clear();
    notifyListeners();
  }
}
import 'package:frontend/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int cantidad;

  CartItemModel({
    required this.product,
    this.cantidad = 1,
  });

  // Cálculo automático del subtotal del ítem
  double get subtotal => product.precio * cantidad;

  // Incrementar cantidad respetando el stock máximo
  bool incrementar() {
    if (cantidad < product.stock) {
      cantidad++;
      return true;
    }
    return false;
  }

  // Decrementar cantidad
  bool decrementar() {
    if (cantidad > 1) {
      cantidad--;
      return true;
    }
    return false;
  }
}
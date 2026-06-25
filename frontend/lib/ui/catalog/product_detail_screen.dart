import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'cart_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final int stockMinimo = (widget.product as dynamic).toString().contains('stockMinimo')
        ? (widget.product as dynamic).stockMinimo ?? 5
        : 5;
    final bool bajoStock = widget.product.stock <= stockMinimo;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.green[50],
              child: widget.product.imagenUrl.isNotEmpty
                  ? Image.network(
                widget.product.imagenUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image_outlined, color: Colors.green, size: 64);
                },
              )
                  : const Icon(Icons.eco_outlined, color: Colors.green, size: 80),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.product.categoria,
                      style: TextStyle(color: Colors.green[800], fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.nombre,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.precio.toStringAsFixed(0)} COP',
                    style: TextStyle(color: Colors.green[700], fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('SKU: ${widget.product.sku}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: bajoStock ? Colors.red[50] : Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Disponibles: ${widget.product.stock} uds',
                          style: TextStyle(
                            color: bajoStock ? Colors.red[700] : Colors.blueGrey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Descripción',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.descripcion.isNotEmpty
                        ? widget.product.descripcion
                        : 'Este insumo no cuenta con una descripción detallada todavía. Ideal para el cuidado de tu jardín o cultivos.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Text(
                        'Cantidad:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: _cantidad > 1 ? () => setState(() => _cantidad--) : null,
                            ),
                            Text(
                              '$_cantidad',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: _cantidad < widget.product.stock
                                  ? () => setState(() => _cantidad++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      label: const Text(
                        'Agregar al Carrito',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: widget.product.stock > 0
                          ? () {
                        CartViewModel().agregarProducto(widget.product, cantidadSolicitada: _cantidad);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('¡Se agregaron $_cantidad unidad(es) de "${widget.product.nombre}" al carrito! 🌿'),
                            backgroundColor: Colors.green[900],
                          ),
                        );
                      }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
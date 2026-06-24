import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_viewmodel.dart';
import 'package:frontend/ui/models/cart_item_model.dart';
import 'payment_gate_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los datos obligatorios del cliente
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  String _metodoPagoSeleccionado = 'Tarjeta de Crédito';
  final List<String> _metodosPago = ['Tarjeta de Crédito', 'Transferencia Bancaria', 'Efectivo / Corresponsal'];

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  // Formulario Modal para capturar datos del cliente y mandarlo a la pasarela
  void _mostrarFormularioCliente(CartViewModel cartVM) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos de Entrega y Facturación 📋',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 4),
                      const Text('Completa los datos para proceder al pago seguro.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const Divider(height: 24),

                      TextFormField(
                        controller: _nombreController,
                        decoration: InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (val) => val == null || val.isEmpty ? 'El nombre es obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Teléfono de Contacto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (val) => val == null || val.isEmpty ? 'El teléfono es obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _direccionController,
                        decoration: InputDecoration(labelText: 'Dirección de Envío', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (val) => val == null || val.isEmpty ? 'La dirección es obligatoria' : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown integrado directamente en el modal para el método de pago
                      DropdownButtonFormField<String>(
                        value: _metodoPagoSeleccionado,
                        decoration: InputDecoration(labelText: 'Método de Pago', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        items: _metodosPago.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                        onChanged: (val) {
                          setModalState(() => _metodoPagoSeleccionado = val!);
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);


                              final String emailActual = FirebaseAuth.instance.currentUser?.email ?? 'anonimo@rootmie.com';


                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentGateScreen(
                                    cartVM: cartVM,
                                    nombreCliente: _nombreController.text.trim(),
                                    direccionCliente: _direccionController.text.trim(),
                                    telefonoCliente: _telefonoController.text.trim(),
                                    metodoPago: _metodoPagoSeleccionado,
                                    emailCliente: emailActual, // 👈 PARÁMETRO ENVIADO AQUÍ
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Ir a Pagar Seguro 💳', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = CartViewModel();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Carrito Rootmie 🛒', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: cartVM,
        builder: (context, child) {
          if (cartVM.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  const Text('¡Explora el catálogo y añade insumos botánicos! 🌿', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartVM.cartItems.length,
                  itemBuilder: (context, index) {
                    final CartItemModel item = cartVM.cartItems[index];

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: item.product.imagenUrl.isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(item.product.imagenUrl, fit: BoxFit.cover),
                              )
                                  : const Icon(Icons.eco_outlined, color: Colors.green),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text(item.product.categoria, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${item.subtotal.toStringAsFixed(0)} COP',
                                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(item.cantidad == 1 ? Icons.delete_outline : Icons.remove, size: 18, color: Colors.red[700]),
                                    onPressed: () => cartVM.decrementarItem(item.product.id),
                                  ),
                                  Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18, color: Colors.green),
                                    onPressed: () => cartVM.incrementarItem(item.product.id),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total de productos:', style: TextStyle(color: Colors.grey, fontSize: 15)),
                        Text('${cartVM.totalUnidades} uds', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total a Pagar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                        Text(
                          '\$${cartVM.totalPagar.toStringAsFixed(0)} COP',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () => _mostrarFormularioCliente(cartVM),
                        child: const Text('Proceder con el Pedido', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
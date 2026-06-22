import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_viewmodel.dart';

class PaymentGateScreen extends StatelessWidget {
  final CartViewModel cartVM;
  final String nombreCliente;
  final String direccionCliente;
  final String telefonoCliente;
  final String metodoPago;
  final String emailCliente;

  const PaymentGateScreen({
    super.key,
    required this.cartVM,
    required this.nombreCliente,
    required this.direccionCliente,
    required this.telefonoCliente,
    required this.metodoPago,
    required this.emailCliente,
  });


  Future<void> _procesarPedidoFirebase(BuildContext context) async {
    try {
      final CollectionReference pedidos = FirebaseFirestore.instance.collection('pedidos');

      await pedidos.add({
        'cliente': {
          'nombre': nombreCliente,
          'direccion': direccionCliente,
          'telefono': telefonoCliente,
          'email': emailCliente,
        },
        'estado': 'EN DESPACHO',
        'fechaCreacion': FieldValue.serverTimestamp(),
        'metodoPago': metodoPago,
        'totalPagar': cartVM.totalPagar,
        'items': cartVM.cartItems.map((item) => {
          'cantidad': item.cantidad,
          'nombre': item.product.nombre,
          'productoId': item.product.id,
          'subtotal': item.subtotal,
        }).toList(),
      });


      cartVM.vaciarCarrito();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido procesado con éxito! 🌿 En breve nos comunicaremos contigo.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar el pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasarela de Pago 💳', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 70, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Resumen de Transacción Segura',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(title: const Text('Titular del Pedido:'), subtitle: Text(nombreCliente)),
                      ListTile(title: const Text('Email registrado:'), subtitle: Text(emailCliente)),
                      ListTile(title: const Text('Dirección de entrega:'), subtitle: Text(direccionCliente)),
                      ListTile(title: const Text('Método seleccionado:'), subtitle: Text(metodoPago)),
                      const Divider(),
                      ListTile(
                        title: const Text('Monto Total a Pagar:', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(
                          '\$${cartVM.totalPagar.toStringAsFixed(0)} COP',
                          style: TextStyle(fontSize: 18, color: Colors.green[800], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _procesarPedidoFirebase(context),
                  child: const Text('Simular Pago / Confirmar Compra ✅', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'payment_gate_screen.dart';
import 'cart_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  final CartViewModel cartVM;
  const CheckoutScreen({super.key, required this.cartVM});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();

  String _metodoPagoSeleccionado = 'Tarjeta de Crédito';
  final List<String> _metodosPago = ['Tarjeta de Crédito', 'Transferencia Bancaria', 'Efectivo / Corresponsal'];

  void _irAPagar() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {


      final String emailActual = FirebaseAuth.instance.currentUser?.email ?? 'anonimo@rootmie.com';


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentGateScreen(
            cartVM: widget.cartVM,
            nombreCliente: _nombreController.text.trim(),
            direccionCliente: _direccionController.text.trim(),
            telefonoCliente: _telefonoController.text.trim(),
            metodoPago: _metodoPagoSeleccionado,
            emailCliente: emailActual,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Datos de Facturación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📍 Información de Envío', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Por favor, ingresa el nombre' : null
              ),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección de Entrega', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Por favor, ingresa la dirección' : null
              ),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono de Contacto', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Por favor, ingresa el teléfono' : null
              ),
              const SizedBox(height: 25),
              const Text('💳 Elige tu Método de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _metodoPagoSeleccionado,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: _metodosPago.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _metodoPagoSeleccionado = val!),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _irAPagar,
                  child: const Text('Proceder al Pago 💳', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
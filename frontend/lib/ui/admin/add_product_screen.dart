import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../inventory/inventory_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final InventoryViewModel _inventoryVM = InventoryViewModel();
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _descripcion = '';
  String _categoria = 'Plantas de Interior';
  double _precio = 0.0;
  int _stock = 0;
  bool _isLoading = false;

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categorias = [
    'Plantas de Interior',
    'Exterior',
    'Cactus',
    'Fertilizantes',
    'Herramientas',
    'Tratamiento',
    'Macetas',
    'Decoraciones',
    'Sustratos'
  ];


  String _generarSKUAutomatico() {
    final random = Random();

    const caracteres = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    String resultado = '';
    for (int i = 0; i < 6; i++) {
      resultado += caracteres[random.nextInt(caracteres.length)];
    }
    return 'RM-$resultado';
  }


  Future<void> _seleccionarImagen() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (foto != null) {
        setState(() {
          _imagenSeleccionada = File(foto.path);
        });
      }
    } catch (e) {
      debugPrint("Error al seleccionar imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nuevo Insumo Botánico', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[900],
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: GestureDetector(
                  onTap: _seleccionarImagen,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                      image: _imagenSeleccionada != null
                          ? DecorationImage(image: FileImage(_imagenSeleccionada!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imagenSeleccionada == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: Colors.green[700], size: 36),
                        const SizedBox(height: 6),
                        Text('Añadir foto', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Producto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
                onSaved: (val) => _nombre = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                maxLines: 3,
                onSaved: (val) => _descripcion = val ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: InputDecoration(labelText: 'Categoría', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: _categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _categoria = val ?? 'Plantas de Interior'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Precio (\$)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Precio inválido' : null,
                      onSaved: (val) => _precio = double.parse(val ?? '0'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Stock Inicial', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Cantidad inválida' : null,
                      onSaved: (val) => _stock = int.parse(val ?? '0'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      setState(() => _isLoading = true);


                      final String skuAutomatico = _generarSKUAutomatico();


                      String urlFotoCloud = '';
                      if (_imagenSeleccionada != null) {
                        urlFotoCloud = await _inventoryVM.subirImagen(_imagenSeleccionada!, skuAutomatico);
                      }

                      // 2. AGREGAR PRODUCTO A FIRESTORE
                      bool exito = await _inventoryVM.agregarProducto(
                        nombre: _nombre,
                        descripcion: _descripcion,
                        categoria: _categoria,
                        precio: _precio,
                        stock: _stock,
                        sku: skuAutomatico,
                        imagenUrl: urlFotoCloud,
                      );

                      setState(() => _isLoading = false);

                      if (mounted && exito) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Producto registrado con éxito como $skuAutomatico 🌿'), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al guardar el producto ❌'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar en Inventario', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
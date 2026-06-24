import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/product_model.dart';
import '../inventory/inventory_viewmodel.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel producto;
  const EditProductScreen({super.key, required this.producto});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final InventoryViewModel _inventoryVM = InventoryViewModel();
  final _formKey = GlobalKey<FormState>();

  late String _nombre;
  late String _descripcion;
  late String _categoria;
  late double _precio;
  late int _stock;
  late String _sku;
  bool _isLoading = false;


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

  @override
  void initState() {
    super.initState();
    _nombre = widget.producto.nombre;
    _descripcion = widget.producto.descripcion;
    _precio = widget.producto.precio;
    _stock = widget.producto.stock;
    _sku = widget.producto.sku;


    final catOriginal = widget.producto.categoria.trim();
    _categoria = _categorias.any((element) => element.toLowerCase() == catOriginal.toLowerCase())
        ? _categorias.firstWhere((element) => element.toLowerCase() == catOriginal.toLowerCase())
        : _categorias.first;
  }


  void _mostrarDialogoEliminar() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('¿Eliminar Producto?', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text('Esta acción eliminará permanentemente "$_nombre" del inventario y del catálogo. No se puede deshacer. ⚠️'),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Eliminar Completamente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.pop(dialogContext); // Cierra el diálogo
                setState(() => _isLoading = true);

                try {

                  await FirebaseFirestore.instance.collection('productos').doc(widget.producto.id).delete();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$_nombre" ha sido eliminado con éxito 🌿'),
                        backgroundColor: Colors.red[900],
                      ),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Modificar Insumo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[900],
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[900]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre del Producto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
                onSaved: (val) => _nombre = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _descripcion,
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
                      initialValue: _precio.toString(),
                      decoration: InputDecoration(labelText: 'Precio (\$)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Precio inválido' : null,
                      onSaved: (val) => _precio = double.parse(val ?? '0'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _stock.toString(),
                      decoration: InputDecoration(labelText: 'Stock Actual', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Cantidad inválida' : null,
                      onSaved: (val) => _stock = int.parse(val ?? '0'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _sku,
                decoration: InputDecoration(labelText: 'Código SKU', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val == null || val.isEmpty ? 'Código requerido' : null,
                onSaved: (val) => _sku = val ?? '',
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : Column(
                children: [
                  // Botón de Actualizar Existente
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          setState(() => _isLoading = true);

                          ProductModel productoEditado = ProductModel(
                            id: widget.producto.id,
                            nombre: _nombre,
                            descripcion: _descripcion,
                            categoria: _categoria,
                            precio: _precio,
                            stock: _stock,
                            sku: _sku,
                            imagenUrl: widget.producto.imagenUrl,
                          );

                          bool exito = await _inventoryVM.actualizarProducto(widget.producto.id, productoEditado);
                          setState(() => _isLoading = false);

                          if (mounted && exito) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Inventario actualizado correctamente 🔄'),
                                    backgroundColor: Colors.amber
                                )
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Actualizar Producto', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),


                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red[700]!, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.delete_outline_rounded, color: Colors.red[700]),
                      label: Text(
                        'Eliminar Producto del Sistema',
                        style: TextStyle(color: Colors.red[700], fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _mostrarDialogoEliminar,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
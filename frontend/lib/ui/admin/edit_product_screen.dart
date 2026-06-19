import 'package:frontend/ui/catalog/categories_data.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  // Parámetros obligatorios que debe recibir de la pantalla de selección
  final String initialName;
  final double initialPrice;
  final int initialStock;
  final String initialCategory;
  final String initialDescription;

  const EditProductScreen({
    super.key,
    required this.initialName,
    required this.initialPrice,
    required this.initialStock,
    required this.initialCategory,
    required this.initialDescription,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isActive = true;
  late String _selectedCategory;

  // Controladores de texto vacíos que inicializaremos en el initState
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    // Asignamos los valores que nos llegaron desde la pantalla de selección
    _selectedCategory = widget.initialCategory;
    _nameController = TextEditingController(text: widget.initialName);
    _priceController = TextEditingController(text: widget.initialPrice.toStringAsFixed(0));
    _stockController = TextEditingController(text: widget.initialStock.toString());
    _descController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Desplegamos el menú inferior con tus 9 categorías exactas
  void _showCategoryMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12),
                child: Text('Modificar Categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rootmieCategories.length,
                  itemBuilder: (context, index) {
                    final category = rootmieCategories[index];
                    final isSelected = _selectedCategory == category;
                    return ListTile(
                      title: Text(category, style: TextStyle(color: isSelected ? Colors.green[800] : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      leading: Icon(Icons.label_important_outline_rounded, color: isSelected ? Colors.green[700] : Colors.grey),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                      onTap: () {
                        setState(() { _selectedCategory = category; });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Modificar Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editar Producto Comercial ✏️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 8),
            const Text('Ajusta el precio, el stock actual o inhabilita el producto de Rootmie.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            // Interruptor para Inhabilitar (RF001-2)
            Container(
              decoration: BoxDecoration(
                color: _isActive ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isActive ? Colors.green[200]! : Colors.red[200]!),
              ),
              child: SwitchListTile(
                title: Text(_isActive ? 'Item Activo en Tienda' : 'Item Inhabilitado', style: TextStyle(fontWeight: FontWeight.bold, color: _isActive ? Colors.green[900] : Colors.red[900])),
                value: _isActive,
                activeColor: Colors.green[700],
                onChanged: (bool value) { setState(() { _isActive = value; }); },
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField('Nombre del Producto', Icons.inventory_2_outlined, _nameController),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField('Precio (COP)', Icons.attach_money_rounded, _priceController, keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: _buildTextField('Unidades (Stock Físico)', Icons.pin_rounded, _stockController, keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Selector interactivo de categoría
            const Text('Categoría del Catálogo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _showCategoryMenu,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(12), color: Colors.grey[50]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.category_outlined, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        Text(_selectedCategory, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField('Descripción / Indicaciones', Icons.description_outlined, _descController, maxLines: 3),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isActive
                          ? '¡"${_nameController.text}" actualizado correctamente! ✅'
                          : '¡Item modificado e Inhabilitado de Rootmie! 🔒'),
                    ),
                  );
                  Navigator.pop(context); // Cierra el formulario regresando a la lista
                },
                child: const Text('Actualizar Catálogo', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green[700]),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
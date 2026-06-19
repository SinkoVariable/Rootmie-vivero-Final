import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _selectedCategory = 'Plantas - Interior';

  // Lista expandida para incluir insumos botánicos según el alcance real de Rootmie
  final List<String> _categories = [
    'Plantas - Interior',
    'Plantas - Exterior',
    'Plantas - Suculentas',
    'Insumos - Fertilizantes',
    'Insumos - Herramientas',
    'Insumos - Tratamientos y Control de Plagas',
    'Insumos - Sustratos y Macetas'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nuevo Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrar Producto Comercial 🌿🛠️',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            const Text('Añade plantas o insumos botánicos al inventario y catálogo.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            // Selector de Imagen
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.green[700]),
                    const SizedBox(height: 8),
                    Text('Subir Imagen', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField('Nombre del Producto', Icons.inventory_2_outlined, 'Ej: Fertilizante Orgánico Nitrógeno u Horquilla'),
            const SizedBox(height: 15),

            // Fila para el Precio y la CANTIDAD (Stock inicial) de forma compacta y elegante
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField('Precio (COP)', Icons.attach_money_rounded, 'Ej: 22000', keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: _buildTextField('Cantidad (Stock)', Icons.pin_rounded, 'Ej: 50', keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Dropdown de Categoría Expandida
            const Text('Categoría del Catálogo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildTextField('Descripción y Dosificación / Uso', Icons.description_outlined, 'Detalles del insumo o cuidados de la planta...', maxLines: 3),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Item catalogado con éxito! 🎉'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar en Catálogo', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.green[700]),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
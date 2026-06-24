import 'package:flutter/material.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> proveedoresPlaceholder = [
      {
        'nombre': 'Sustratos del Caribe S.A.',
        'categoria': 'Sustratos y Tierras',
        'contacto': 'contacto@sustratoscaribe.com',
        'ofrece': 'Tierra abonada, turba rubia, cascarilla de arroz y fibra de coco premium.',
      },
      {
        'nombre': 'Distribuidora BioVerde',
        'categoria': 'Fertilizantes y Tratamiento',
        'contacto': 'ventas@bioverde.co',
        'ofrece': 'Fertilizantes orgánicos, triple 15, enraizantes y pesticidas ecológicos.',
      },
      {
        'nombre': 'Macetas Artesanales Tolima',
        'categoria': 'Macetas y Decoraciones',
        'contacto': 'gerencia@macetastolima.com',
        'ofrece': 'Macetas de barro cocido, cerámica esmaltada y bases de madera para interiores.',
      },
      {
        'nombre': 'TecnoRiego & Herramientas',
        'categoria': 'Herramientas',
        'contacto': 'soporte@tecnoriego.com',
        'ofrece': 'Sistemas de goteo automatizados, palas, podadoras de precisión y aspersores.',
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text(
          'Administrar Proveedores',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Directorio de Aliados 🏬',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 6),
                Text(
                  'Consulta los proveedores actuales de Rootmie Vivero y sus catálogos de insumos disponibles.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: proveedoresPlaceholder.length,
              itemBuilder: (context, index) {
                final prov = proveedoresPlaceholder[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                prov['nombre']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                prov['categoria']!,
                                style: TextStyle(fontSize: 11, color: Colors.green[800], fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '📧 Contacto: ${prov['contacto']}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const Divider(height: 20),
                        const Text(
                          'Insumos que ofrece:',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prov['ofrece']!,
                          style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
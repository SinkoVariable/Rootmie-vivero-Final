import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'catalog_viewmodel.dart';
import 'categories_data.dart';

import '../admin/admin_screen.dart';
import '../botanic/botanic_screen.dart';
import '../../../data/models/product_model.dart';
import '../login/login_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'cart_viewmodel.dart';
import 'profile_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String userRole;
  const CatalogScreen({super.key, this.userRole = 'CLIENTE'});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogViewModel _viewModel = CatalogViewModel();
  final CartViewModel _cartVM = CartViewModel();
  late List<String> _filterCategories;

  @override
  void initState() {
    super.initState();
    _filterCategories = ['Todas', ...rootmieCategories];
  }

  void _mostrarDialogoCerrarSesion(BuildContext contextScaffold) {
    showDialog(
      context: contextScaffold,
      builder: (contextDialog) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('¿Estás seguro de que deseas salir de tu cuenta en Rootmie Vivero?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextDialog),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(contextDialog);
              await FirebaseAuth.instance.signOut();

              if (contextScaffold.mounted) {
                Navigator.of(contextScaffold).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
            child: const Text('Salir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Catálogo Rootmie',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          if (widget.userRole == 'ADMIN' || widget.userRole == 'AUXILIAR')
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 28),
              tooltip: 'Acceder al Panel de Control',
              onPressed: () {
                Widget panelDestino = widget.userRole == 'ADMIN'
                    ? const AdminScreen()
                    : const BotanicScreen();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => panelDestino),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 26),
            tooltip: 'Mi Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListenableBuilder(
            listenable: _cartVM,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (_cartVM.totalUnidades > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${_cartVM.totalUnidades}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70, size: 24),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _mostrarDialogoCerrarSesion(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _filterCategories[index];
                    final isSelected = _viewModel.selectedCategory.trim().toLowerCase() == cat.trim().toLowerCase();

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            _viewModel.selectCategory(cat);
                          });
                        },
                        selectedColor: Colors.green[100],
                        checkmarkColor: Colors.green[800],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.green[800] : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('productos').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.green));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay plantas cargadas en la colección "productos" 🌿',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        );
                      }

                      final List<ProductModel> productosActivos = [];


                      debugPrint('============= INICIO CARGA FIRESTORE =============');
                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        final bool activo = data['activo'] ?? true;

                        final String rawNombre = data['nombre'] ?? 'Sin nombre';
                        final String rawCat = data['categoria'] ?? data['categoría'] ?? data['category'] ?? 'NULO';

                        debugPrint('ID: ${doc.id} | PRODUCTO: $rawNombre | CATEGORÍA EN BD: "$rawCat" | ACTIVO: $activo');

                        if (!activo) continue;

                        productosActivos.add(
                          ProductModel(
                            id: doc.id,
                            nombre: rawNombre,
                            descripcion: data['descripcion'] ?? data['description'] ?? '',
                            categoria: rawCat == 'NULO' ? 'Plantas de Interior' : rawCat,
                            precio: (data['precio'] ?? data['price'] ?? 0).toDouble(),
                            stock: data['stock'] ?? 0,
                            sku: data['sku'] ?? '',
                            imagenUrl: data['imagenUrl'] ?? data['imageUrl'] ?? '',
                          ),
                        );
                      }
                      debugPrint('================ FIN CARGA FIRESTORE ================');


                      final productosFiltrados = productosActivos.where((plant) {
                        final seleccionada = _viewModel.selectedCategory.trim().toLowerCase();
                        if (seleccionada == 'todas') return true;

                        final categoriaProducto = plant.categoria.trim().toLowerCase();


                        if (categoriaProducto == seleccionada) return true;
                        if (categoriaProducto.contains(seleccionada) || seleccionada.contains(categoriaProducto)) return true;


                        final palabrasSeleccionadas = seleccionada.split(' ').where((w) => w.length > 3).toList();
                        final palabrasProducto = categoriaProducto.split(' ');

                        return palabrasSeleccionadas.any((palabra) => palabrasProducto.contains(palabra));
                      }).toList();

                      if (productosFiltrados.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay plantas disponibles en "${_viewModel.selectedCategory}" 🌿\n(Revisa la consola para ver qué dice tu base de datos)',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.70,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: productosFiltrados.length,
                        itemBuilder: (context, index) {
                          final ProductModel plant = productosFiltrados[index];

                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(product: plant),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.green[50],
                                      child: plant.imagenUrl.isNotEmpty
                                          ? Image.network(
                                        plant.imagenUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.broken_image_outlined, color: Colors.green, size: 36);
                                        },
                                      )
                                          : const Icon(Icons.eco_outlined, color: Colors.green, size: 40),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plant.nombre,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${plant.precio.toStringAsFixed(0)} COP',
                                          style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 32,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green[700],
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            onPressed: () {
                                              _cartVM.agregarProducto(plant, cantidadSolicitada: 1);

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('"${plant.nombre}" agregado al carrito 🌿'),
                                                  backgroundColor: Colors.green[900],
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: const Text('Agregar', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
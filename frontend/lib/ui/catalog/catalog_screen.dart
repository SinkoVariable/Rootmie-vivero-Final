import 'package:flutter/material.dart';
import 'catalog_viewmodel.dart';
import 'categories_data.dart'; // <-- Importamos las nuevas categorías
import 'package:frontend/ui/admin/admin_screen.dart';
import 'package:frontend/ui/botanic/botanic_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String userRole;
  const CatalogScreen({super.key, this.userRole = 'CLIENTE'});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogViewModel _viewModel = CatalogViewModel();

  // Creamos la lista de filtros agregando "Todas" al principio de tus categorías
  final List<String> _filterCategories = ['Todas', ...rootmieCategories];

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
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () {
                      if (_viewModel.cartCount > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('¡Pedido simulado de ${_viewModel.cartCount} items enviado! 🌿'),
                            backgroundColor: Colors.green[900],
                          ),
                        );
                        _viewModel.clearCart();
                      }
                    },
                  ),
                  if (_viewModel.cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${_viewModel.cartCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Column(
            children: [
              // Filtros superiores deslizables con tus 9 categorías
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _filterCategories[index];
                    final isSelected = _viewModel.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          _viewModel.selectCategory(cat);
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
              // Cuadrícula del catálogo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _viewModel.filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = _viewModel.filteredPlants[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.green[50],
                                child: const Icon(Icons.eco_outlined, color: Colors.green, size: 40),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${plant.price.toStringAsFixed(0)} COP',
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
                                        _viewModel.addToCart();
                                      },
                                      child: const Text('Agregar', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
import 'package:flutter/material.dart';

class PlantItem {
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  PlantItem({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

class CatalogViewModel extends ChangeNotifier {
  int _cartCount = 0;
  String _selectedCategory = 'Todas';

  int get cartCount => _cartCount;
  String get selectedCategory => _selectedCategory;

  // Lista simulada de plantas de Rootmie con imágenes botánicas de internet
  final List<PlantItem> _allPlants = [
    PlantItem(
      name: 'Monstera Deliciosa',
      category: 'Interior',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?q=80&w=400&auto=format&fit=crop',
    ),
    PlantItem(
      name: 'Suculenta Cebra',
      category: 'Suculentas',
      price: 8000,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=400&auto=format&fit=crop',
    ),
    PlantItem(
      name: 'Helecho Boston',
      category: 'Interior',
      price: 15000,
      imageUrl: 'https://images.unsplash.com/photo-1512428559087-560fa5ceab42?q=80&w=400&auto=format&fit=crop',
    ),
    PlantItem(
      name: 'Árbol de Jade',
      category: 'Exterior',
      price: 12000,
      imageUrl: 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?q=80&w=400&auto=format&fit=crop',
    ),
    PlantItem(
      name: 'Cactus Candelabro',
      category: 'Suculentas',
      price: 18000,
      imageUrl: 'https://images.unsplash.com/photo-1508022047306-0397ab7df462?q=80&w=400&auto=format&fit=crop',
    ),
    PlantItem(
      name: 'Palmera de Salón',
      category: 'Exterior',
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c53b2d0c6b?q=80&w=400&auto=format&fit=crop',
    ),
  ];

  // Filtra las plantas en base a la categoría que toques
  List<PlantItem> get filteredPlants {
    if (_selectedCategory == 'Todas') {
      return _allPlants;
    }
    return _allPlants.where((plant) => plant.category == _selectedCategory).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart() {
    _cartCount++;
    notifyListeners();
  }

  void clearCart() {
    _cartCount = 0;
    notifyListeners();
  }
}
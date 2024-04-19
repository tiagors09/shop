import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  bool _showFavoriteOnly = false;

  List<Product> get items => _showFavoriteOnly
      ? _items.where((prod) => prod.isFavorite).toList()
      : [..._items];

  int get itemsCount => _items.length;

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id != null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';

import '../utils/constants.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  bool _showFavoriteOnly = false;

  final _url = Uri.parse(Constants.baseUrl + Constants.productsPath);

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

  Future<void> addProduct(Product product) {
    return http
        .post(
      _url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    )
        .then(
      (value) {
        _items.add(
          Product(
            id: Random().nextDouble().toString(),
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
          ),
        );
        notifyListeners();
      },
    );
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

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
    }
    notifyListeners();
  }
}

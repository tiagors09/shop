import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    this.quantity = 1,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount => _items.values.fold<double>(
        0.0,
        (total, currentCartItem) =>
            total + (currentCartItem.price * currentCartItem.quantity),
      );

  void addItem(Product product) {
    _items.containsKey(product.id)
        ? _items.update(
            product.id,
            (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price,
            ),
          )
        : _items.putIfAbsent(
            product.id,
            () => CartItem(
              id: Random().nextDouble().toString(),
              title: product.title,
              quantity: 1,
              price: product.price,
            ),
          );

    notifyListeners();
  }
}

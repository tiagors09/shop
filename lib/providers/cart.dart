import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    this.quantity = 1,
    required this.price,
  });

  String toJson() {
    return jsonEncode(
      {
        'id': id,
        'productId': productId,
        'title': title,
        'quantity': quantity,
        'price': price,
      },
    );
  }

  static CartItem fromJson(Map<String, dynamic> res) {
    return CartItem(
      id: res['id'],
      productId: res['productId'],
      title: res['title'],
      price: double.parse(res['price'].toString()),
      quantity: res['quantity'],
    );
  }
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
            product.id!,
            (existingItem) => CartItem(
              id: existingItem.id,
              productId: product.id!,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price,
            ),
          )
        : _items.putIfAbsent(
            product.id!,
            () => CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id!,
              title: product.title,
              quantity: 1,
              price: product.price,
            ),
          );

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    _items[productId]!.quantity == 1
        ? _items.remove(productId)
        : _items.update(
            productId,
            (existingItem) => CartItem(
              id: existingItem.id,
              productId: existingItem.productId,
              title: existingItem.title,
              quantity: existingItem.quantity - 1,
              price: existingItem.price,
            ),
          );
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  String toJson() {
    return jsonEncode(
      {
        'items': items.values.map((cartItem) => cartItem.toJson()).toList(),
        'itemsCount': itemsCount,
        'totalAmount': totalAmount,
        'date': DateTime.now().toIso8601String(),
      },
    );
  }
}

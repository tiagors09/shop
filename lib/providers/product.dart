import 'dart:convert';

import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  String toJSON() {
    return jsonEncode({
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    });
  }
}

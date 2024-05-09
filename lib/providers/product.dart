import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  set setFavorite(bool value) {
    isFavorite = value;
    notifyListeners();
  }

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

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static Product fromJson(Map<String, dynamic> res) {
    return Product(
      id: res['id'],
      title: res['title'],
      description: res['description'],
      price: res['price'],
      imageUrl: res['imageUrl'],
    );
  }
}

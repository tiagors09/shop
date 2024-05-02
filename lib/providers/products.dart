import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/environment.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final _items = <Product>[];

  bool _showFavoriteOnly = false;

  final _url = Environment.baseUrl + Environment.productsPath;

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

  Future<void> loadProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_url.json'),
      );

      Map<String, dynamic>? data = jsonDecode(response.body) ?? {};

      _items.clear();
      if (data!.isNotEmpty || response.statusCode == HttpStatus.ok) {
        data.forEach((productId, productData) {
          _items.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: double.parse(productData['price'].toString()),
              imageUrl: productData['imageUrl'],
              isFavorite: productData['isFavorite'],
            ),
          );
        });
        notifyListeners();
      }
    } catch (_) {
      throw const HttpException(Environment.allProductsError);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$_url.json'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: product.toJSON(),
      );

      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (_) {
      throw const HttpException(Environment.insertError);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final index = _items.indexWhere((prod) => prod.id == product.id);

      if (index >= 0) {
        await http.patch(
          Uri.parse(
            '$_url/${product.id}.json',
          ),
          body: product.toJSON(),
        );

        _items[index] = product;
        notifyListeners();
      }
    } catch (_) {
      throw const HttpException(Environment.updateError);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final index = _items.indexWhere((prod) => prod.id == id);
      if (index >= 0) {
        final product = _items[index];

        await http.delete(
          Uri.parse(
            '$_url/${product.id}.json',
          ),
        );

        _items.remove(product);
        notifyListeners();
      }
    } catch (e) {
      throw const HttpException(Environment.deleteError);
    }
  }
}

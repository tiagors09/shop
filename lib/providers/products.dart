import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/environment.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final _url = Environment.baseUrl + Environment.productsPath;

  bool _showFavoriteOnly = false;
  final String? _token;
  final List<Product> _items;

  Products(this._token, this._items);

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
        Uri.parse('$_url.json?auth=$_token'),
      );

      Map<String, dynamic> data = jsonDecode(response.body) ?? {};

      _items.clear();
      if (data.isNotEmpty || response.statusCode == HttpStatus.ok) {
        data.forEach((productId, productData) {
          _items.add(Product.fromJson({...productData, 'id': productId}));
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
        Uri.parse('$_url.json?auth=$_token'),
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
            '$_url/${product.id}.json?auth=$_token',
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
            '$_url/${product.id}.json?auth=$_token',
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

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/environment.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final _url = Environment.baseUrl + Environment.productsPath;

  final String? _token;
  final String? _userId;
  final List<Product> _items;

  bool _showFavoriteOnly = false;

  Products(this._token, this._userId, this._items);

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
      final response = await Future.wait(
        [
          http.get(
            Uri.parse('$_url.json?auth=$_token'),
          ),
          http.get(
            Uri.parse(
              '${Environment.baseUrl + Environment.favoriteProductsPath}/$_userId.json?auth=$_token',
            ),
          ),
        ],
      );

      Map<String, dynamic> data = jsonDecode(response[0].body) ?? {};

      Map<String, dynamic> favData = jsonDecode(response[1].body) ?? {};

      _items.clear();
      if (data.isNotEmpty || response[0].statusCode == HttpStatus.ok) {
        data.forEach(
          (productId, productData) {
            final isFavorite =
                favData == {} ? false : favData[productId] ?? false;
            _items.add(
              Product.fromJson(
                {
                  ...productData,
                  'id': productId,
                  'isFavorite': isFavorite,
                },
              ),
            );
          },
        );
        notifyListeners();
      }
    } catch (e) {
      print(e);
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
        body: jsonEncode(product.toJSON()),
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

  Future<void> toogleFavorite(Product product) async {
    try {
      product.toogleFavorite();

      final response = await http.put(
        Uri.parse(
          '${Environment.baseUrl + Environment.favoriteProductsPath}/$_userId/${product.id}.json?auth=$_token',
        ),
        body: jsonEncode(product.isFavorite),
      );

      if (response.statusCode >= 400) {
        product.toogleFavorite();
      }
    } catch (_) {
      throw const HttpException(Environment.toogleFavoriteError);
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
          body: jsonEncode(product.toJSON()),
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

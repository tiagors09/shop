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

  var _favoriteItems = <dynamic>[];

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

      _items.clear();
      if (data.isNotEmpty || response[0].statusCode == HttpStatus.ok) {
        data.forEach(
          (productId, productData) {
            _items.add(
              Product.fromJson(
                {...productData, 'id': productId},
              ),
            );
          },
        );
        notifyListeners();

        data = jsonDecode(response[1].body) ?? {};

        if (data.isNotEmpty || response[1].statusCode == HttpStatus.ok) {
          data.forEach(
            (id, favProd) {
              _favoriteItems.add(
                {
                  'id': id,
                  ...favProd,
                },
              );
            },
          );
        }

        for (var favProd in _favoriteItems) {
          final favProdId = favProd['productId'];
          final prodId = _items.indexWhere(
            (prod) => prod.id == favProdId.toString(),
          );

          if (prodId >= 0) {
            final product = _items[prodId];
            product.setFavorite = bool.parse(favProd['isFavorite'].toString());
          }
        }
      }

      _items.forEach(
        (element) {
          print(
            {
              ...element.toJSON(),
              'isFavorite': element.isFavorite,
            }.toString(),
          );
        },
      );
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

  Future<void> addFavoriteProduct(Product product) async {
    try {
      final productBody = {
        'productId': product.id,
        'isFavorite': product.isFavorite,
      };

      final response = await http.post(
        Uri.parse(
          '${Environment.baseUrl + Environment.favoriteProductsPath}/$_userId.json?auth=$_token',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productBody),
      );

      _favoriteItems.add(
        {
          ...productBody,
          'id': jsonDecode(response.body)['name'],
        },
      );
      for (Product product in _items) {
        if (product.id == productBody['productId']) {
          product.setFavorite = bool.parse(
            productBody['isFavorite'].toString(),
          );
        }
      }

      notifyListeners();
    } catch (_) {
      throw const HttpException(Environment.favoritesError);
    }
  }

  Future<void> removeFavoriteProduct(String id) async {
    final indexFavoriteProduct = _favoriteItems.indexWhere(
      (prod) => prod['productId'] == id,
    );

    final productIndex = _items.indexWhere(
      (prod) => prod.id == id,
    );

    if (indexFavoriteProduct >= 0) {
      final favoriteProduct = _favoriteItems[indexFavoriteProduct];

      _items[productIndex].setFavorite = false;
      _favoriteItems.removeAt(indexFavoriteProduct);

      await http.delete(
        Uri.parse(
          '${Environment.baseUrl + Environment.favoriteProductsPath}/$_userId/${favoriteProduct['id']}.json?auth=$_token',
        ),
      );

      notifyListeners();
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

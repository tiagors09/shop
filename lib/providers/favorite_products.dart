import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/environment.dart';

class FavoriteProducts with ChangeNotifier {
  final _url = Environment.baseUrl + Environment.favoriteProductsPath;
  final List<Product> _items;
  final String? _userId;
  final String? _token;

  FavoriteProducts(
    this._token,
    this._userId,
    this._items,
  );

  List<Product> get items => [..._items];

  Future<void> loadFavoriteProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_url/$_userId.json?auth=$_token'),
      );

      Map<String, dynamic> data = jsonDecode(response.body) ?? {};

      _items.clear();
      if (data.isNotEmpty || response.statusCode == HttpStatus.ok) {
        data.forEach(
          (_, productData) {
            _items.add(
              Product.fromJson(productData),
            );
            notifyListeners();
          },
        );
      }
    } catch (_) {
      throw const HttpException('Erro ao pegar os produtos favoritados');
    }
  }

  Future<void> addFavoriteProduct(Product product) async {
    try {
      await http.post(
        Uri.parse(
          '$_url/$_userId/${product.id}.json?auth=$_token',
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: product.toJSON(),
      );

      _items.add(product);
      notifyListeners();
    } catch (_) {
      throw const HttpException('Deu problema ao adicionar aos favoritos!');
    }
  }

  Future<void> removeFavoriteProduct(String id) async {
    try {
      final index = _items.indexWhere((prod) => prod.id == id);

      if (index >= 0) {
        final product = _items[index];

        await http.delete(
          Uri.parse(
            '$_url/$_userId/${product.id}.json?auth=$_token',
          ),
        );

        _items.remove(product);
        notifyListeners();
      }
    } catch (e) {
      throw const HttpException('Deu problema ao remover dos favoritos!');
    }
  }
}

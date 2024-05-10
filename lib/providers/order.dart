import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/environment.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });

  static Order fromJson(Map<String, dynamic> res) {
    return Order(
      id: res['id'],
      total: double.parse(res['total'].toString()),
      products: (res['products'] as List<dynamic>)
          .map(
            (item) => CartItem.fromJson(item),
          )
          .toList(),
      date: DateTime.parse(res['date']),
    );
  }
}

class Orders with ChangeNotifier {
  final String _url = Environment.baseUrl + Environment.ordersPath;

  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  String? _token;
  String? _userId;

  Orders(this._token, this._userId, this._items);

  Future<void> addOrder(Cart cart) async {
    try {
      final date = DateTime.now();
      final response = await http.post(
        Uri.parse(
          '$_url/$_userId.json?auth=$_token',
        ),
        body: jsonEncode(
          {
            'total': cart.totalAmount,
            'date': date.toIso8601String(),
            'products': cart.items.values
                .map((cartItem) => {
                      'id': cartItem.id,
                      'productId': cartItem.productId,
                      'title': cartItem.title,
                      'quantity': cartItem.quantity,
                      'price': cartItem.price,
                    })
                .toList()
          },
        ),
      );
      _items.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: date,
        ),
      );
      notifyListeners();
    } catch (_) {
      throw const HttpException(Environment.purchaseError);
    }
  }

  Future<void> loadOrders() async {
    try {
      List<Order> loadedItems = [];
      final response = await http.get(
        Uri.parse(
          '$_url/$_userId.json?auth=$_token',
        ),
      );

      Map<String, dynamic> data = jsonDecode(response.body) ?? {};

      _items.clear();
      if (data.isNotEmpty || response.statusCode == HttpStatus.ok) {
        data.forEach(
          (orderId, orderData) {
            loadedItems.add(
              Order.fromJson({...orderData, 'id': orderId}),
            );
          },
        );
      }

      _items = loadedItems.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw const HttpException(Environment.allTransactionsError);
    }
  }
}

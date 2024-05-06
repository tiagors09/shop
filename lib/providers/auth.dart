import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/environment.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final _url = '${Environment.signUpBaseUrl}/${Environment.webApiKey}';

  Future<void> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'emai': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      print(jsonDecode(response.body));
    } catch (e) {
      throw const HttpException('');
    }
  }
}

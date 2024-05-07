import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/environment.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Environment.authBaseUrl + urlSegment + Environment.webApiKey;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
      throw const HttpException('');
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, Environment.signUpUrlSegment);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, Environment.signInUrlSegment);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/firebase_exception.dart';
import 'package:shop/utils/environment.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Environment.authBaseUrl + urlSegment + Environment.webApiKey;

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

    final responseBody = jsonDecode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, Environment.signUpUrlSegment);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, Environment.signInUrlSegment);
  }
}

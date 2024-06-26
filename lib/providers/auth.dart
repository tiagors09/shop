import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/environment.dart';
import 'package:http/http.dart' as http;

import '../data/store.dart';

class Auth with ChangeNotifier {
  late String? _userID;
  String? _token;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth => token != null;

  String? get userId => isAuth ? _userID : null;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }

    return null;
  }

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
    } else {
      _token = responseBody['idToken'];
      _userID = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expiresIn'],
          ),
        ),
      );

      Store.saveMap(
        'userData',
        {
          'token': _token,
          'userId': _userID,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      _autoLogout();

      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, Environment.signUpUrlSegment);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, Environment.signInUrlSegment);
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userID = userData['userId'];
    _token = userData['token'];
    _expiryDate = expiryDate;

    notifyListeners();
  }

  void logout() {
    _token = null;
    _userID = null;
    _expiryDate = null;

    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }

    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }

    final timeToLogout = _expiryDate!
        .difference(
          DateTime.now(),
        )
        .inSeconds;

    _logoutTimer = Timer(
      Duration(
        seconds: timeToLogout,
      ),
      logout,
    );
  }
}

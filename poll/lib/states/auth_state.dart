import 'dart:convert';

import 'dart:io';

import 'package:flutter/widgets.dart';

import '../configs.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import '../result.dart';

class AuthState extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  late String error;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _currentUser != null;

  Future<Result<User, String>> login(String username, String password) async {
    final loginResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/login'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    if (loginResponse.statusCode == HttpStatus.ok) {
      
      _token = json.decode(loginResponse.body)['token'];
      final userResponse = await http.get(
        Uri.parse('${Configs.baseUrl}/users/me'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (userResponse.statusCode == HttpStatus.ok) {
        _currentUser = User.fromJson(json.decode(userResponse.body));
        notifyListeners();
        return Result.success(_currentUser!);    
      }
    }
    else {
      error = loginResponse.statusCode == HttpStatus.unauthorized  
      || loginResponse.statusCode == HttpStatus.badRequest ? 'Identifiants incorrects' : 'Erreur de connexion';
    }
    logout();
    return Result.failure(error);
  }

  

  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  
  Future<User?> signin(String username, String password) async {
    final signInResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/signup'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (signInResponse.statusCode == HttpStatus.created) {
        _currentUser = User.fromJson(json.decode(signInResponse.body));
        notifyListeners();
        login(username, password);
        return _currentUser;
    }

    return null;
}
}
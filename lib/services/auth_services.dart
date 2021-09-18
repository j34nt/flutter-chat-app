import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/environments.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _isAuth = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get isAuth => this._isAuth;
  set isAuth(bool value) {
    this._isAuth = value;
    notifyListeners();
  }

  //getters token statics
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.isAuth = true;
    final data = {
      'email':email,
      'password':password
    };
    final uri = Uri.parse('${Environments.apiUrl}/login');

    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.isAuth = false;
    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);


      return true;
    } else {
      return false;
    }


  }
  Future register(String name, String email, String password) async {
    this.isAuth = true;
    final data = {
      'name':name,
      'email':email,
      'password':password
    };
    final uri = Uri.parse('${Environments.apiUrl}/login/new');

    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.isAuth = false;
    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);


      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {
    final String token = await this._storage.read(key: 'token') ?? '';
    final uri = Uri.parse('${Environments.apiUrl}/login/renew');
    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token':token
      }
    );
    this.isAuth = false;
    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);


      return true;
    } else {
      this.logout();
      return false;
    }
  }


  Future _saveToken(String token) async {
    // Write value 
    await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');

  }
}
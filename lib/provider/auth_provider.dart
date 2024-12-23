import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loanmanagmentapp/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


enum AuthState {
  authenticated,
  unauthenticated,
  loading
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
    return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(): super(AuthState.loading) {
    _checkAuthState();
  }

  final _storage = const FlutterSecureStorage();

  Future<void> _checkAuthState() async {
    state = AuthState.loading;

    try {
      final token = await _storage.read(key: 'jwt_token');
      if(token != null) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> signUp(BuildContext context, String name, String email, String password) async {
    try {
      var registerUrl = Uri.parse(signUpUrl);
      var response = await http.post(registerUrl, 
        body: jsonEncode(<String, dynamic>{
          "fullName": name,
          "email": email,
          "password": password,
        }),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }
      );


      if(response.statusCode != 200) {
        throw Exception("Failed to register user");
      }


      if (!mounted) return;
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      throw Exception("Failed to register user");
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      var loginUrl = Uri.parse(logInUrl);
      var response = await http.post(loginUrl, body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }
      );


      if(response.statusCode != 200 && response.statusCode == 404) {
        throw Exception("Failed to login user");
      }

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = data['user']['_id'];

        await _storage.write(key: 'jwt_token', value: token);
        await _storage.write(key: 'user_id', value: userId);
        state = AuthState.authenticated;
      }
    } catch (e) {
      throw Exception("Failed to login user");
    }
  }

  Future<void> forgotPassword(String email, String password) async {

    try {

      final resetPasswordUrl = Uri.parse(forgotPasswordUrl);
      await http.patch(resetPasswordUrl, body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }
      );
      
    } catch (e) {
      throw Exception("Failed to reset password");
    }

  }

  Future<void> logOut() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_id');
    state = AuthState.unauthenticated;
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }
}

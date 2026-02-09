import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Par défaut utilisez une IP locale. Vous pouvez surcharger via .env (API_BASE_URL)
  static String get baseUrl {
    // URL de PRODUCTION par défaut
    String url = 'https://meetio-back.onrender.com/api';
    
    try {
      final envPath = dotenv.env['API_BASE_URL'];
      if (envPath != null && envPath.isNotEmpty) {
        url = envPath;
      }
    } catch (_) {
      // dotenv non chargé
    }

    // Fix pour l'émulateur Android (si on teste en local sur localhost/127.0.0.1)
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      if (url.contains('localhost')) {
        url = url.replaceAll('localhost', '10.0.2.2');
      } else if (url.contains('127.0.0.1')) {
        url = url.replaceAll('127.0.0.1', '10.0.2.2');
      }
    }
    
    return url;
  }

  static String? _token;

  // Headers avec token
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Sauvegarder le token
  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Charger le token depuis le stockage
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Supprimer le token (logout)
  static Future<void> deleteToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Vérifier si connecté
  static bool isLoggedIn() {
    return _token != null;
  }

  // GET request
  static Future<http.Response> get(String endpoint) async {
    await loadToken();
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
    );
  }

  // POST request
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    await loadToken();
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
  }

  // PUT request
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    await loadToken();
    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
  }

  // DELETE request
  static Future<http.Response> delete(String endpoint) async {
    await loadToken();
    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: getHeaders(),
    );
  }

  // --- User Management (Admin) ---
  
  static Future<http.Response> getUsers() async {
    return await get('users');
  }

  static Future<http.Response> updateUserRole(int userId, String role) async {
    return await put('users/$userId/role', {'role': role});
  }
}

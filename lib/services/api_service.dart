import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Par défaut utilisez une IP locale. Vous pouvez surcharger via .env (API_BASE_URL)
  static String get baseUrl {
    try {
      final env = dotenv.env['API_BASE_URL'];
      if (env != null && env.isNotEmpty) return env;
    } catch (_) {
      // dotenv not initialized yet (flutter_dotenv throws NotInitializedError on web if load wasn't called)
    }
    return 'http://localhost:8000/api';
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
}

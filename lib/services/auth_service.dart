import 'dart:convert';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  // Inscription
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await ApiService.post('register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];

        await ApiService.saveToken(token);

        return User.fromJson(userData);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Connexion
  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await ApiService.post('login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];

        await ApiService.saveToken(token);

        return User.fromJson(userData);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Erreur lors de la connexion');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Déconnexion
  Future<bool> logout() async {
    try {
      final response = await ApiService.post('logout', {});
      if (response.statusCode == 200) {
        await ApiService.deleteToken();
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur déconnexion: $e');
      return false;
    }
  }

  // Récupérer l'utilisateur courant
  Future<User?> getCurrentUser() async {
    try {
      final response = await ApiService.get('me');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Erreur récupération utilisateur: $e');
      return null;
    }
  }

  // Vérifier si connecté
  Future<bool> isLoggedIn() async {
    await ApiService.loadToken();
    return ApiService.isLoggedIn();
  }
}

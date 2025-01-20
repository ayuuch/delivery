import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Base URL du backend Laravel
  final String baseUrl = 'https://votre-api.com'; // Remplacez par votre URL backend

  /// Méthode pour connecter un utilisateur
  Future<http.Response> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero_telephone': phone, 'mot_de_passe': password}),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la tentative de connexion : $e');
    }
  }

  /// Méthode pour enregistrer un utilisateur
  Future<http.Response> register(String name, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nom': name, 'numero_telephone': phone, 'mot_de_passe': password}),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la tentative d\'inscription : $e');
    }
  }

  /// Méthode pour envoyer un OTP de réinitialisation
  Future<http.Response> sendResetOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero_telephone': phone}),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'OTP : $e');
    }
  }

  /// Méthode pour réinitialiser un mot de passe
  Future<http.Response> resetPassword(String phone, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_telephone': phone,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPassword,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la tentative de réinitialisation du mot de passe : $e');
    }
  }

  /// Méthode pour envoyer la localisation GPS de l'utilisateur
  Future<http.Response> sendLocation(double latitude, double longitude, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save-location'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de la localisation : $e');
    }
  }

  /// Méthode pour vérifier un OTP
  Future<http.Response> verifyOtp(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero_telephone': phone, 'otp': otp}),
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la vérification de l\'OTP : $e');
    }
  }
}

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _androidLocalhost = "http://10.0.2.2:8000"; // Android emulator localhost
const _hostLocal = "http://127.0.0.1:8000";
final baseUrl = kIsWeb
    ? _hostLocal
    : (Platform.isAndroid ? _androidLocalhost : _hostLocal);

class ApiService {
  /// Save JWT token locally
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  /// Retrieve JWT token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// Login user and store JWT
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data["access_token"];
      if (token != null) {
        await _saveToken(token);
        return true;
      } else {
        print('Login response missing access_token: ${res.body}');
      }
    } else {
      print('Login failed: ${res.statusCode} ${res.body}');
    }
    return false;
  }

  /// Add a new contact (requires JWT)
  static Future<bool> addContact(String name, String phone) async {
    final token = await _getToken();
    if (token == null) return false;

    final res = await http.post(
      Uri.parse("$baseUrl/contacts/add"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "phone": phone}),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      print('addContact failed: ${res.statusCode} ${res.body}');
      return false;
    }
  }

  /// Get contacts list (requires JWT)
  static Future<List<dynamic>> listContacts() async {
    final token = await _getToken();
    if (token == null) return [];

    final res = await http.get(
      Uri.parse("$baseUrl/contacts/list"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["contacts"] ?? [];
    } else {
      print('listContacts failed: ${res.statusCode} ${res.body}');
    }
    return [];
  }

  /// Logout (clear JWT)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}

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
  static Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["access_token"]);
      return true;
    }
    return false;
  }

  static Future<List> getContacts() async {
    final token = await _token();
    final res = await http.get(
      Uri.parse("$baseUrl/contacts/list"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["contacts"] ?? [];
    } else {
      print('getContacts failed: ${res.statusCode} ${res.body}');
    }
    return [];
  }

  static Future<bool> addContact(String name, String phone) async {
    final token = await _token();
    final res = await http.post(
      Uri.parse("$baseUrl/contacts/add"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "phone": phone}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) return true;
    print('addContact failed: ${res.statusCode} ${res.body}');
    return false;
  }

  static Future<List> getCampaigns() async {
    final token = await _token();
    final res = await http.get(
      Uri.parse("$baseUrl/campaigns"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  static Future<int> todayUsage() async {
    final token = await _token();
    final res = await http.get(
      Uri.parse("$baseUrl/usage/today"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body)["count"];
  }

  static Future<void> incrementUsage() async {
    final token = await _token();
    await http.post(
      Uri.parse("$baseUrl/usage/increment"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}

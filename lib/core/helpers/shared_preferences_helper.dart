import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilik_desa/data/model/response/admin/dashboard_admin_response_model.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _adminUserKey = 'admin_user';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_adminUserKey);
  }

  static Future<void> saveAdminUser(AdminUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminUserKey, json.encode(user.toMap()));
  }

  static Future<AdminUser?> getAdminUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_adminUserKey);
    if (userString != null) {
      return AdminUser.fromMap(json.decode(userString));
    }
    return null;
  }
}
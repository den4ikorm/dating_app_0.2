import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const String baseUrl = 'https://your-app.railway.app/api';

  String? _token;
  Map<String, dynamic>? _user;

  String?              get token    => _token;
  Map<String, dynamic>? get user   => _user;
  bool                 get isLoggedIn => _token != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final u = prefs.getString('auth_user');
    if (u != null) _user = jsonDecode(u);
    notifyListeners();
  }

  // ── Регистрация + загрузка фото одним multipart запросом ─────────────────
  Future<Map<String, dynamic>> register({
    required String  email,
    required String  password,
    required String  name,
    required int     age,
    required String  gender,
    String?          city,
    String?          bio,
    File?            photo,        // ← новое поле
  }) async {
    try {
      // Multipart — чтобы передать и данные и файл
      final request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/auth/register'),
      );

      request.fields['email']    = email;
      request.fields['password'] = password;
      request.fields['name']     = name;
      request.fields['age']      = age.toString();
      request.fields['gender']   = gender;
      if (city != null && city.isNotEmpty) request.fields['city'] = city;
      if (bio  != null && bio.isNotEmpty)  request.fields['bio']  = bio;

      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo', photo.path,
          // filename подставится автоматически
        ));
      }

      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final body     = await streamed.stream.bytesToString();
      final data     = jsonDecode(body) as Map<String, dynamic>;

      if (streamed.statusCode == 201) {
        await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
        return {'success': true};
      }
      return {'success': false, 'error': data['error'] ?? 'Ошибка регистрации'};
    } catch (e) {
      return {'success': false, 'error': 'Нет соединения с сервером'};
    }
  }

  // ── Вход ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if (resp.statusCode == 200) {
        await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
        return {'success': true};
      }
      return {'success': false, 'error': data['error'] ?? 'Неверный email или пароль'};
    } catch (_) {
      return {'success': false, 'error': 'Нет соединения с сервером'};
    }
  }

  // ── Выход ──────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');
    _token = null;
    _user  = null;
    notifyListeners();
  }

  Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_user',  jsonEncode(user));
    _token = token;
    _user  = user;
    notifyListeners();
  }

  Map<String, String> get authHeaders => {
    'Content-Type':  'application/json',
    'Authorization': 'Bearer $_token',
  };
}

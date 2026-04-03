import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ApiService {
  static const String voxmeUrl      = 'https://voxme.fun';
  static const String randomUserUrl = 'https://randomuser.me/api';
  // TODO: замените на Railway URL после деплоя
  // static const String backendUrl = 'https://your-app.railway.app/api';

  // ── Главная лента: voxme данные + randomuser фото ─────────────────────────
  static Future<List<UserProfile>> fetchProfiles() async {
    // Запрашиваем параллельно: voxme данные и фото с randomuser
    final voxmeFutures = List.generate(8, (_) => _fetchVoxme());
    final photosFuture = _fetchRandomPhotos(8);

    final voxmeResults = await Future.wait(voxmeFutures);
    final photos       = await photosFuture;

    // Убираем дубли voxme по id
    final seen     = <int>{};
    final voxme    = <Map<String, dynamic>>[];
    for (final v in voxmeResults) {
      if (v != null && seen.add(v['id'] as int)) voxme.add(v);
    }

    if (voxme.isEmpty) return UserProfile.mockList();

    // Склеиваем: voxme[i] + photos[i]
    return List.generate(voxme.length, (i) {
      final photo = i < photos.length ? photos[i] : null;
      return UserProfile.fromVoxmeWithPhoto(voxme[i], photo);
    });
  }

  // ── randomuser.me — получить N фото ──────────────────────────────────────
  static Future<List<RandomPhoto>> _fetchRandomPhotos(int count) async {
    try {
      final uri = Uri.parse(
        '$randomUserUrl/?results=$count&nat=ru,ua,by,de,fr&inc=picture,gender&noinfo',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return [];

      final data   = jsonDecode(resp.body) as Map;
      final results = data['results'] as List;
      return results.map((r) => RandomPhoto(
        large:    r['picture']['large']  as String,
        medium:   r['picture']['medium'] as String,
        gender:   r['gender'] as String,
      )).toList();
    } catch (_) {
      return [];
    }
  }

  // ── voxme.fun/random ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> _fetchVoxme() async {
    try {
      final resp = await http
          .get(Uri.parse('$voxmeUrl/random'))
          .timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body);
        if (data.isNotEmpty) return data[0] as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> sendLike(int userId)    async => true;
  static Future<bool> sendDislike(int userId) async => true;
}

class RandomPhoto {
  final String large;
  final String medium;
  final String gender;
  const RandomPhoto({required this.large, required this.medium, required this.gender});
}

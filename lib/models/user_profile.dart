import '../services/api_service.dart';

class UserProfile {
  final int    id;
  final String name;
  final int    age;
  final String city;
  final String photoUrl;
  final String bio;
  final String gender;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.photoUrl,
    required this.bio,
    this.gender = '',
  });

  // ── voxme + randomuser фото ───────────────────────────────────────────────
  factory UserProfile.fromVoxmeWithPhoto(
    Map<String, dynamic> voxme,
    RandomPhoto? photo,
  ) {
    final id   = voxme['id']   as int?    ?? 0;
    final name = voxme['name'] as String? ?? 'Аноним';
    final age  = voxme['age']  as int?    ?? 20;
    final city = voxme['city'] as String? ?? '';

    // Фото: реальное с randomuser или инициал-аватар
    final colors = ['7b2fff','e91e8c','00c9ff','ff6b6b','4ecdc4','f7dc6f'];
    final fallback =
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name[0])}'
        '&background=${colors[id % colors.length]}&color=fff&size=600&bold=true&font-size=0.4';

    return UserProfile(
      id:       id,
      name:     name,
      age:      age,
      city:     city,
      photoUrl: photo?.large ?? voxme['photo'] as String? ?? fallback,
      bio:      voxme['bio'] as String? ?? '',
      gender:   photo?.gender ?? '',
    );
  }

  // ── Свой бэкенд ───────────────────────────────────────────────────────────
  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    id:       j['id']   as int,
    name:     j['name'] as String,
    age:      j['age']  as int,
    city:     j['city'] as String?     ?? '',
    photoUrl: j['photo'] as String?    ?? '',
    bio:      j['bio']  as String?     ?? '',
    gender:   j['gender'] as String?   ?? '',
  );

  // ── Мок-данные (если всё упало) ───────────────────────────────────────────
  static List<UserProfile> mockList() => const [
    UserProfile(id:1, name:'Марина',  age:25, city:'Москва', gender:'female',
      photoUrl:'https://randomuser.me/api/portraits/women/44.jpg', bio:''),
    UserProfile(id:2, name:'Дмитрий', age:28, city:'СПб',    gender:'male',
      photoUrl:'https://randomuser.me/api/portraits/men/32.jpg',   bio:''),
    UserProfile(id:3, name:'Анна',    age:23, city:'Казань',  gender:'female',
      photoUrl:'https://randomuser.me/api/portraits/women/68.jpg', bio:''),
    UserProfile(id:4, name:'Максим',  age:27, city:'Пенза',   gender:'male',
      photoUrl:'https://randomuser.me/api/portraits/men/55.jpg',   bio:''),
  ];
}

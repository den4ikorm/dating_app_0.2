# 💫 Dating App — Flutter прототип

Технодемо приложения для знакомств. 3 экрана, REST API, свайп-карточки.

## Скриншот
> Левый экран: свайп-карточки с аудио  
> Правый экран: чаты и матчи

---

## Структура
```
lib/
├── main.dart                 # Точка входа, нижняя навигация
├── models/
│   └── user_profile.dart     # Модель пользователя
├── services/
│   └── api_service.dart      # REST API запросы
└── screens/
    ├── match_screen.dart     # Главный экран (свайп)
    ├── chats_screen.dart     # Чаты
    └── profile_screen.dart   # Профиль (заглушка)
```

---

## Запуск локально

### 1. Установить Flutter
```bash
# macOS
brew install flutter

# или скачать: https://flutter.dev/docs/get-started/install
```

### 2. Клонировать и запустить
```bash
git clone https://github.com/YOUR_USERNAME/dating_app.git
cd dating_app
flutter pub get
flutter run
```

### 3. Собрать APK
```bash
flutter build apk --release
# APK будет в: build/app/outputs/flutter-apk/app-release.apk
```

---

## Подключить свой API

Открыть `lib/services/api_service.dart` и заменить:
```dart
static const String _baseUrl = 'https://your-api.com/api';
```

### Ожидаемый формат JSON (GET /matches):
```json
[
  {
    "id": 1,
    "name": "Марина",
    "age": 25,
    "city": "Москва",
    "photo": "https://example.com/photo.jpg",
    "bio": "Люблю природу и кофе",
    "audio": "https://example.com/audio.mp3"
  }
]
```

> Если API недоступен — приложение автоматически использует моковые данные.

---

## Сборка APK через Google Colab

Открыть файл `colab_build.ipynb` в Google Colab и запустить все ячейки.  
На выходе автоматически скачается `app-release.apk`.

---

## Зависимости
```yaml
http: ^1.2.0
cached_network_image: ^3.3.1
```

---

## TODO (следующие итерации)
- [ ] Экран авторизации / регистрации
- [ ] Реальный аудиоплеер
- [ ] Полноценный чат с сообщениями
- [ ] Push-уведомления
- [ ] Загрузка фото профиля

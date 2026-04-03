# 🐙 Загрузка на GitHub — пошаговая инструкция

## Вариант 1: Через браузер (самый простой)

1. Зайти на https://github.com → **Sign in**
2. Нажать кнопку **"+"** → **"New repository"**
3. Название: `dating_app`
4. Описание: `Flutter dating app prototype`
5. Выбрать **Public** или **Private**
6. **НЕ** ставить галочку "Add README" (он уже есть)
7. Нажать **"Create repository"**

---

## Вариант 2: Через Git (командная строка)

```bash
# 1. Перейти в папку проекта
cd dating_app

# 2. Инициализировать git
git init

# 3. Добавить все файлы
git add .

# 4. Первый коммит
git commit -m "Initial dating app prototype"

# 5. Подключить GitHub репозиторий
#    (заменить YOUR_USERNAME на ваш логин)
git remote add origin https://github.com/YOUR_USERNAME/dating_app.git

# 6. Отправить код
git branch -M main
git push -u origin main
```

---

## Вариант 3: GitHub Desktop (графический интерфейс)

1. Скачать: https://desktop.github.com
2. Войти в аккаунт
3. **File** → **Add Local Repository** → выбрать папку `dating_app`
4. **Publish repository** → выбрать имя → Publish

---

## После загрузки — сборка APK в Colab:

1. Открыть https://colab.research.google.com
2. **File** → **Upload notebook** → загрузить `colab_build.ipynb`
3. В ячейке Шаг 4 заменить:
   ```python
   REPO_URL = 'https://github.com/YOUR_USERNAME/dating_app.git'
   ```
4. **Runtime** → **Run all** (Ctrl+F9)
5. Подождать ~10 минут → APK скачается автоматически

---

## Структура репозитория на GitHub
```
dating_app/
├── lib/
│   ├── main.dart
│   ├── models/user_profile.dart
│   ├── services/api_service.dart
│   └── screens/
│       ├── match_screen.dart
│       ├── chats_screen.dart
│       └── profile_screen.dart
├── pubspec.yaml
├── colab_build.ipynb    ← для сборки APK
├── .gitignore
└── README.md
```

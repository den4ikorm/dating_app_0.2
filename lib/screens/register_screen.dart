import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int     _step    = 0;
  bool    _loading = false;
  String? _error;

  // Шаг 0 — имя, возраст, пол
  final _nameCtrl = TextEditingController();
  final _ageCtrl  = TextEditingController();
  String _gender  = 'female';

  // Шаг 1 — фото
  File?  _photo;
  bool   _photoLoading = false;

  // Шаг 2 — email, пароль, город, о себе
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _cityCtrl  = TextEditingController();
  final _bioCtrl   = TextEditingController();
  bool  _obscure   = true;

  // ── Выбор фото ─────────────────────────────────────────────────────────────
  Future<void> _pickPhoto(ImageSource source) async {
    setState(() => _photoLoading = true);
    try {
      final picker = ImagePicker();
      final xfile  = await picker.pickImage(
        source:    source,
        imageQuality: 85,
        maxWidth:  800,
        maxHeight: 1000,
      );
      if (xfile != null) setState(() => _photo = File(xfile.path));
    } catch (_) {
      setState(() => _error = 'Не удалось открыть галерею');
    } finally {
      setState(() => _photoLoading = false);
    }
  }

  void _showPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF00c9ff)),
            title: const Text('Сделать фото', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); _pickPhoto(ImageSource.camera); },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF7b2fff)),
            title: const Text('Выбрать из галереи', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); _pickPhoto(ImageSource.gallery); },
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  // ── Навигация по шагам ─────────────────────────────────────────────────────
  Future<void> _next() async {
    setState(() => _error = null);

    if (_step == 0) {
      if (_nameCtrl.text.trim().length < 2) {
        setState(() => _error = 'Введите имя (минимум 2 символа)'); return;
      }
      final age = int.tryParse(_ageCtrl.text);
      if (age == null || age < 18 || age > 99) {
        setState(() => _error = 'Возраст от 18 до 99'); return;
      }
      setState(() => _step = 1);
      return;
    }

    if (_step == 1) {
      // Фото необязательно — можно пропустить
      setState(() => _step = 2);
      return;
    }

    // Шаг 2 — финальная регистрация
    if (!_emailCtrl.text.contains('@')) {
      setState(() => _error = 'Введите корректный email'); return;
    }
    if (_passCtrl.text.length < 6) {
      setState(() => _error = 'Пароль минимум 6 символов'); return;
    }

    setState(() => _loading = true);

    final result = await context.read<AuthService>().register(
      email:    _emailCtrl.text.trim(),
      password: _passCtrl.text,
      name:     _nameCtrl.text.trim(),
      age:      int.parse(_ageCtrl.text),
      gender:   _gender,
      city:     _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : null,
      bio:      _bioCtrl.text.trim().isNotEmpty  ? _bioCtrl.text.trim()  : null,
      photo:    _photo,
    );

    if (!mounted) return;
    setState(() => _loading = false);
    if (!result['success']) setState(() => _error = result['error']);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final titles = ['О себе', 'Фото профиля', 'Аккаунт'];
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f0f18),
        elevation: 0,
        leading: IconButton(
          icon: Icon(_step > 0 ? Icons.arrow_back : Icons.close, color: Colors.white),
          onPressed: _step > 0
              ? () => setState(() { _step--; _error = null; })
              : () => Navigator.pop(context),
        ),
        title: Text('${_step + 1}/3 · ${titles[_step]}',
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_step + 1) / 3,
                backgroundColor: const Color(0xFF2a2a3e),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF7b2fff)),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 32),

            if (_step == 0) _step0(),
            if (_step == 1) _step1(),
            if (_step == 2) _step2(),

            if (_error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFf87171).withOpacity(.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: const TextStyle(color: Color(0xFFf87171), fontSize: 13)),
              ),
            ],

            const SizedBox(height: 28),
            _nextButton(titles),
          ]),
        ),
      ),
    );
  }

  // ── Шаг 0: имя, возраст, пол ───────────────────────────────────────────────
  Widget _step0() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Как вас зовут?',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
    const SizedBox(height: 6),
    const Text('Это увидят другие', style: TextStyle(color: Colors.white38, fontSize: 13)),
    const SizedBox(height: 24),
    _field(_nameCtrl, 'Имя', Icons.person_outline),
    const SizedBox(height: 14),
    _field(_ageCtrl, 'Возраст', Icons.cake_outlined, type: TextInputType.number),
    const SizedBox(height: 20),
    const Text('Я —', style: TextStyle(color: Colors.white70, fontSize: 15)),
    const SizedBox(height: 10),
    Wrap(spacing: 10, children: [
      _chip('female', '👩 Женщина'),
      _chip('male',   '👨 Мужчина'),
      _chip('other',  '🧑 Другое'),
    ]),
  ]);

  // ── Шаг 1: фото ────────────────────────────────────────────────────────────
  Widget _step1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Добавьте фото',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
    const SizedBox(height: 6),
    const Text('Можно пропустить и добавить позже',
        style: TextStyle(color: Colors.white38, fontSize: 13)),
    const SizedBox(height: 32),

    Center(
      child: GestureDetector(
        onTap: _showPhotoSheet,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 220, height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _photo != null ? const Color(0xFF7b2fff) : const Color(0xFF2a2a3e),
              width: 2,
            ),
            color: const Color(0xFF1a1a2e),
          ),
          child: _photoLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF7b2fff)))
              : _photo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(_photo!, fit: BoxFit.cover,
                          width: double.infinity, height: double.infinity),
                    )
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7b2fff), Color(0xFF00c9ff)],
                          ),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 16),
                      const Text('Нажмите чтобы\nдобавить фото',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 14)),
                    ]),
        ),
      ),
    ),

    const SizedBox(height: 20),
    if (_photo != null)
      Center(
        child: TextButton.icon(
          icon: const Icon(Icons.refresh, color: Color(0xFF00c9ff), size: 18),
          label: const Text('Изменить фото', style: TextStyle(color: Color(0xFF00c9ff))),
          onPressed: _showPhotoSheet,
        ),
      ),
  ]);

  // ── Шаг 2: email, пароль, город, о себе ───────────────────────────────────
  Widget _step2() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Создайте аккаунт',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
    const SizedBox(height: 24),
    _field(_emailCtrl, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
    const SizedBox(height: 14),
    _field(_passCtrl, 'Пароль', Icons.lock_outline, obscure: _obscure,
      suffix: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.white38),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    ),
    const SizedBox(height: 14),
    _field(_cityCtrl, 'Город (необязательно)', Icons.location_on_outlined),
    const SizedBox(height: 14),
    TextField(
      controller: _bioCtrl,
      maxLines: 3, maxLength: 300,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'О себе (необязательно)',
        labelStyle: const TextStyle(color: Colors.white38),
        filled: true, fillColor: const Color(0xFF1a1a2e),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7b2fff), width: 1.5)),
        counterStyle: const TextStyle(color: Colors.white24),
      ),
    ),
  ]);

  // ── Кнопка далее/создать ───────────────────────────────────────────────────
  Widget _nextButton(List<String> titles) => SizedBox(
    width: double.infinity,
    child: _loading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF00c9ff)))
        : Column(children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF7b2fff), Color(0xFF00c9ff)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                onPressed: _next,
                child: Text(_step < 2 ? 'Далее →' : 'Создать аккаунт',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            // Шаг фото — можно пропустить
            if (_step == 1) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() { _step = 2; _error = null; }),
                child: const Text('Пропустить →',
                    style: TextStyle(color: Colors.white38, fontSize: 14)),
              ),
            ],
          ]),
  );

  // ── Хелперы ────────────────────────────────────────────────────────────────
  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {TextInputType? type, bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: ctrl, keyboardType: type, obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffix,
        filled: true, fillColor: const Color(0xFF1a1a2e),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7b2fff), width: 1.5)),
      ),
    );
  }

  Widget _chip(String value, String label) {
    final sel = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: sel ? const LinearGradient(colors: [Color(0xFF7b2fff), Color(0xFF00c9ff)]) : null,
          color: sel ? null : const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sel ? Colors.transparent : const Color(0xFF2a2a3e)),
        ),
        child: Text(label, style: TextStyle(
            color: sel ? Colors.white : Colors.white54,
            fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}

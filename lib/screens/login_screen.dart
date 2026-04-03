import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });

    final result = await context.read<AuthService>().login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);
    if (!result['success']) {
      setState(() => _error = result['error']);
    }
    // Если success — Provider пересоберёт дерево через notifyListeners
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Center(
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Color(0xFFe91e8c), Color(0xFF00c9ff)],
                  ).createShader(b),
                  child: const Text(
                    '💫 Знакомства',
                    style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Найди своего человека',
                    style: TextStyle(color: Colors.white54, fontSize: 14)),
              ),
              const SizedBox(height: 48),

              const Text('Войти', style: TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),

              // Email
              _field(
                controller: _emailCtrl,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              // Password
              _field(
                controller: _passCtrl,
                label: 'Пароль',
                icon: Icons.lock_outline,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.white38,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 10),

              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf87171).withOpacity(.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFf87171).withOpacity(.4)),
                  ),
                  child: Text(_error!,
                      style: const TextStyle(color: Color(0xFFf87171), fontSize: 13)),
                ),

              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00c9ff)))
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7b2fff), Color(0xFF00c9ff)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _login,
                          child: const Text('Войти',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Divider
              Row(children: [
                const Expanded(child: Divider(color: Color(0xFF2a2a3e))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('или', style: TextStyle(color: Colors.white.withOpacity(.3))),
                ),
                const Expanded(child: Divider(color: Color(0xFF2a2a3e))),
              ]),
              const SizedBox(height: 20),

              // Google button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF2a2a3e), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Text('G', style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 18,
                      color: Color(0xFFe91e8c))),
                  label: const Text('Войти через Google'),
                  onPressed: () {
                    // Deep link откроет браузер с OAuth Google
                    // Реализация через url_launcher пакет:
                    // launchUrl(Uri.parse('${AuthService.baseUrl}/auth/google'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google OAuth: настройте GOOGLE_CLIENT_ID в .env'),
                        backgroundColor: Color(0xFF7b2fff),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Нет аккаунта?',
                      style: TextStyle(color: Colors.white54)),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text('Зарегистрироваться',
                        style: TextStyle(
                            color: Color(0xFF00c9ff), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF1a1a2e),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7b2fff), width: 1.5),
        ),
      ),
    );
  }
}

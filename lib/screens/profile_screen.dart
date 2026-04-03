import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f0f18),
        elevation: 0,
        title: const Text('Профиль',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7b2fff), width: 3),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person,
                    color: Colors.white30,
                    size: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Алексей, 27',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: Colors.white54),
                const SizedBox(width: 4),
                Text('Москва · В поиске ✨',
                    style: TextStyle(
                        color: Colors.white.withOpacity(.5), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                _statCard('47', 'Лайков'),
                const SizedBox(width: 10),
                _statCard('12', 'Матчей'),
                const SizedBox(width: 10),
                _statCard('4', 'Чатов'),
              ],
            ),
            const SizedBox(height: 16),

            // Stubs
            _stubCard('🖊️  Редактировать профиль'),
            const SizedBox(height: 10),
            _stubCard('🔔  Настройки уведомлений'),
            const SizedBox(height: 10),
            _stubCard('🔒  Приватность'),
            const SizedBox(height: 10),
            _stubCard('💎  Премиум подписка'),
            const SizedBox(height: 24),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
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
                  onPressed: () {},
                  child: const Text('Редактировать профиль',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String num, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(num,
                style: const TextStyle(
                    color: Color(0xFF00c9ff),
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _stubCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600))),
          const Icon(Icons.chevron_right, color: Colors.white30),
        ],
      ),
    );
  }
}

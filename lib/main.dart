import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Auth imports removed for demo bypass
import 'screens/match_screen.dart';
import 'screens/chats_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  // App initialization without AuthService provider
  runApp(const DatingApp());
}

class DatingApp extends StatelessWidget {
  const DatingApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Знакомства',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0f0f18),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7b2fff), secondary: Color(0xFF00c9ff),
        ),
      ),
      // Forced bypass directly to MainShell
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  static const _screens = [MatchScreen(), _QuickStub(), ChatsScreen(), ProfileScreen()];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0f0f18),
          border: Border(top: BorderSide(color: Color(0xFF1e1e30), width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(children: [
              _navItem(0, Icons.favorite, Icons.favorite_border, 'Знакомства'),
              _navItem(1, Icons.bolt, Icons.bolt_outlined, 'Быстрые'),
              _navItem(2, Icons.chat_bubble, Icons.chat_bubble_outline, 'Чаты'),
              _navItem(3, Icons.person, Icons.person_outline, 'Профиль'),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int idx, IconData active, IconData inactive, String label) {
    final isActive = _index == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? active : inactive,
                color: isActive ? const Color(0xFF00c9ff) : Colors.white30, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(
              color: isActive ? const Color(0xFF00c9ff) : Colors.white30,
              fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _QuickStub extends StatelessWidget {
  const _QuickStub();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      appBar: AppBar(backgroundColor: const Color(0xFF0f0f18), elevation: 0,
          title: const Text('Быстрые', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20))),
      body: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.bolt, color: Color(0xFF7b2fff), size: 64),
        SizedBox(height: 16),
        Text('Быстрые знакомства', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('— скоро —', style: TextStyle(color: Colors.white30, fontSize: 14)),
      ])),
    );
  }
}

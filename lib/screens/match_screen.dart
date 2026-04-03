import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import 'dart:math';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  List<UserProfile> _profiles = [];
  int _currentIndex = 0;
  bool _loading = true;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _loadProfiles();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    final profiles = await ApiService.fetchProfiles();
    setState(() {
      _profiles = profiles;
      _loading = false;
    });
  }

  void _swipe(String direction) async {
    if (_currentIndex >= _profiles.size) return;
    final profile = _profiles[_currentIndex];

    if (direction == 'right') {
      await ApiService.sendLike(profile.id);
      if (Random().nextBool()) _showMatch(profile);
    } else {
      await ApiService.sendDislike(profile.id);
    }

    setState(() {
      _dragOffset = Offset.zero;
      _currentIndex++;
    });
  }

  void _showMatch(UserProfile profile) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1a0a3a), Color(0xFF0d1a4a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFe91e8c), Color(0xFF00c9ff)],
                ).createShader(bounds),
                child: const Text(
                  'MATCH! 💫',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _matchFace(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                    const Color(0xFF00c9ff),
                  ),
                  const SizedBox(width: 16),
                  _matchFace(profile.photoUrl, const Color(0xFFe91e8c)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Вы понравились друг другу!',
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7b2fff),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Написать сообщение',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Продолжить',
                    style: TextStyle(color: Colors.white.withOpacity(.4))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _matchFace(String url, Color borderColor) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 3),
      ),
      child: ClipOval(
        child: Image.network(url, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: Colors.grey.shade800)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f0f18),
        elevation: 0,
        title: const Text(
          'Знакомства',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00c9ff)))
          : _currentIndex >= _profiles.length
              ? _noMoreCards()
              : _buildCardStack(),
    );
  }

  Widget _noMoreCards() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, color: Color(0xFF7b2fff), size: 64),
          const SizedBox(height: 16),
          const Text('Новые анкеты скоро появятся!',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7b2fff),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            child: const Text('Начать снова'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Behind card
              if (_currentIndex + 1 < _profiles.length)
                Transform.scale(
                  scale: 0.94,
                  child: Transform.translate(
                    offset: const Offset(0, 16),
                    child: _buildCard(_profiles[_currentIndex + 1],
                        isFront: false),
                  ),
                ),
              // Front card
              GestureDetector(
                onPanStart: (_) => setState(() => _isDragging = true),
                onPanUpdate: (d) =>
                    setState(() => _dragOffset += d.delta),
                onPanEnd: (_) {
                  setState(() => _isDragging = false);
                  if (_dragOffset.dx > 80) {
                    _swipe('right');
                  } else if (_dragOffset.dx < -80) {
                    _swipe('left');
                  } else {
                    setState(() => _dragOffset = Offset.zero);
                  }
                },
                child: Transform.translate(
                  offset: _dragOffset,
                  child: Transform.rotate(
                    angle: _dragOffset.dx * 0.001,
                    child: _buildCard(_profiles[_currentIndex], isFront: true),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildActionRow(),
      ],
    );
  }

  Widget _buildCard(UserProfile profile, {required bool isFront}) {
    final swipePercent = (_dragOffset.dx.abs() / 120).clamp(0.0, 1.0);
    final isRight = _dragOffset.dx > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Photo
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.58,
              child: Image.network(
                profile.photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: const Color(0xFF1a1a2e),
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF00c9ff))),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1a1a2e),
                  child: const Icon(Icons.person, color: Colors.white30, size: 80),
                ),
              ),
            ),
            // Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.name}, ${profile.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(profile.city,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Audio bar
                    _buildAudioBar(),
                  ],
                ),
              ),
            ),
            // LIKE / NOPE labels
            if (isFront && _isDragging) ...[
              if (isRight)
                Positioned(
                  top: 24,
                  right: 20,
                  child: Opacity(
                    opacity: swipePercent,
                    child: Transform.rotate(
                      angle: 0.26,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF4ade80), width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ЛАЙК',
                            style: TextStyle(
                                color: Color(0xFF4ade80),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                      ),
                    ),
                  ),
                ),
              if (!isRight)
                Positioned(
                  top: 24,
                  left: 20,
                  child: Opacity(
                    opacity: swipePercent,
                    child: Transform.rotate(
                      angle: -0.26,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFf87171), width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('NOPE',
                            style: TextStyle(
                                color: Color(0xFFf87171),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAudioBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 32,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  20,
                  (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: (i % 3 == 0 ? 28 : i % 2 == 0 ? 18 : 12)
                          .toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('00:21',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _circleBtn(
            size: 46,
            color: const Color(0xFF1e1e30),
            icon: Icons.replay,
            iconColor: Colors.white54,
            onTap: () {
              if (_currentIndex > 0) {
                setState(() => _currentIndex--);
              }
            },
          ),
          const SizedBox(width: 16),
          _circleBtn(
            size: 62,
            gradient: const LinearGradient(
              colors: [Color(0xFFf87171), Color(0xFFe91e8c)],
            ),
            icon: Icons.close,
            iconColor: Colors.white,
            iconSize: 28,
            onTap: () => _swipe('left'),
          ),
          const SizedBox(width: 16),
          _circleBtn(
            size: 46,
            color: const Color(0xFF1e1e30),
            icon: Icons.mic_none,
            iconColor: Colors.white54,
            onTap: () {},
          ),
          const SizedBox(width: 16),
          _circleBtn(
            size: 62,
            gradient: const LinearGradient(
              colors: [Color(0xFF00c9ff), Color(0xFF7b2fff)],
            ),
            icon: Icons.favorite,
            iconColor: Colors.white,
            iconSize: 28,
            onTap: () => _swipe('right'),
          ),
          const SizedBox(width: 16),
          _circleBtn(
            size: 46,
            color: const Color(0xFF1e1e30),
            icon: Icons.visibility_off_outlined,
            iconColor: Colors.white54,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _circleBtn({
    required double size,
    Color? color,
    Gradient? gradient,
    required IconData icon,
    required Color iconColor,
    double iconSize = 22,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}

extension on List {
  int get size => length;
}

import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const _impulseAvatars = [
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
  ];

  static const _chats = [
    {
      'name': 'Надя',
      'preview': 'Есть новое сообщение',
      'isNew': true,
      'badge': 1,
      'img': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    },
    {
      'name': 'ashley21',
      'preview': 'Ты ответил(а)',
      'isNew': false,
      'badge': 0,
      'img': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200',
    },
    {
      'name': 'Мария',
      'preview': 'Ты ответил(а)',
      'isNew': false,
      'badge': 0,
      'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    },
    {
      'name': 'Ольга',
      'preview': 'Ты ответил(а) ✓',
      'isNew': false,
      'badge': 0,
      'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f18),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f0f18),
        elevation: 0,
        title: const Text('Чаты',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Impulse block
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a0a3a), Color(0xFF0d1a4a)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Импульс',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(width: 6),
                    Icon(Icons.info_outline,
                        size: 14, color: Colors.white.withOpacity(.4)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _impulseAvatars.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i == 3
                              ? const Color(0xFF00c9ff)
                              : const Color(0xFF7b2fff),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(_impulseAvatars[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey.shade800)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // New pairs
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Row(
              children: [
                const Text('Новые пары',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const SizedBox(width: 6),
                Icon(Icons.info_outline,
                    size: 14, color: Colors.white.withOpacity(.4)),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Likes bubble
                _matchItem(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF00c9ff), Color(0xFF7b2fff)],
                      ),
                    ),
                    child: const Center(
                      child: Text('123',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16)),
                    ),
                  ),
                  label: 'Лайков',
                ),
                const SizedBox(width: 12),
                ..._chats.take(2).map((c) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _matchItem(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF00c9ff), width: 2),
                          ),
                          child: ClipOval(
                            child: Image.network(c['img'] as String,
                                fit: BoxFit.cover),
                          ),
                        ),
                        label: c['name'] as String,
                      ),
                    )),
                _matchItem(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.07),
                    ),
                    child: const Icon(Icons.person_outline,
                        color: Colors.white30),
                  ),
                  label: '—',
                ),
              ],
            ),
          ),

          // Chats list
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 8),
            child: Text('Чаты',
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ),
          ..._chats.map((c) => _chatItem(context, c)),
        ],
      ),
    );
  }

  Widget _matchItem({required Widget child, required String label}) {
    return Column(
      children: [
        child,
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _chatItem(BuildContext context, Map c) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 54,
                    height: 54,
                    child: Image.network(c['img'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade800)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['name'] as String,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(c['preview'] as String,
                          style: TextStyle(
                            color: (c['isNew'] as bool)
                                ? const Color(0xFFe91e8c)
                                : Colors.white38,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                if ((c['badge'] as int) > 0)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00c9ff),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${c['badge']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Divider(
            color: Color(0xFF1e1e30), height: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}

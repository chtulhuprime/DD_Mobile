import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final String name;
  final int level;
  final int currentHp;
  final int maxHp;

  const CharacterCard({
    super.key,
    required this.name,
    required this.level,
    required this.currentHp,
    required this.maxHp,
  });

  double get hpPercentage => currentHp / maxHp;

  Color get hpColor {
    if (hpPercentage > 0.6) return Colors.green;
    if (hpPercentage > 0.3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Обработка нажатия на карточку
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                // Основная информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Имя и уровень
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 4),
                          Text(
                            'Уровень: $level',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Прогресс бар здоровья
                      LinearProgressIndicator(
                        value: hpPercentage,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        color: hpColor,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      const SizedBox(height: 4),
                      // Числовое значение HP
                      Text(
                        'HP: $currentHp/$maxHp',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
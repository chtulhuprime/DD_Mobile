import 'package:flutter/material.dart';

import '../../models/character.dart';

class InteractiveMapScreen extends StatefulWidget {
  final Character character;

  const InteractiveMapScreen({super.key, required this.character});

  @override
  _InteractiveMapScreenState createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final int _mapSize = 50;
  final double _cellSize = 50.0;
  int _playerX = 0;
  int _playerY = 0;
  double _pixelSize = 0;
  List<Offset> _availableCells = [];

  @override
  void initState() {
    super.initState();
    pixelSize();
    _updateAvailableCells();
  }

  // Обновление списка доступных клеток с точным расчетом расстояния
  void _updateAvailableCells() {
    _availableCells.clear();

    for (int x = 0; x < _mapSize; x++) {
      for (int y = 0; y < _mapSize; y++) {
        // Используем "шахматное" расстояние (манхэттенское)
        final distance = (x - _playerX).abs() + (y - _playerY).abs();
        if (distance <= 6 && distance != 0) {
          _availableCells.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }
  }

  // Высчитывание размеров изображения и координат для изображения персонажа
  void pixelSize() {
    _pixelSize = 411.6/ _mapSize;
  }

  // Перемещение персонажа с проверкой расстояния
  void _movePlayer(int targetX, int targetY) {
    final distance = (targetX - _playerX).abs() + (targetY - _playerY).abs();
    if (distance > 6) return;
    debugPrint("Нажатие на координаты: ($targetX, $targetY)");
    debugPrint("Смещение от персонажа: (${targetY-_playerX}, ${targetY-_playerY})");

    setState(() {
      _playerX = targetX;
      _playerY = targetY;
      _updateAvailableCells();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Точное позиционирование')),
      body: Column(
        children: [
          Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(

                    boundaryMargin: EdgeInsets.all(double.infinity),
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Container(
                      width: _mapSize * _cellSize,
                      height: _mapSize * _cellSize,
                      child: Stack(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _mapSize,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: _mapSize * _mapSize,
                            itemBuilder: (context, index) {
                              final x = index % _mapSize;
                              final y = index ~/ _mapSize;
                              final isAvailable = _availableCells.any(
                                    (cell) => cell.dx == x && cell.dy == y,
                              );

                              return GestureDetector(
                                onTap: () => _movePlayer(x, y),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: isAvailable ? Colors.green.withOpacity(0.3) : null,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Персонаж с точным позиционированием
                          Positioned(
                            left: _playerX * _pixelSize, //10.29 на 40 пикселей; 20.58 на 20 пикселей,
                            top: _playerY  * _pixelSize, // сделать формулу по высчитыванию координат и размера изображения
                            child: SizedBox(
                              child: Image.asset(
                                'assets/shield.png',
                                width: _pixelSize,
                                height: _pixelSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
          _buildCharacterCard()
        ],
      ),
    );
  }

  Widget _buildCharacterCard() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Аватар
          CircleAvatar(
            radius: 24,
            child: Image.asset('assets/shield.png'),
          ),
          const SizedBox(width: 12),

          // Информация
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Имя и уровень
                Row(
                  children: [
                    Text(
                      widget.character.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.shield, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Уровень: ${widget.character.level}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Шкала HP
                LinearProgressIndicator(
                  value: widget.character.currentHP / widget.character.hitPoints, // currentHp / maxHp
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  color: Colors.green,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                SizedBox(height: 4),

                // Числовое значение HP
                Text(
                  'HP: ${widget.character.currentHP}/${widget.character.hitPoints}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


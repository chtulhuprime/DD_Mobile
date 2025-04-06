import 'package:diploma/screens/home_screen.dart';
import 'package:diploma/widget/inventory_provider.dart';
import 'package:diploma/widget/spell_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/characters.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => SpellProvider())
      ],
      child: const DungeonMateApp(),
    ),
  );
}

class DungeonMateApp extends StatelessWidget {
  const DungeonMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DungeonMate',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
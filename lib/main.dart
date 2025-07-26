import 'package:advanced_tic_tac_toe/providers/settings_provider.dart';
import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/screens/home_screen.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await SoundService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // This makes SettingsProvider available globally.
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Advanced Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme.themeData,
      home: const HomeScreen(),
    );
  }
}
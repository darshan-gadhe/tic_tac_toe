import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/screens/home_screen.dart';
// ----> ADD THIS LINE TO FIX THE ERROR <----
import 'package:advanced_tic_tac_toe/services/sound_service.dart' hide ThemeProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // This line was causing the error because the file didn't know what SoundService was.
  await SoundService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget listens to theme changes and rebuilds the MaterialApp
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Advanced Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      // The theme is now dynamically set by our provider
      theme: themeProvider.currentTheme.themeData,
      home: const HomeScreen(),
    );
  }
}
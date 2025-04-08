import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t4/presentation/screen/login_screen.dart';
import 'package:t4/presentation/screen/register_screen.dart';
import 'package:t4/presentation/screen/spash_screen.dart';
import 'package:t4/presentation/screen/home_screen.dart';
import 'package:t4/presentation/screen/now_playing_screen.dart';
import 'package:t4/presentation/screen/search_screen.dart';
import 'package:t4/presentation/screen/favorites_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF31C934)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xantina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A2C1A), // Marrón oscuro
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

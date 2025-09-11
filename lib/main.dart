// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/main_screen.dart'; // Import MainScreen yang baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Dr. Sawit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFf8fafc), // slate-50
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1e3a8a), // blue-900
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(), // Ganti HomeScreen dengan MainScreen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
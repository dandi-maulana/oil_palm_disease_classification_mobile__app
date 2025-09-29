// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. Pastikan import ini ada

void main() async { // <-- 2. Ubah menjadi 'async'
  // 3. Tambahkan dua baris di bawah ini
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ... sisa kode tidak berubah ...
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Dr. Sawit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFf8fafc),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1e3a8a),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
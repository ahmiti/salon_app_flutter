import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const SalonEclatApp());
}

class SalonEclatApp extends StatelessWidget {
  const SalonEclatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L\'Éclat - Salon de Beauté',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Playfair Display',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          primary: AppColors.gold,
          secondary: AppColors.brown,
          tertiary: AppColors.cream,
          background: AppColors.ivory,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.darkBrown,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
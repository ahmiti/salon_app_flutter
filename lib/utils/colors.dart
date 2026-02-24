import 'package:flutter/material.dart';

class AppColors {
  // Palette raffinée - Or rose, brun cuir, ivoire
  static const Color gold = Color(0xFFD4AF37);      // Or rose élégant
  static const Color goldLight = Color(0xFFF5E6D3); // Or pâle
  static const Color brown = Color(0xFF8B5A2B);     // Brun cuir luxueux
  static const Color ivory = Color(0xFFFDFAF5);     // Ivoire - Blanc cassé
  static const Color cream = Color(0xFFF5E6D3);     // Crème
  static const Color darkBrown = Color(0xFF2C1810); // Brun foncé pour textes
  static const Color greyLight = Color(0xFFF5F5F5); // Gris très clair
  
  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      ivory,
      cream,
      goldLight,
    ],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      gold,
      Color(0xFFE5C687),
    ],
  );
}
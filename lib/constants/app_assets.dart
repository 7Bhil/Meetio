import 'package:flutter/material.dart';

class AppAssets {
  // Chemins vers les assets du logo
  static const String logoPath = 'assets/images/logo.png';
  static const String logoLightPath = 'assets/images/logo.png'; // Fallback to same for now
  static const String logoDarkPath = 'assets/images/logo.png'; // Fallback to same for now
  
  // Icône du logo (utilisée en cas d'erreur de chargement de l'image)
  static const IconData logoIcon = Icons.calendar_month_rounded;
  static const IconData logoIconAuth = Icons.calendar_month_rounded;
  
  // Configuration du logo
  static const double logoSizeDefault = 24.0;
  static const double logoSizeLarge = 32.0;
  static const double logoSizeXL = 48.0;
}

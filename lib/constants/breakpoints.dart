class Breakpoints {
  // Points de rupture
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  // Vérifications
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;

  // Colonnes par écran
  static int columns(double width) {
    if (isDesktop(width)) return 3;
    if (isTablet(width)) return 2;
    return 1;
  }

  // Padding adaptatif
  static double horizontalPadding(double width) {
    if (isDesktop(width)) return 120;
    if (isTablet(width)) return 60;
    return 24;
  }
}
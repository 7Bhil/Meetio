import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
// IMPORTEZ les autres écrans quand vous les créerez

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Charge le fichier .env s'il existe (optionnel)
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // ignore: avoid_print
    print('.env non trouvé (continuer sans variables d\'environnement)');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meetio',
      theme: ThemeData(primarySwatch: Colors.blue),

      // ✅ Configuration des routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        // Ajoutez les autres AU FUR ET À MESURE que vous les créez
      },

      debugShowCheckedModeBanner: false,
    );
  }
}

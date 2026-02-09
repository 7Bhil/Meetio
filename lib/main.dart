import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/meetings_list_screen.dart';
import 'screens/create_meeting_screen.dart';
import 'screens/meeting_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'services/auth_service.dart';
import 'constants/app_assets.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
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
      home: const RootScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MeetingsListScreen(),
        '/meetings': (context) => const MeetingsListScreen(),
        '/meetings/create': (context) => const CreateMeetingScreen(),
        '/meetings/detail': (context) => const MeetingDetailScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/admin/users': (context) => const UserManagementScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Petit délai pour montrer le logo si nécessaire
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (kIsWeb) {
      // Sur le Web, on reste sur le LandingScreen par défaut (ou on y va si route '/')
      return;
    }

    // Sur Mobile (Android/iOS), on redirige selon l'auth
    final isLoggedIn = await AuthService().isLoggedIn();
    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const LandingScreen();
    }
    // Sur Mobile, on affiche un écran de chargement brandé
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: Image.asset(
                AppAssets.logoPath,
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

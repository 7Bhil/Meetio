import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/meetings_list_screen.dart';
import 'screens/create_meeting_screen.dart';
import 'screens/meeting_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/admin/user_management_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
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

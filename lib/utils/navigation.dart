import 'package:flutter/material.dart';

enum AppRoute {
  landing('/'),
  auth('/auth'),
  home('/home'),
  meetings('/meetings'),
  createMeeting('/meetings/create'),
  meetingDetails('/meetings/:id'),
  history('/history');

  final String path;
  const AppRoute(this.path);
}

class NavigationService {
  static void navigateTo(BuildContext context, AppRoute route) {
    switch (route) {
      case AppRoute.landing:
        Navigator.pushReplacementNamed(context, route.path);
        break;
      case AppRoute.auth:
        Navigator.pushNamed(context, route.path);
        break;
      case AppRoute.home:
        Navigator.pushReplacementNamed(context, route.path);
        break;
      case AppRoute.meetings:
        Navigator.pushNamed(context, route.path);
        break;
      case AppRoute.createMeeting:
        Navigator.pushNamed(context, route.path);
        break;
      case AppRoute.meetingDetails:
      // Pour l'instant, on fait simple
        Navigator.pushNamed(context, '/meeting-details');
        break;
      case AppRoute.history:
        Navigator.pushNamed(context, route.path);
        break;
    }
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
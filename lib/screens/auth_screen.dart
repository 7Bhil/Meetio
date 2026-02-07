import 'package:flutter/material.dart';

// Version simple sans const
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key}); // ✅ Ajoutez const ici

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Page d\'authentification',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
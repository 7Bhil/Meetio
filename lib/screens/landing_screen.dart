import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(context),
            _buildFeatures(),
            _buildDownloadSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: const Color(0xFFF4F7FF),
      child: Column(
        children: [
          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month_rounded, size: 40, color: Colors.blue),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                ).createShader(bounds),
                child: const Text(
                  'SessionManager',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'La plateforme complète de gestion de sessions',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Text(
              'Créez, gérez et participez à des sessions de formation, ateliers et événements en toute simplicité. Une solution intuitive pour les organisateurs et les participants.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/auth'),
            icon: const Icon(Icons.laptop_chromebook_rounded, color: Colors.white),
            label: const Text('Accéder à la version web', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Fonctionnalités principales',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(
                icon: Icons.people_outline_rounded,
                iconColor: Colors.green,
                title: 'Pour les participants',
                features: [
                  'Consulter les sessions disponibles',
                  'S\'inscrire et se désinscrire facilement',
                  'Recevoir des notifications',
                  'Suivre ses inscriptions',
                ],
              ),
              _buildFeatureCard(
                icon: Icons.shield_outlined,
                iconColor: Colors.blue,
                title: 'Pour les administrateurs',
                features: [
                  'Créer des sessions illimitées',
                  'Gérer les participants',
                  'Définir dates et capacités',
                  'Notifications en temps réel',
                ],
              ),
              _buildFeatureCard(
                icon: Icons.calendar_today_outlined,
                iconColor: Colors.purple,
                title: 'Gestion avancée',
                features: [
                  'Système de rôles complet',
                  'Gestion des utilisateurs',
                  'Interface intuitive',
                  'Multi-plateforme',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> features,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDownloadSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: const Color(0xFFF9FAFF),
      child: Column(
        children: [
          const Text(
            'Téléchargez l\'application',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Disponible sur toutes les plateformes',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildDownloadCard('iOS', 'iPhone & iPad', Icons.apple, url: 'https://testflight.apple.com/join/xxxx'),
              _buildDownloadCard('Android', '.APK', Icons.android_rounded, color: Colors.green, url: 'https://github.com/7Bhil/Meetio/releases/latest/download/app.apk'),
              _buildDownloadCard('Windows', '.EXE', Icons.desktop_windows_rounded, color: Colors.blue, url: 'https://github.com/7Bhil/Meetio/releases/latest/download/app.exe'),
              _buildDownloadCard('macOS', '.DMG', Icons.apple, color: Colors.black, url: 'https://github.com/7Bhil/Meetio/releases/latest/download/app.dmg'),
              _buildDownloadCard('Linux', '.DEB [Debian/Ubuntu]', Icons.inventory_2_outlined, color: Colors.orange, url: 'https://github.com/7Bhil/Meetio/releases/latest/download/app.deb'),
              _buildDownloadCard('Linux', '.RPM [Fedora/RedHat]', Icons.inventory_2_outlined, color: Colors.red, url: 'https://github.com/7Bhil/Meetio/releases/latest/download/app.rpm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(String title, String subtitle, IconData icon, {Color color = Colors.black, required String url}) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Icon(Icons.download_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Text(
        '© 2024 SessionManager - Tous droits réservés',
        style: TextStyle(fontSize: 12, color: Colors.black45),
      ),
    );
  }
}
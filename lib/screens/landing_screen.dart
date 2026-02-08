import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';
import '../widgets/logo_widget.dart';
import '../screens/auth_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(context),
            _buildFeatures(),
            _buildCTA(context),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 800,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent.withOpacity(0.8)],
        ),
      ),
      child: Stack(
        children: [
          // Geometric Decor
          Positioned(
            top: 100,
            right: -50,
            child: Icon(Icons.calendar_today, size: 400, color: Colors.white.withOpacity(0.05)),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LogoWidget(type: LogoType.header),
                      const Spacer(),
                      _buildHeaderButton('Connexion', () {
                         Navigator.pushNamed(context, '/auth');
                      }),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBadge('Nouveau : Meetio v2 est là !'),
                        const SizedBox(height: Spacing.lg),
                        Text(
                          'Simplifiez vos réunions,\nMaximisez votre temps.',
                          style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: Spacing.xl),
                        Text(
                          'La plateforme de gestion de réunions tout-en-un conçue pour les équipes modernes qui exigent l\'excellence.',
                          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                        const SizedBox(height: Spacing.xxl),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/auth'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: Text('Démarrer gratuitement', style: AppTextStyles.labelLarge.copyWith(fontSize: 18)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHeaderButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: Spacing.xxl),
      child: Column(
        children: [
          Text('Pensé pour la productivité', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 60),
          _buildFeatureRow(
            icon: Icons.flash_on_rounded,
            title: 'Planification Instantanée',
            desc: 'Créez des réunions en moins de 30 secondes avec notre interface ultra-rapide.',
            color: Colors.orange,
          ),
          const SizedBox(height: 40),
          _buildFeatureRow(
            icon: Icons.shield_rounded,
            title: 'Sécurité Maximale',
            desc: 'Vos données sont cryptées et stockées de manière sécurisée sur nos serveurs.',
            color: Colors.blue,
            reverse: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String title, required String desc, required Color color, bool reverse = false}) {
    final content = [
      Expanded(
        child: Column(
          crossAxisAlignment: reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Text(desc, style: AppTextStyles.bodyLarge, textAlign: reverse ? TextAlign.right : TextAlign.left),
          ],
        ),
      ),
      const SizedBox(width: 80),
      Expanded(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=800&q=80'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ];

    return Row(children: reverse ? content.reversed.toList() : content);
  }

  Widget _buildCTA(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 80, horizontal: Spacing.xxl),
      padding: const EdgeInsets.all(80),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(
            'Prêt à révolutionner vos réunions ?',
            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/auth'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Commencer maintenant', style: AppTextStyles.labelLarge.copyWith(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(Spacing.xxxl),
      color: Colors.white,
      child: Column(
        children: [
          LogoWidget(type: LogoType.header),
          const SizedBox(height: 40),
          Text('© 2026 Meetio. Tous droits réservés.', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
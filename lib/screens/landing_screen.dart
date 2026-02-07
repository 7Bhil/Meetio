import 'package:flutter/material.dart';
import '../widgets/responsive_container.dart';
import '../widgets/feature_card.dart';
import '../widgets/platform_chip.dart';
import '../constants/breakpoints.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';
import 'auth_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar sticky
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const _Header(),
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero Section
                _HeroSection(),

                // Features Section
                _FeaturesSection(),

                // Benefits Section
                _BenefitsSection(),

                // CTA Section
                _CTASection(),

                // Footer
                _Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============== HEADER ===============
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      enableMaxWidth: true,
      child: SizedBox(
        height: 70, // Hauteur fixe pour le header
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo - aligné à gauche
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Text(
                  'Meetio',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            // Espace flexible pour pousser le bouton à droite
            Expanded(child: Container()),

            // Bouton Se connecter - bien à droite
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xl,
                  vertical: Spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============== HERO SECTION ===============
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= Breakpoints.tablet;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Breakpoints.horizontalPadding(constraints.maxWidth),
            vertical: isDesktop ? Spacing.xxxl * 2 : Spacing.xxxl,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.03),
                AppColors.primary.withOpacity(0.08),
                Colors.white,
              ],
              stops: const [0, 0.5, 1],
            ),
          ),
          child: ResponsiveContainer(
            enableMaxWidth: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge au-dessus du titre
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg,
                    vertical: Spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        'PLATEFORME N°1 DE GESTION DE RÉUNIONS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Spacing.xl),

                // Titre principal avec gradient
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primary,
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Meetio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 72 : 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                ),

                const SizedBox(height: Spacing.md),

                // Sous-titre impactant
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'La plateforme complète\n',
                          style: TextStyle(
                            fontSize: isDesktop ? 36 : 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: 'pour gérer vos réunions',
                          style: TextStyle(
                            fontSize: isDesktop ? 36 : 26,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Spacing.xl),

                // Description
                Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Text(
                    'Créez, planifiez et gérez toutes vos réunions en un seul endroit. '
                        'Une solution intuitive qui s\'adapte aux étudiants, équipes de travail '
                        'et associations.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: isDesktop ? 20 : 18,
                      height: 1.7,
                    ),
                  ),
                ),

                const SizedBox(height: Spacing.xxl),

                // BOUTON PRINCIPAL SEUL (sans "Voir la démo")
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xxl,
                        vertical: Spacing.xl,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch_rounded, size: 26),
                        const SizedBox(width: Spacing.md),
                        Text(
                          'Commencer gratuitement',
                          style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Spacing.xl),

                // Statistiques impactantes
                Container(
                  margin: const EdgeInsets.only(top: Spacing.xxl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('10K+', 'Utilisateurs'),
                      const SizedBox(width: Spacing.xl),
                      _buildStatItem('50K+', 'Réunions créées'),
                      const SizedBox(width: Spacing.xl),
                      _buildStatItem('99%', 'Satisfaction'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FeatureBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: Spacing.xs),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =============== FEATURES SECTION ===============
class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
      color: AppColors.background,
      child: ResponsiveContainer(
        child: Column(
          children: [
            // Titre
            Text(
              'Fonctionnalités principales',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: Spacing.md),

            // Sous-titre
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Une solution complète pour tous vos besoins de réunion',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: Spacing.xxl),

            // Grille de features adaptative
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth >= Breakpoints.tablet;
                final double cardWidth = isDesktop ? 340 : double.infinity;

                return Wrap(
                  spacing: Spacing.lg,
                  runSpacing: Spacing.lg,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _buildFeatureCard(
                        title: 'Pour les participants',
                        features: [
                          'Consulter les réunions disponibles',
                          "S'inscrire et se désinscrire facilement",
                          'Recevoir des notifications',
                          'Suivre ses inscriptions',
                        ],
                        icon: Icons.people_alt_rounded,
                        color: AppColors.success,
                      ),
                    ),

                    SizedBox(
                      width: cardWidth,
                      child: _buildFeatureCard(
                        title: 'Pour les organisateurs',
                        features: [
                          'Créer des réunions illimitées',
                          'Gérer les participants',
                          'Définir dates et lieux',
                          'Notifications en temps réel',
                        ],
                        icon: Icons.admin_panel_settings_rounded,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(
                      width: cardWidth,
                      child: _buildFeatureCard(
                        title: 'Gestion avancée',
                        features: [
                          'Système de rôles complet',
                          'Gestion des utilisateurs',
                          'Interface intuitive',
                          'Multi-plateforme',
                        ],
                        icon: Icons.settings_applications_rounded,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required List<String> features,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête compacte
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: color,
                      height: 1.3,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.lg),

            // Liste des features compacte
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// =============== BENEFITS SECTION ===============
class _BenefitsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Pourquoi choisir Meetio ?',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: Spacing.xxl),

            LayoutBuilder(
              builder: (context, constraints) {
                final int columns = Breakpoints.columns(constraints.maxWidth);

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: Spacing.lg,
                  mainAxisSpacing: Spacing.lg,
                  childAspectRatio: 1.4,
                  children: [
                    _BenefitCard(
                      icon: Icons.access_time,
                      title: 'Gain de temps',
                      description: 'Planifiez vos réunions en quelques clics',
                    ),
                    _BenefitCard(
                      icon: Icons.group,
                      title: 'Collaboration',
                      description: 'Travaillez efficacement en équipe',
                    ),
                    _BenefitCard(
                      icon: Icons.notifications_active,
                      title: 'Rappels',
                      description: 'Ne manquez plus aucune réunion',
                    ),
                    _BenefitCard(
                      icon: Icons.security,
                      title: 'Sécurisé',
                      description: 'Vos données sont protégées',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: Spacing.lg),

            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: Spacing.sm),

            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== CTA SECTION ===============
class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
      color: AppColors.primary.withOpacity(0.03),
      child: ResponsiveContainer(
        child: Column(
          children: [
            // Section Téléchargement
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.xl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Titre mis en valeur
                  Container(
                    margin: const EdgeInsets.only(bottom: Spacing.lg),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.lg,
                            vertical: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '📲 TÉLÉCHARGEZ L\'APPLICATION',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: Spacing.lg),

                        Text(
                          'Disponible sur toutes vos plateformes',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: Spacing.sm),

                        Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            'Utilisez Meetio partout, sur tous vos appareils. Téléchargez l\'application adaptée à votre système.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grille des plateformes RESPONSIVE
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isLarge = constraints.maxWidth >= 700;
                      final bool isMedium = constraints.maxWidth >= 500;

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isLarge ? 3 : (isMedium ? 2 : 1),
                        crossAxisSpacing: Spacing.md,
                        mainAxisSpacing: Spacing.md,
                        childAspectRatio: 3.2, // Ratio plus large pour éviter l'overflow
                        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                        children: const [
                          _PlatformCard(
                            platform: 'iOS',
                            icon: Icons.phone_iphone_rounded,
                            subtitle: 'iPhone & iPad',
                            color: Colors.black,
                          ),
                          _PlatformCard(
                            platform: 'Android',
                            icon: Icons.android_rounded,
                            subtitle: '.APK disponible',
                            color: Colors.green,
                          ),
                          _PlatformCard(
                            platform: 'Windows',
                            icon: Icons.desktop_windows_rounded,
                            subtitle: '.EXE',
                            color: Colors.blue,
                          ),
                          _PlatformCard(
                            platform: 'macOS',
                            icon: Icons.desktop_mac_rounded,
                            subtitle: '.DMG',
                            color: Colors.grey,
                          ),
                          _PlatformCard(
                            platform: 'Linux',
                            icon: Icons.code_rounded,
                            subtitle: '.DEB / .RPM',
                            color: Colors.orange,
                          ),
                          _PlatformCard(
                            platform: 'Web',
                            icon: Icons.language_rounded,
                            subtitle: 'Navigateur',
                            color: Colors.blueAccent,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: Spacing.xxl),

                  // Bouton CTA principal
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AuthScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xxl,
                          vertical: Spacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download_rounded, size: 22),
                          const SizedBox(width: Spacing.md),
                          Text(
                            'Télécharger maintenant',
                            style: AppTextStyles.labelLarge.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.lg),

                  // Texte info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 16, color: Colors.green),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        '30 jours d\'essai gratuit',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: Spacing.lg),
                      Icon(Icons.credit_card_off_rounded,
                          size: 16, color: Colors.green),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        'Aucune carte requise',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final String platform;
  final IconData icon;
  final String subtitle;
  final Color color;

  const _PlatformCard({
    required this.platform,
    required this.icon,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Hauteur fixe pour éviter l'overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Row(
          children: [
            // Icône
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: Spacing.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),

            // Texte
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// =============== FOOTER ===============
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
      color: AppColors.primaryDark,
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          'Meetio',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text(
                      'Simplifiez la gestion de vos réunions',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                // Contact
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'contact@meetio.com',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: Spacing.xl),

            const Divider(color: Colors.white24),

            const SizedBox(height: Spacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2024 Meetio. Tous droits réservés.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),

                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Confidentialité',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.lg),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Conditions',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
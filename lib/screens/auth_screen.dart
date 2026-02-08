import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo et retour
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      'Meetio',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: Spacing.xxl),

                // Titre
                Text(
                  isLogin ? 'Connexion' : 'Créer un compte',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: Spacing.sm),

                Text(
                  isLogin
                      ? 'Accédez à votre espace de réunions'
                      : 'Rejoignez Meetio en quelques clics',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: Spacing.xxl),

                // Formulaire
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!isLogin)
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nom complet',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        if (!isLogin) const SizedBox(height: Spacing.lg),

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Adresse email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: Spacing.lg),

                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Au moins 6 caractères';
                            }
                            return null;
                          },
                        ),

                        if (!isLogin) const SizedBox(height: Spacing.lg),
                        if (!isLogin)
                          TextFormField(
                            controller: _passwordConfirmController,
                            decoration: const InputDecoration(
                              labelText: 'Confirmer le mot de passe',
                              prefixIcon: Icon(Icons.lock_reset),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (!isLogin) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez confirmer le mot de passe';
                                }
                                if (value != _passwordController.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                              }
                              return null;
                            },
                          ),

                        const SizedBox(height: Spacing.lg),

                        // Bouton de soumission
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    setState(() => _loading = true);

                                    try {
                                      if (isLogin) {
                                        final user = await AuthService().login(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                        );
                                        if (user != null) {
                                          // Aller à /home
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/home',
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Échec de la connexion',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        final user = await AuthService()
                                            .register(
                                              name: _nameController.text.trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
                                              passwordConfirmation:
                                                  _passwordConfirmController
                                                      .text,
                                            );
                                        if (user != null) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/home',
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Échec de l\'inscription',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Erreur: $e')),
                                      );
                                    } finally {
                                      if (mounted)
                                        setState(() => _loading = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.lg,
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    isLogin
                                        ? 'Se connecter'
                                        : 'Créer mon compte',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: Spacing.lg),

                        // Lien pour changer de mode
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? 'Pas de compte ? S\'inscrire'
                                : 'Déjà un compte ? Se connecter',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),

                        const SizedBox(height: Spacing.xl),

                        // Séparateur
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.border)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                              child: Text(
                                'Ou continuer avec',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.border)),
                          ],
                        ),

                        const SizedBox(height: Spacing.lg),

                        // Boutons de connexion sociale - VERSION CORRIGÉE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                icon: Icons.g_mobiledata,
                                label: 'Continuer avec Google',
                                color: Color(0xFF4285F4),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 24, color: color),
            padding: const EdgeInsets.all(Spacing.md),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

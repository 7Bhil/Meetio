import 'package:flutter/material.dart';
import 'dart:ui';
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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            right: -100,
            child: _buildGradientOrb(Colors.indigo.withOpacity(0.2), 300),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildGradientOrb(AppColors.accent.withOpacity(0.1), 250),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Area
                    _buildHeader(),
                    const SizedBox(height: Spacing.xxl),
                    
                    // Glassmorphic Card
                    _buildAuthCard(),
                    
                    const SizedBox(height: Spacing.xl),
                    _buildFooterLink(),
                  ],
                ),
              ),
            ),
          ),
          
          // Back Button
          if (Navigator.canPop(context))
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradientOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          'Meetio',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          isLogin ? 'Bon retour parmi nous !' : 'Commencez l\'aventure.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(Spacing.xl),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLogin ? 'Connexion' : 'Inscription',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: Spacing.xl),
                
                if (!isLogin) ...[
                  _buildLabel('Nom complet'),
                  _buildTextField(_nameController, Icons.person_outline, 'John Doe'),
                  const SizedBox(height: Spacing.lg),
                ],
                
                _buildLabel('Adresse email'),
                _buildTextField(_emailController, Icons.email_outlined, 'email@exemple.com', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: Spacing.lg),
                
                _buildLabel('Mot de passe'),
                _buildTextField(_passwordController, Icons.lock_outline, '••••••••', obscure: true),
                
                if (!isLogin) ...[
                  const SizedBox(height: Spacing.lg),
                  _buildLabel('Confirmer le mot de passe'),
                  _buildTextField(_passwordConfirmController, Icons.lock_reset_outlined, '••••••••', obscure: true),
                ],
                
                const SizedBox(height: Spacing.xxl),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs, left: 4),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool obscure = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ),
      ),
      child: ElevatedButton(
        onPressed: _loading ? null : _handleAuth,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _loading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                isLogin ? 'Se connecter' : 'Créer un compte',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }

  Widget _buildFooterLink() {
    return TextButton(
      onPressed: () => setState(() => isLogin = !isLogin),
      child: RichText(
        text: TextSpan(
          text: isLogin ? 'Pas encore de compte ? ' : 'Déjà un compte ? ',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          children: [
            TextSpan(
              text: isLogin ? 'Inscrivez-vous' : 'Connectez-vous',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final authService = AuthService();
      final user = isLogin
          ? await authService.login(email: _emailController.text.trim(), password: _passwordController.text)
          : await authService.register(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              passwordConfirmation: _passwordConfirmController.text,
            );

      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

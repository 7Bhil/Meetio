import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/spacing.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  Future<List<User>> _fetchUsers() async {
    final response = await ApiService.getUsers();
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de récupération : ${response.statusCode}');
    }
  }

  Future<void> _updateRole(User user, String newRole) async {
    try {
      final response = await ApiService.updateUserRole(int.parse(user.id), newRole);
      if (response.statusCode == 200) {
        _refreshUsers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rôle de ${user.name} mis à jour en $newRole'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Gestion de la Communauté',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _refreshUsers),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final users = snapshot.data ?? [];

          return Column(
            children: [
              _buildStatsHeader(users),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(user);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsHeader(List<User> users) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xl),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', users.length.toString(), Icons.people_outline),
          _buildStatItem('Admins', users.where((u) => u.role == 'admin').length.toString(), Icons.admin_panel_settings_outlined),
          _buildStatItem('Organis.', users.where((u) => u.role == 'organisateur').length.toString(), Icons.meeting_room_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Text(user.name[0].toUpperCase(), style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary)),
        ),
        title: Text(user.name, style: AppTextStyles.titleMedium),
        subtitle: Text(user.email, style: AppTextStyles.bodySmall),
        trailing: _buildRoleBadge(user),
        onTap: () => _showRoleDialog(user),
      ),
    );
  }

  Widget _buildRoleBadge(User user) {
    Color color = AppColors.textSecondary;
    if (user.role == 'admin') color = AppColors.error;
    if (user.role == 'organisateur') color = AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        user.role.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  void _showRoleDialog(User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Modifier le rôle', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text('De quel niveau d\'accès ${user.name} a-t-il besoin ?', style: AppTextStyles.bodySmall),
            const SizedBox(height: Spacing.xl),
            _roleTile(user, 'standard', 'Utilisateur classique', Icons.person_outline),
            _roleTile(user, 'organisateur', 'Peut créer des réunions', Icons.meeting_room_outlined),
            _roleTile(user, 'admin', 'Accès total à la plateforme', Icons.admin_panel_settings_outlined),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _roleTile(User user, String role, String desc, IconData icon) {
    final isCurrent = user.role == role;
    return ListSelectionItem(
      title: role.toUpperCase(),
      subtitle: desc,
      icon: icon,
      isActive: isCurrent,
      onTap: isCurrent ? null : () {
        Navigator.pop(context);
        _updateRole(user, role);
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: Spacing.md),
            Text('Erreur de chargement', style: AppTextStyles.titleLarge),
            const SizedBox(height: Spacing.sm),
            Text(error, textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
            const SizedBox(height: Spacing.xl),
            ElevatedButton(onPressed: _refreshUsers, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

class ListSelectionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const ListSelectionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: isActive ? AppColors.primary : AppColors.textPrimary)),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (isActive) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meeting.dart';
import '../services/meeting_service.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/text_styles.dart';

class MeetingDetailScreen extends StatefulWidget {
  const MeetingDetailScreen({super.key});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  final MeetingService _meetingService = MeetingService();
  bool _loading = false;

  Future<void> _deleteMeeting(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la réunion'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette réunion ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _loading = true);
      final success = await _meetingService.deleteMeeting(id);
      if (mounted) {
        setState(() => _loading = false);
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Réunion supprimée avec succès'), behavior: SnackBarBehavior.floating),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la suppression'), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  Future<void> _joinMeeting(String id) async {
    setState(() => _loading = true);
    final success = await _meetingService.joinMeeting(id);
    if (mounted) {
      setState(() => _loading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true); // Refresh parent
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de rejoindre cette réunion (vérifiez vos horaires)'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final meeting = ModalRoute.of(context)!.settings.arguments as Meeting;
    final dateFormat = DateFormat('EEEE dd MMMM yyyy', 'fr_FR');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(meeting),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainCard(meeting, dateFormat, timeFormat),
                  const SizedBox(height: Spacing.xl),
                  _buildDescriptionSection(meeting),
                  const SizedBox(height: Spacing.xxxl),
                  _buildJoinButton(meeting),
                  const SizedBox(height: Spacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Meeting meeting) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => Navigator.pushNamed(context, '/meetings/create', arguments: meeting),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () => _deleteMeeting(meeting.id),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(meeting.title, style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.accent.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.meeting_room_rounded, size: 150, color: Colors.white.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(Meeting meeting, DateFormat df, DateFormat tf) {
    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.calendar_month_rounded, 'Date', df.format(meeting.date)),
          const Divider(height: 32),
          _buildDetailRow(Icons.access_time_rounded, 'Heure', tf.format(meeting.date)),
          const Divider(height: 32),
          _buildDetailRow(Icons.timer_outlined, 'Durée', '${meeting.duration} minutes'),
          const Divider(height: 32),
          _buildDetailRow(Icons.location_on_rounded, 'Lieu', meeting.location),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Meeting meeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('À PROPOS DE CETTE RÉUNION', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2, fontSize: 11)),
        const SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Text(
            meeting.description.isEmpty ? 'Aucune description détaillée.' : meeting.description,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinButton(Meeting meeting) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _loading ? null : () => _joinMeeting(meeting.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _loading 
          ? const CircularProgressIndicator(color: Colors.white)
          : Text('REJOINDRE LA RÉUNION', style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16, letterSpacing: 1.1)),
      ),
    );
  }
}

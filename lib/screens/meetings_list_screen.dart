import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meeting.dart';
import '../models/user.dart';
import '../services/meeting_service.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../models/notification.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';
import '../widgets/logo_loader.dart';

class MeetingsListScreen extends StatefulWidget {
  const MeetingsListScreen({super.key});

  @override
  State<MeetingsListScreen> createState() => _MeetingsListScreenState();
}

class _MeetingsListScreenState extends State<MeetingsListScreen> {
  final MeetingService _meetingService = MeetingService();
  final NotificationService _notificationService = NotificationService();
  
  // State variables instead of Futures to allow silent refreshes
  List<Meeting>? _meetings;
  List<Meeting>? _discoverMeetings;
  List<NotificationModel> _notifications = [];
  User? _currentUser;
  
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllData(firstLoad: true);
  }

  Future<void> _loadAllData({bool firstLoad = false}) async {
    if (firstLoad) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      // Load user first if needed (should be cached or quick)
      if (_currentUser == null) {
        _currentUser = await AuthService().getCurrentUser();
      }

      // Parallel data fetching
      final results = await Future.wait([
        _meetingService.getMeetings(),
        _meetingService.getMeetings(discover: true),
        _notificationService.getNotifications(),
      ]);

      if (mounted) {
        setState(() {
          _meetings = results[0] as List<Meeting>;
          _discoverMeetings = results[1] as List<Meeting>;
          _notifications = results[2] as List<NotificationModel>;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    await _loadAllData(firstLoad: false);
  }

  Future<void> _logout() async {
    await ApiService.deleteToken();
    if (mounted) {
      final redirectRoute = kIsWeb ? '/' : '/auth';
      Navigator.pushNamedAndRemoveUntil(context, redirectRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: LogoLoader(message: 'Chargement de vos réunions...'),
      );
    }

    if (_error != null && _meetings == null) {
      return Scaffold(
        body: _buildErrorState(_error!),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          title: Text(
            'Meetio',
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'Mes Réunions'),
              Tab(text: 'Découvrir'),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                label: _unreadCount > 0 ? Text(_unreadCount.toString()) : null,
                isLabelVisible: _unreadCount > 0,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              onPressed: () => Navigator.pushNamed(context, '/notifications').then((_) => _refresh()),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _refresh,
            ),
            const SizedBox(width: Spacing.sm),
          ],
        ),
        drawer: _buildDrawer(),
        body: TabBarView(
          children: [
            _buildMeetingsList(_meetings ?? [], isDiscover: false),
            _buildMeetingsList(_discoverMeetings ?? [], isDiscover: true),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/meetings/create').then((_) => _refresh()),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text('Nouvelle réunion', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
    );
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  Widget _buildMeetingsList(List<Meeting> meetings, {required bool isDiscover}) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refresh,
      child: meetings.isEmpty
          ? _buildEmptyState(isDiscover: isDiscover)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetings[index];
                return _buildMeetingCard(meeting, isDiscover: isDiscover);
              },
            ),
    );
  }

  Widget _buildDrawer() {
    final isAdmin = _currentUser?.role == 'admin';
    
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _currentUser?.name.substring(0, 1).toUpperCase() ?? 'M',
                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
              ),
            ),
            accountName: Text(_currentUser?.name ?? 'Utilisateur', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
            accountEmail: Text(_currentUser?.email ?? '', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8))),
          ),
          _buildDrawerItem(Icons.meeting_room_outlined, 'Mes Réunions', () => Navigator.pop(context), selected: true),
          
          if (isAdmin) ...[
            const Divider(indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('ADMINISTRATION', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary, fontSize: 12)),
            ),
            _buildDrawerItem(Icons.people_outline, 'Gestion des utilisateurs', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/users');
            }),
          ],
          
          const Spacer(),
          const Divider(),
          _buildDrawerItem(Icons.logout_rounded, 'Se déconnecter', _logout, color: AppColors.error),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool selected = false, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (selected ? AppColors.primary : AppColors.textSecondary)),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: color ?? (selected ? AppColors.primary : AppColors.textPrimary),
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: selected,
      selectedTileColor: AppColors.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildMeetingCard(Meeting meeting, {bool isDiscover = false}) {
    final dateFormat = DateFormat('EEE d MMMM', 'fr_FR');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/meetings/detail', arguments: meeting).then((_) => _refresh()),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  // Date Box
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(meeting.date),
                          style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM').format(meeting.date).toUpperCase(),
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meeting.title, style: AppTextStyles.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('${timeFormat.format(meeting.date)} (${meeting.duration} min)', style: AppTextStyles.bodySmall),
                            const SizedBox(width: 12),
                            Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(child: Text(meeting.location, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Status
                  if (!isDiscover) _buildStatusIndicator(meeting.status),
                ],
              ),
              if (isDiscover) ...[
                const SizedBox(height: Spacing.md),
                const Divider(),
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (meeting.maxParticipants != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '${meeting.participants?.length ?? 0}/${meeting.maxParticipants} places',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: ((meeting.participants?.length ?? 0) >= meeting.maxParticipants!) 
                              ? AppColors.error 
                              : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: ((meeting.participants?.length ?? 0) >= (meeting.maxParticipants ?? 999)) 
                        ? null 
                        : () => _joinMeeting(meeting),
                      icon: Icon(
                        ((meeting.participants?.length ?? 0) >= (meeting.maxParticipants ?? 999))
                          ? Icons.block_rounded
                          : Icons.add_circle_outline_rounded, 
                        size: 20
                      ),
                      label: Text(((meeting.participants?.length ?? 0) >= (meeting.maxParticipants ?? 999)) ? 'COMPLET' : 'REJOINDRE'),
                      style: TextButton.styleFrom(
                        foregroundColor: ((meeting.participants?.length ?? 0) >= (meeting.maxParticipants ?? 999))
                          ? Colors.grey
                          : AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinMeeting(Meeting meeting) async {
    final success = await _meetingService.joinMeeting(meeting.id);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !'), backgroundColor: AppColors.success),
        );
        _refresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de rejoindre cette réunion (vérifiez vos horaires)'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Widget _buildStatusIndicator(String status) {
    Color color = AppColors.primary;
    if (status == 'en cours') color = AppColors.success;
    if (status == 'terminée' || status == 'passée') color = AppColors.textDisabled;

    return Container(
      width: 8,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isDiscover = false}) {
    // ScrollView needed for RefreshIndicator to work on empty state
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDiscover ? Icons.search_off_rounded : Icons.event_note_rounded, 
                  size: 80, 
                  color: AppColors.textDisabled.withOpacity(0.5)
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  isDiscover ? 'Aucune nouvelle réunion' : 'Aucune réunion prévue', 
                  style: AppTextStyles.headlineSmall
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  isDiscover ? 'Revenez plus tard pour voir les nouveautés !' : 'Commencez par en créer une !', 
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)
                ),
              ],
            ),
          ),
        ),
      ],
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
            Text('Erreur lors du chargement', style: AppTextStyles.titleLarge),
            const SizedBox(height: Spacing.sm),
            Text(error, textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
            const SizedBox(height: Spacing.xl),
            ElevatedButton(onPressed: _refresh, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

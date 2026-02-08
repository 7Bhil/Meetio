import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/meeting.dart';
import '../services/meeting_service.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/text_styles.dart';

class CreateMeetingScreen extends StatefulWidget {
  final Meeting? meeting;

  const CreateMeetingScreen({super.key, this.meeting});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _duration = 60; // minutes
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.meeting?.title ?? '');
    _descriptionController = TextEditingController(text: widget.meeting?.description ?? '');
    _locationController = TextEditingController(text: widget.meeting?.location ?? '');
    _selectedDate = widget.meeting?.date ?? DateTime.now();
    _selectedTime = widget.meeting != null 
        ? TimeOfDay.fromDateTime(widget.meeting!.date) 
        : TimeOfDay.now();
    _duration = widget.meeting?.duration ?? 60;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
      builder: (context, child) => _buildPickerTheme(context, child!),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => _buildPickerTheme(context, child!),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Widget _buildPickerTheme(BuildContext context, Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
      ),
      child: child,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final combinedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final meeting = Meeting(
      id: widget.meeting?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: combinedDate,
      duration: _duration,
      location: _locationController.text.trim(),
      organizerId: '', 
      status: widget.meeting?.status ?? 'à venir',
    );

    try {
      final success = widget.meeting == null
          ? await MeetingService().createMeeting(meeting)
          : await MeetingService().updateMeeting(meeting);

      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.meeting == null ? 'Réunion créée avec succès !' : 'Réunion mise à jour !'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'enregistrement'), backgroundColor: AppColors.error),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.meeting != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          isEditing ? 'Modifier la réunion' : 'Nouvelle réunion',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient Or Orbs
          Positioned(
            top: -50,
            left: -50,
            child: _buildGradientOrb(AppColors.primary.withOpacity(0.05), 200),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionTitle('Informations Générales'),
                   const SizedBox(height: Spacing.md),
                   _buildCard([
                      _buildTextField(_titleController, 'Titre de la réunion', 'ex: Point Hebdo Design', Icons.title_rounded),
                      const SizedBox(height: Spacing.lg),
                      _buildTextField(_descriptionController, 'Description', 'De quoi allons-nous parler ?', Icons.description_outlined, maxLines: 3),
                      const SizedBox(height: Spacing.lg),
                      _buildTextField(_locationController, 'Lieu ou Lien', 'ex: Salle de conférence ou Zoom', Icons.location_on_outlined),
                   ]),
                   
                   const SizedBox(height: Spacing.xl),
                   _buildSectionTitle('Date & Heure'),
                   const SizedBox(height: Spacing.md),
                   _buildCard([
                      Row(
                        children: [
                          Expanded(child: _buildDateTimePicker(
                            label: 'Date', 
                            value: DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDate), 
                            icon: Icons.calendar_month_rounded, 
                            onTap: () => _selectDate(context)
                          )),
                          const SizedBox(width: Spacing.md),
                          Expanded(child: _buildDateTimePicker(
                            label: 'Heure', 
                            value: _selectedTime.format(context), 
                            icon: Icons.access_time_rounded, 
                            onTap: () => _selectTime(context)
                          )),
                        ],
                      ),
                      const SizedBox(height: Spacing.lg),
                      _buildDurationSelector(),
                   ]),
                   
                   const SizedBox(height: Spacing.xxxl),
                   _buildSubmitButton(isEditing),
                ],
              ),
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
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color, color.withOpacity(0)])),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2, fontSize: 12),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.primaryLight.withOpacity(0.3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
          validator: (val) => val == null || val.isEmpty ? 'Ce champ est requis' : null,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final durations = [15, 30, 45, 60, 90, 120];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Durée estimados (minutes)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: durations.map((d) {
              final isSelected = _duration == d;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('${d}m'),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _duration = d);
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEditing) {
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
        onPressed: _loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _loading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                isEditing ? 'SAUVEGARDER LES MODIFICATIONS' : 'CRÉER LA RÉUNION',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}

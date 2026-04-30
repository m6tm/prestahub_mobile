import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Gestion des disponibilités récurrentes et des exceptions du prestataire.
class ProviderAvailabilityScreen extends StatefulWidget {
  const ProviderAvailabilityScreen({super.key});

  @override
  State<ProviderAvailabilityScreen> createState() =>
      _ProviderAvailabilityScreenState();
}

class _ProviderAvailabilityScreenState
    extends State<ProviderAvailabilityScreen> {
  static const _dayLabels = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  final List<AvailabilitySlot> _slots = List.generate(
    7,
    (i) => AvailabilitySlot(
      dayOfWeek: i,
      startTime: '08:00',
      endTime: '18:00',
      isAvailable: i < 5,
    ),
  );

  final List<AvailabilityException> _exceptions = [
    AvailabilityException(
      id: 'exc-1',
      date: DateTime.now().add(const Duration(days: 7)),
      reason: 'Congés',
    ),
  ];

  bool _submitting = false;

  void _toggleDay(int day, bool value) {
    setState(() {
      final i = _slots.indexWhere((s) => s.dayOfWeek == day);
      if (i >= 0) _slots[i] = _slots[i].copyWith(isAvailable: value);
    });
  }

  Future<void> _editSlot(int day) async {
    final current = _slots.firstWhere((s) => s.dayOfWeek == day);
    final updated = await showModalBottomSheet<AvailabilitySlot>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SlotEditorSheet(
        dayLabel: _dayLabels[day],
        initial: current,
      ),
    );
    if (updated == null || !mounted) return;
    setState(() {
      final i = _slots.indexWhere((s) => s.dayOfWeek == day);
      if (i >= 0) _slots[i] = updated;
    });
  }

  Future<void> _addException() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Motif (optionnel)'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(hintText: 'Congés, formation...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(reasonCtrl.text.trim()),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (reason == null || !mounted) return;
    setState(() {
      _exceptions.add(
        AvailabilityException(
          id: 'exc-${DateTime.now().millisecondsSinceEpoch}',
          date: picked,
          reason: reason.isEmpty ? null : reason,
        ),
      );
    });
  }

  void _removeException(String id) {
    setState(() => _exceptions.removeWhere((e) => e.id == id));
  }

  Future<void> _save() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Disponibilités enregistrées.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Disponibilités',
      subtitle: 'Vos horaires récurrents et absences',
      bottomBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _submitting ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: PrestaHubTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Enregistrer',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          _SectionHeader(
            title: 'Horaires récurrents',
            subtitle: 'Définis pour chaque jour de la semaine',
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PrestaHubTheme.border),
            ),
            child: Column(
              children: List.generate(_slots.length, (i) {
                final s = _slots[i];
                return Column(
                  children: [
                    _DaySlotRow(
                      label: _dayLabels[s.dayOfWeek],
                      slot: s,
                      onToggle: (v) => _toggleDay(s.dayOfWeek, v),
                      onTap: s.isAvailable ? () => _editSlot(s.dayOfWeek) : null,
                    ),
                    if (i < _slots.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: PrestaHubTheme.border,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SectionHeader(
                  title: 'Absences ponctuelles',
                  subtitle: 'Jours où vous n\'êtes pas disponible',
                ),
              ),
              TextButton.icon(
                onPressed: _addException,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Ajouter',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: PrestaHubTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_exceptions.isEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: Center(
                child: Text(
                  'Aucune absence planifiée',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            )
          else
            ..._exceptions.map(
              (exc) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ExceptionCard(
                  exception: exc,
                  onDelete: () => _removeException(exc.id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
      ],
    );
  }
}

class _DaySlotRow extends StatelessWidget {
  final String label;
  final AvailabilitySlot slot;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  const _DaySlotRow({
    required this.label,
    required this.slot,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: slot.isAvailable
                      ? PrestaHubTheme.textLight
                      : PrestaHubTheme.textMutedLight,
                ),
              ),
            ),
            Expanded(
              child: Text(
                slot.isAvailable
                    ? '${slot.startTime} → ${slot.endTime}'
                    : 'Fermé',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: slot.isAvailable
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.textMutedLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: slot.isAvailable,
              onChanged: onToggle,
              activeThumbColor: PrestaHubTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExceptionCard extends StatelessWidget {
  final AvailabilityException exception;
  final VoidCallback onDelete;

  const _ExceptionCard({required this.exception, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final d = exception.date;
    final formatted =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PrestaHubTheme.warning.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.event_busy_rounded,
                color: PrestaHubTheme.warning, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatted,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                if (exception.reason != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    exception.reason!,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: PrestaHubTheme.danger, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SlotEditorSheet extends StatefulWidget {
  final String dayLabel;
  final AvailabilitySlot initial;

  const _SlotEditorSheet({required this.dayLabel, required this.initial});

  @override
  State<_SlotEditorSheet> createState() => _SlotEditorSheetState();
}

class _SlotEditorSheetState extends State<_SlotEditorSheet> {
  late String _start;
  late String _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initial.startTime;
    _end = widget.initial.endTime;
  }

  Future<void> _pickTime(bool isStart) async {
    final base = (isStart ? _start : _end).split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(base[0]),
        minute: int.parse(base[1]),
      ),
    );
    if (picked == null) return;
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (isStart) {
        _start = formatted;
      } else {
        _end = formatted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Horaires du ${widget.dayLabel.toLowerCase()}',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _TimeBox(
                  label: 'Début',
                  value: _start,
                  onTap: () => _pickTime(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeBox(
                  label: 'Fin',
                  value: _end,
                  onTap: () => _pickTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  widget.initial.copyWith(startTime: _start, endTime: _end),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Valider',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimeBox({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

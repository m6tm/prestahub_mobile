import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/service_request_models.dart';

class RequestScheduleStep extends StatefulWidget {
  final ServiceRequestDraft draft;
  final VoidCallback onChanged;

  const RequestScheduleStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<RequestScheduleStep> createState() => _RequestScheduleStepState();
}

class _RequestScheduleStepState extends State<RequestScheduleStep> {
  static const _slots = [
    'Matin (8h-12h)',
    'Après-midi (12h-17h)',
    'Soir (17h-20h)'
  ];
  static const _urgencies = ['Standard', 'Sous 48h', 'Urgent (24h)'];
  static const _monthsFr = [
    'Janv', 'Févr', 'Mars', 'Avr', 'Mai', 'Juin',
    'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'
  ];
  static const _weekdaysFr = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  List<DateTime> get _next14Days {
    final now = DateTime.now();
    return List.generate(14, (i) => DateTime(now.year, now.month, now.day + i));
  }

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Quand intervenir ?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choisissez un créneau préféré. Le prestataire pourra vous proposer un horaire précis.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: PrestaHubTheme.textMutedLight,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        _buildLabel('Niveau d\'urgence'),
        const SizedBox(height: 10),
        Row(
          children: _urgencies.map((u) {
            final selected = widget.draft.urgency == u;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.draft.urgency = u;
                  widget.onChanged();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: u == _urgencies.last ? 0 : 8,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? primarySoft
                        : PrestaHubTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? PrestaHubTheme.primary
                          : PrestaHubTheme.border,
                      width: selected ? 1.3 : 1,
                    ),
                  ),
                  child: Text(
                    u,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? PrestaHubTheme.primary
                          : PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
        _buildLabel('Date préférée'),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _next14Days.length,
            itemBuilder: (context, i) {
              final d = _next14Days[i];
              final sel = widget.draft.preferredDate?.year == d.year &&
                  widget.draft.preferredDate?.month == d.month &&
                  widget.draft.preferredDate?.day == d.day;
              return GestureDetector(
                onTap: () {
                  widget.draft.preferredDate = d;
                  widget.onChanged();
                },
                child: Container(
                  width: 64,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: sel
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel
                          ? PrestaHubTheme.primary
                          : PrestaHubTheme.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekdaysFr[(d.weekday - 1) % 7],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: sel
                              ? PrestaHubTheme.primaryContent
                                  .withValues(alpha: 0.8)
                              : PrestaHubTheme.borderStrong,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d.day}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: sel
                              ? PrestaHubTheme.primaryContent
                              : PrestaHubTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _monthsFr[d.month - 1],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: sel
                              ? PrestaHubTheme.primaryContent
                                  .withValues(alpha: 0.8)
                              : PrestaHubTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        _buildLabel('Créneau horaire'),
        const SizedBox(height: 10),
        ..._slots.map((s) {
          final selected = widget.draft.preferredSlot == s;
          return GestureDetector(
            onTap: () {
              widget.draft.preferredSlot = s;
              widget.onChanged();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? primarySoft
                    : PrestaHubTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.border,
                  width: selected ? 1.3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: primarySoft,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      color: PrestaHubTheme.primary,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? PrestaHubTheme.primary
                            : PrestaHubTheme.borderStrong,
                        width: 2,
                      ),
                      color: selected
                          ? PrestaHubTheme.primary
                          : PrestaHubTheme.backgroundLight,
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: PrestaHubTheme.primaryContent,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: PrestaHubTheme.textLight,
      ),
    );
  }
}

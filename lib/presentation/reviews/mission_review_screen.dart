import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import 'models/review_context.dart';

/// Écran de notation d'une mission terminée.
///
/// L'utilisateur sélectionne une note étoilée, coche des mots-clés
/// descriptifs et rédige un commentaire libre.
class MissionReviewScreen extends StatefulWidget {
  final String missionId;
  final ReviewMissionContext? context;

  const MissionReviewScreen({
    super.key,
    required this.missionId,
    this.context,
  });

  @override
  State<MissionReviewScreen> createState() => _MissionReviewScreenState();
}

class _MissionReviewScreenState extends State<MissionReviewScreen> {
  int _rating = 0;
  bool _recommend = true;
  final _commentCtrl = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _submitting = false;

  static const _positiveTags = [
    'Ponctuel',
    'Professionnel',
    'Travail soigné',
    'À l\'écoute',
    'Bon rapport qualité-prix',
    'Propre',
    'Rapide',
    'Expert',
  ];

  static const _negativeTags = [
    'En retard',
    'Travail bâclé',
    'Trop cher',
    'Peu communicant',
    'Mauvais matériel',
    'À éviter',
  ];

  List<String> get _availableTags =>
      _rating >= 4 ? _positiveTags : (_rating == 0 ? const [] : _negativeTags);

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sélectionnez une note avant d\'envoyer.'),
          backgroundColor: PrestaHubTheme.warning,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merci pour votre avis !'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
    Navigator.of(context).maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ctx = widget.context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        body: SafeArea(
          child: Column(
            children: [
              _Header(onBack: () => Navigator.of(context).maybePop()),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _MissionHeader(context: ctx),
                    const SizedBox(height: 20),
                    _RatingBlock(
                      rating: _rating,
                      onChanged: (v) => setState(() {
                        _rating = v;
                        _selectedTags.clear();
                      }),
                    ),
                    if (_rating > 0) ...[
                      const SizedBox(height: 20),
                      _TagsBlock(
                        title: _rating >= 4
                            ? 'Qu\'avez-vous apprécié ?'
                            : 'Qu\'est-ce qui n\'a pas été ?',
                        tags: _availableTags,
                        selected: _selectedTags,
                        onToggle: (tag) => setState(() {
                          if (_selectedTags.contains(tag)) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        }),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _CommentBlock(controller: _commentCtrl),
                    const SizedBox(height: 20),
                    _RecommendBlock(
                      value: _recommend,
                      onChanged: (v) => setState(() => _recommend = v),
                    ),
                  ],
                ),
              ),
              _BottomBar(
                submitting: _submitting,
                enabled: _rating > 0 && !_submitting,
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back_rounded,
                  color: PrestaHubTheme.textLight, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Noter la mission',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Partagez votre expérience avec la communauté',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionHeader extends StatelessWidget {
  final ReviewMissionContext? context;

  const _MissionHeader({required this.context});

  @override
  Widget build(BuildContext ctx) {
    final c = context;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(
              c?.providerInitials ?? '?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c?.missionTitle ?? 'Mission',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  c != null
                      ? '${c.providerName} · ${c.completedOn}'
                      : 'Prestataire',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBlock extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _RatingBlock({required this.rating, required this.onChanged});

  static const _labels = {
    0: 'Touchez les étoiles pour noter',
    1: 'Très insatisfait',
    2: 'Insatisfait',
    3: 'Correct',
    4: 'Très bien',
    5: 'Excellent',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        children: [
          Text(
            'Votre note globale',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: PrestaHubTheme.textMutedLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < rating;
              return GestureDetector(
                onTap: () => onChanged(i + 1),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    filled
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 42,
                    color: filled
                        ? PrestaHubTheme.warning
                        : PrestaHubTheme.borderStrong,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            _labels[rating] ?? '',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: rating == 0
                  ? PrestaHubTheme.textMutedLight
                  : PrestaHubTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsBlock extends StatelessWidget {
  final String title;
  final List<String> tags;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _TagsBlock({
    required this.title,
    required this.tags,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = selected.contains(tag);
            return GestureDetector(
              onTap: () => onToggle(tag),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? PrestaHubTheme.primary.withValues(alpha: 0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.check_rounded,
                            size: 14, color: PrestaHubTheme.primary),
                      ),
                    Text(
                      tag,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? PrestaHubTheme.primary
                            : PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CommentBlock extends StatelessWidget {
  final TextEditingController controller;

  const _CommentBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            'Votre commentaire (optionnel)',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
        ),
        TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 500,
          style: GoogleFonts.inter(fontSize: 13.5),
          decoration: InputDecoration(
            hintText:
                'Décrivez votre expérience pour aider la communauté...',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5,
              color: PrestaHubTheme.textMutedLight,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PrestaHubTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: PrestaHubTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendBlock extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RecommendBlock({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.thumb_up_outlined,
                color: PrestaHubTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommander ce prestataire',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Visible par les autres clients',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: PrestaHubTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool submitting;
  final bool enabled;
  final VoidCallback onSubmit;

  const _BottomBar({
    required this.submitting,
    required this.enabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: enabled ? onSubmit : null,
          icon: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : const Icon(Icons.send_rounded, size: 18),
          label: Text(
            submitting ? 'Envoi...' : 'Publier l\'avis',
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: PrestaHubTheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: PrestaHubTheme.borderStrong,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

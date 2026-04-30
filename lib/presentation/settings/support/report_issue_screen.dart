import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Formulaire dédié au signalement d'un problème technique ou fonctionnel.
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _steps = TextEditingController();
  String _severity = 'medium';
  bool _includeDiagnostics = true;
  final List<String> _attachments = [];
  bool _submitting = false;

  @override
  void dispose() {
    _description.dispose();
    _steps.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _submitting = false);
    _description.clear();
    _steps.clear();
    _attachments.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signalement enregistré. Merci pour votre retour.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Signaler un problème',
      subtitle: 'Aidez-nous à améliorer PrestaHub',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          physics: const BouncingScrollPhysics(),
          children: [
            _Label('Gravité'),
            Row(
              children: [
                _SeverityChip(
                  label: 'Faible',
                  value: 'low',
                  selected: _severity == 'low',
                  color: PrestaHubTheme.info,
                  onTap: () => setState(() => _severity = 'low'),
                ),
                const SizedBox(width: 8),
                _SeverityChip(
                  label: 'Modérée',
                  value: 'medium',
                  selected: _severity == 'medium',
                  color: PrestaHubTheme.warning,
                  onTap: () => setState(() => _severity = 'medium'),
                ),
                const SizedBox(width: 8),
                _SeverityChip(
                  label: 'Critique',
                  value: 'high',
                  selected: _severity == 'high',
                  color: PrestaHubTheme.danger,
                  onTap: () => setState(() => _severity = 'high'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Label('Description'),
            TextFormField(
              controller: _description,
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.trim().length < 10) ? 'Au moins 10 caractères' : null,
              style: GoogleFonts.inter(fontSize: 14),
              decoration:
                  _fieldDecoration(hint: 'Décrivez ce qui s\'est passé...'),
            ),
            const SizedBox(height: 14),
            _Label('Étapes pour reproduire (optionnel)'),
            TextFormField(
              controller: _steps,
              maxLines: 4,
              style: GoogleFonts.inter(fontSize: 14),
              decoration: _fieldDecoration(
                  hint: '1. J\'ai ouvert...\n2. J\'ai cliqué sur...\n3. ...'),
            ),
            const SizedBox(height: 14),
            _AttachmentPicker(
              attachments: _attachments,
              onAdd: (path) => setState(() => _attachments.add(path)),
              onRemove: (path) => setState(() => _attachments.remove(path)),
            ),
            const SizedBox(height: 14),
            _DiagnosticsSwitch(
              value: _includeDiagnostics,
              onChanged: (v) => setState(() => _includeDiagnostics = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.bug_report_rounded, size: 18),
                label: Text(
                  _submitting ? 'Envoi...' : 'Envoyer le signalement',
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrestaHubTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: PrestaHubTheme.textMutedLight,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PrestaHubTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: PrestaHubTheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PrestaHubTheme.danger),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SeverityChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : PrestaHubTheme.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? color : PrestaHubTheme.textMutedLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentPicker extends StatelessWidget {
  final List<String> attachments;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const _AttachmentPicker({
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file_rounded,
                  size: 18, color: PrestaHubTheme.textMutedLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Captures d\'écran (optionnel)',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => onAdd(
                    'screenshot_${DateTime.now().millisecondsSinceEpoch}.png'),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Ajouter'),
                style: TextButton.styleFrom(
                  foregroundColor: PrestaHubTheme.primary,
                  textStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (attachments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Ajoutez une image pour illustrer le problème.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            )
          else
            ...attachments.map((path) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.image_outlined,
                          size: 18, color: PrestaHubTheme.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          path,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: PrestaHubTheme.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemove(path),
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: PrestaHubTheme.danger),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

class _DiagnosticsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DiagnosticsSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.bug_report_outlined,
              size: 20, color: PrestaHubTheme.info),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Joindre les logs diagnostiques',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nous aide à résoudre plus vite le problème',
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: PrestaHubTheme.textMutedLight,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Formulaire de contact du support.
class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _topic = 'compte';
  bool _submitting = false;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _submitting = false);
    _subject.clear();
    _message.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message envoyé. Nous vous répondrons sous 24h.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Contacter le support',
      subtitle: 'Nous vous répondons sous 24h en moyenne',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          physics: const BouncingScrollPhysics(),
          children: [
            _Label('Sujet'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _topic,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: PrestaHubTheme.textMutedLight),
                    items: const [
                      DropdownMenuItem(
                          value: 'compte', child: Text('Problème de compte')),
                      DropdownMenuItem(
                          value: 'paiement',
                          child: Text('Problème de paiement')),
                      DropdownMenuItem(
                          value: 'demande',
                          child: Text('Problème avec une demande')),
                      DropdownMenuItem(
                          value: 'prestataire',
                          child: Text('Problème avec un prestataire')),
                      DropdownMenuItem(
                          value: 'autre', child: Text('Autre')),
                    ],
                    onChanged: (v) => setState(() => _topic = v ?? 'autre'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _Label('Titre du message'),
            TextFormField(
              controller: _subject,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Titre requis' : null,
              style: GoogleFonts.inter(fontSize: 14),
              decoration: _fieldDecoration(hint: 'Résumez votre problème'),
            ),
            const SizedBox(height: 14),
            _Label('Description détaillée'),
            TextFormField(
              controller: _message,
              maxLines: 6,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Message requis';
                if (v.trim().length < 20) {
                  return 'Minimum 20 caractères pour nous aider';
                }
                return null;
              },
              style: GoogleFonts.inter(fontSize: 14),
              decoration: _fieldDecoration(
                  hint: 'Décrivez le plus précisément possible...'),
            ),
            const SizedBox(height: 28),
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
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _submitting ? 'Envoi...' : 'Envoyer le message',
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

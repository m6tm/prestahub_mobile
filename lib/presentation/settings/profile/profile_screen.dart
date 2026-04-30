import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/settings_scaffold.dart';

/// Affiche les informations de profil de l'utilisateur courant.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _localAvatar;
  bool _avatarRemoved = false;

  Future<void> _openAvatarPicker() async {
    final user = ref.read(currentUserProvider);
    final hasAvatar = _localAvatar != null ||
        (!_avatarRemoved && (user?.avatarUrl?.isNotEmpty ?? false));
    final result = await showAvatarPicker(context, canRemove: hasAvatar);
    if (!mounted || result == null) return;
    setState(() {
      switch (result.type) {
        case AvatarPickResult.picked:
          _localAvatar = result.file;
          _avatarRemoved = false;
          break;
        case AvatarPickResult.removed:
          _localAvatar = null;
          _avatarRemoved = true;
          break;
      }
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.type == AvatarPickResult.removed
              ? 'Photo de profil supprimée.'
              : 'Photo de profil mise à jour.',
        ),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final remoteUrl = _avatarRemoved ? null : user?.avatarUrl;

    return SettingsScaffold(
      title: 'Mon profil',
      subtitle: 'Informations personnelles',
      actions: [
        _HeaderButton(
          icon: Icons.edit_rounded,
          onTap: () =>
              context.push(AppConstants.routeSettingsProfileEdit),
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _AvatarBlock(
              initials: _initials(user?.displayName ?? '?'),
              name: user?.displayName ?? 'Utilisateur',
              email: user?.email ?? '',
              pickedFile: _localAvatar,
              remoteUrl: remoteUrl,
              onEdit: _openAvatarPicker,
            ),
            const SizedBox(height: 24),
            _InfoField(
              label: 'Prénom',
              value: user?.firstName ?? '-',
              icon: Icons.badge_outlined,
            ),
            _InfoField(
              label: 'Nom',
              value: user?.lastName ?? '-',
              icon: Icons.badge_outlined,
            ),
            _InfoField(
              label: 'Adresse email',
              value: user?.email ?? '-',
              icon: Icons.alternate_email_rounded,
              verified: user?.isVerified ?? false,
            ),
            _InfoField(
              label: 'Téléphone',
              value: user?.phone ?? '-',
              icon: Icons.phone_outlined,
            ),
            _InfoField(
              label: 'Membre depuis',
              value: user != null
                  ? '${user.createdAt.day.toString().padLeft(2, '0')}/${user.createdAt.month.toString().padLeft(2, '0')}/${user.createdAt.year}'
                  : '-',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('Modifier mes informations'),
                onPressed: () =>
                    context.push(AppConstants.routeSettingsProfileEdit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrestaHubTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}

class _AvatarBlock extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final File? pickedFile;
  final String? remoteUrl;
  final VoidCallback onEdit;

  const _AvatarBlock({
    required this.initials,
    required this.name,
    required this.email,
    required this.pickedFile,
    required this.remoteUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedFile != null ||
        (remoteUrl != null && remoteUrl!.isNotEmpty);
    return Column(
      children: [
        GestureDetector(
          onTap: onEdit,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  image: pickedFile != null
                      ? DecorationImage(
                          image: FileImage(pickedFile!),
                          fit: BoxFit.cover,
                        )
                      : (remoteUrl != null && remoteUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(remoteUrl!),
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
                alignment: Alignment.center,
                child: hasImage
                    ? null
                    : Text(
                        initials,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool verified;

  const _InfoField({
    required this.label,
    required this.value,
    required this.icon,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: PrestaHubTheme.textMutedLight),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: PrestaHubTheme.textMutedLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: PrestaHubTheme.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (verified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: PrestaHubTheme.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded,
                      size: 12, color: PrestaHubTheme.success),
                  const SizedBox(width: 4),
                  Text(
                    'Vérifié',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.success,
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

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: PrestaHubTheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: PrestaHubTheme.primary),
      ),
    );
  }
}

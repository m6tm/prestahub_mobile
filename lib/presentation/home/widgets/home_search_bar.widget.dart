import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded,
                  color: Color(0xFF9CA3AF), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Plombier, électricien, ménage…',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 14),
              const Icon(Icons.tune_rounded,
                  size: 18, color: Color(0xFF7C3AED)),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}

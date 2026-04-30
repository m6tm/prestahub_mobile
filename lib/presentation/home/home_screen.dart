import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/presentation/home/widgets/home_header.widget.dart';
import 'package:prestahub/presentation/home/widgets/home_search_bar.widget.dart';
import 'package:prestahub/presentation/home/widgets/home_popular_categories.widget.dart';
import 'package:prestahub/presentation/home/widgets/home_nearby_providers.widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: HomeHeader(onNotificationTap: () {})),
              SliverToBoxAdapter(
                child: HomeSearchBar(
                  onTap: () => context.push(AppConstants.routeClientSearch),
                ),
              ),
              const SliverToBoxAdapter(child: HomePopularCategories()),
              const SliverToBoxAdapter(child: HomeNearbyProviders()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _navIndex,
          onTap: (i) async {
            if (i == 1) {
              context.push(AppConstants.routeClientSearch);
              return;
            }
            if (i == 2) {
              context.push(AppConstants.routeClientRequests);
              return;
            }
            if (i == 3) {
              context.push(AppConstants.routeClientMessages);
              return;
            }
            if (i == 4) {
              context.push(AppConstants.routeClientProfile);
              return;
            }
            setState(() => _navIndex = i);
          },
        ),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Accueil'),
    (Icons.search_rounded, Icons.search_outlined, 'Recherche'),
    (Icons.description_rounded, Icons.description_outlined, 'Missions'),
    (Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'Messages'),
    (Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: _items.asMap().entries.map((e) {
          final i = e.key;
          final (activeIcon, inactiveIcon, label) = e.value;
          final isActive = currentIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? activeIcon : inactiveIcon,
                    size: 22,
                    color: isActive
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

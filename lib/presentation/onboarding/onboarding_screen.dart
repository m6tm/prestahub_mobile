import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/core/theme/app_theme.dart';
import 'package:prestahub/l10n/translations.g.dart';
import 'package:prestahub/presentation/onboarding/widgets/onboarding_page.dart';

/// Écran principal d'onboarding avec PageView.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      {
        'title': t.onboarding.pages.find.title,
        'description': t.onboarding.pages.find.description,
        'icon': Icons.search_rounded,
      },
      {
        'title': t.onboarding.pages.book.title,
        'description': t.onboarding.pages.book.description,
        'icon': Icons.calendar_month_rounded,
      },
      {
        'title': t.onboarding.pages.rate.title,
        'description': t.onboarding.pages.rate.description,
        'icon': Icons.star_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: PrestaHubTheme.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            // Bouton Skip (Ignorer)
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: () => context.go(AppConstants.routeLogin),
                child: Text(
                  t.onboarding.skip,
                  style: const TextStyle(
                    color: PrestaHubTheme.textMutedLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Logo discret en haut à gauche
            Positioned(
              top: 20,
              left: 30,
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: PrestaHubTheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'PrestaHub',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // PageView
            Column(
              children: [
                const Spacer(flex: 3),
                SizedBox(
                  height: 480,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return OnboardingPage(
                        title: page['title'] as String,
                        description: page['description'] as String,
                        icon: page['icon'] as IconData,
                      );
                    },
                  ),
                ),
                const Spacer(flex: 2),
                
                // Indicateur de progression (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 6,
                      width: _currentPage == index ? 24 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? PrestaHubTheme.primary 
                            : PrestaHubTheme.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Bouton d'action principal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go(AppConstants.routeLogin);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: PrestaHubTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == pages.length - 1 
                              ? t.onboarding.start 
                              : t.onboarding.next,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../models/service_request_models.dart';
import 'widgets/request_category_step.dart';
import 'widgets/request_description_step.dart';
import 'widgets/request_address_step.dart';
import 'widgets/request_schedule_step.dart';

class RequestCreateScreen extends StatefulWidget {
  const RequestCreateScreen({super.key});

  @override
  State<RequestCreateScreen> createState() => _RequestCreateScreenState();
}

class _RequestCreateScreenState extends State<RequestCreateScreen> {
  final PageController _pageCtrl = PageController();
  final ServiceRequestDraft _draft = ServiceRequestDraft();
  int _step = 0;

  static const _stepCount = 4;
  static const _stepLabels = [
    'Catégorie',
    'Description',
    'Adresse',
    'Créneaux',
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_step) {
      case 0:
        return _draft.hasCategory;
      case 1:
        return _draft.hasDescription;
      case 2:
        return _draft.hasAddress;
      case 3:
        return _draft.hasSchedule;
      default:
        return false;
    }
  }

  void _onNext() {
    if (!_canProceed) return;

    if (_step < _stepCount - 1) {
      setState(() => _step++);
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.push(
        AppConstants.routeClientRequestReview,
        extra: _draft,
      );
    }
  }

  void _onBack() {
    if (_step == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => _step--);
    _pageCtrl.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgress(),
              Expanded(
                child: PageView(
                  controller: _pageCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RequestCategoryStep(
                      draft: _draft,
                      onChanged: () => setState(() {}),
                    ),
                    RequestDescriptionStep(
                      draft: _draft,
                      onChanged: () => setState(() {}),
                    ),
                    RequestAddressStep(
                      draft: _draft,
                      onChanged: () => setState(() {}),
                    ),
                    RequestScheduleStep(
                      draft: _draft,
                      onChanged: () => setState(() {}),
                    ),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: PrestaHubTheme.textMutedLight),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nouvelle demande',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Étape ${_step + 1} sur $_stepCount · ${_stepLabels[_step]}',
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

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: List.generate(_stepCount, (i) {
          final isActive = i <= _step;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == _stepCount - 1 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? PrestaHubTheme.primary
                    : PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomBar() {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      decoration: const BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: GestureDetector(
                onTap: _onBack,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.backgroundLight,
                    border: Border.all(color: PrestaHubTheme.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Retour',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ),
              ),
            ),
          if (_step > 0) const SizedBox(width: 10),
          Expanded(
            flex: _step > 0 ? 1 : 2,
            child: GestureDetector(
              onTap: _canProceed ? _onNext : null,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _canProceed
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _step == _stepCount - 1 ? 'Récapitulatif' : 'Continuer',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _canProceed
                            ? PrestaHubTheme.primaryContent
                            : PrestaHubTheme.borderStrong,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: _canProceed
                          ? PrestaHubTheme.primaryContent
                          : PrestaHubTheme.borderStrong,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

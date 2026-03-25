import 'package:flutter/material.dart';
import 'package:prestahub/l10n/translations.g.dart';
import 'widgets/otp_header.dart';
import 'widgets/otp_illustration.dart';
import 'widgets/otp_inputs.dart';
import 'widgets/otp_resend_section.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors based on the Stitch HTML
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF171121) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF171121) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    color: surfaceColor,
                    width: double.infinity,
                    child: Column(
                      children: [
                        const OtpHeader(),
                        const OtpIllustration(),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              Text(
                                t.auth.otpVerificationScreen.instruction,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                '+221 77 123 45 67',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 40),
                              const OtpInputs(),
                              const SizedBox(height: 40),
                              const OtpResendSection(),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 24),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              // Verify Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Add verification logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    shadowColor: Theme.of(context).primaryColor.withOpacity(0.25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    t.auth.otpVerificationScreen.verifyButton,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Bottom indicator line (iOS style)
                              Container(
                                width: 128,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[700] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

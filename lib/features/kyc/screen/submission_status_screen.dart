import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:japfa_task/core/constant/app_constant.dart';

import '../../../router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/pulsing_status_icon.dart';
import '../widgets/reference_card.dart';
import '../widgets/step_card.dart';

class SubmissionStatusScreen extends StatefulWidget {
  const SubmissionStatusScreen({super.key});

  @override
  State<SubmissionStatusScreen> createState() => _SubmissionStatusScreenState();
}

class _SubmissionStatusScreenState extends State<SubmissionStatusScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final AnimationController _staggerController;

  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _iconScaleAnimation;
  late final Animation<double> _card1Animation;
  late final Animation<double> _card2Animation;
  late final Animation<double> _card3Animation;

  @override
  void initState() {
    super.initState();

    // Pulse ring — continuous
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade in for the whole screen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Staggered entrance for the 3 step cards
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _card1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _card2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _card3Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;


    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Submission Status'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        // No back button — submission is terminal state
        automaticallyImplyLeading: false,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Pulsing status icon ──────────────────────────────────────
              PulsingStatusIcon(
                scaleAnimation: _iconScaleAnimation,
                pulseAnimation: _pulseAnimation,
              ),

              const SizedBox(height: 28),

              // ── Status title ─────────────────────────────────────────────
              Text(
                'Documents Submitted',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height:AppConstants.height10),

              // ── Status subtitle ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.warning,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Awaiting SAP MDM Verification',
                      style: textTheme.labelLarge?.copyWith(
                        color: AppTheme.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your documents have been received and are\nbeing reviewed by the verification team.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ── Reference info card ──────────────────────────────────────
              const ReferenceCard(),

              const SizedBox(height: 28),

              // ── Verification steps ───────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Verification Steps',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.cardRadius),

              StepCard(
                animation: _card1Animation,
                step: 1,
                icon: Icons.cloud_upload_outlined,
                title: 'Documents Received',
                subtitle: 'All mandatory documents uploaded successfully.',
                isCompleted: true,
              ),

              const SizedBox(height:AppConstants.height10),

              StepCard(
                animation: _card2Animation,
                step: 2,
                icon: Icons.manage_search_outlined,
                title: 'SAP MDM Verification',
                subtitle: 'Team is verifying identity and business documents.',
                isCompleted: false,
                isActive: true,
              ),

              const SizedBox(height:AppConstants.height10),

              StepCard(
                animation: _card3Animation,
                step: 3,
                icon: Icons.verified_user_outlined,
                title: 'Account Activation',
                subtitle: 'Customer account created in SAP after approval.',
                isCompleted: false,
                isActive: false,
              ),

              const SizedBox(height: 32),

              // ── Info note ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verification typically takes 1–2 business days. '
                            'You will be notified once the review is complete.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Back to visit plan CTA ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRoutes.visitPlan),
                  icon: const Icon(Icons.home_outlined, size: 20),
                  label: const Text(
                    'Back to Visit Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.height10,),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRoutes.dashboard),
                  icon: const Icon(Icons.dashboard, size: 20),
                  label: const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// ─────────────────────────────────────────────────────────────────────────────
// Verification step card
// ─────────────────────────────────────────────────────────────────────────────


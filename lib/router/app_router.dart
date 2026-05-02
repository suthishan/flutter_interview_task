import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:japfa_task/core/models/visit_model.dart';
import 'package:japfa_task/features/dashboard/screen/dashboard_lead_detail_screen.dart';
import 'package:japfa_task/features/dashboard/screen/dashboard_screen.dart';

import '../features/check_in/screen/check_in_screen.dart';
import '../features/kyc/screen/kyc_screen.dart';
import '../features/kyc/screen/submission_status_screen.dart';
import '../features/lead/screen/lead_form_screen.dart';
import '../features/visit_plan/screen/add_visit_screen.dart';
import '../features/visit_plan/screen/visit_detail_screen.dart';
import '../features/visit_plan/screen/visit_plan_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Route name constants — use these everywhere instead of raw strings
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppRoutes {
  static const visitPlan   = 'visitPlan';
  static const visitDetail = 'visitDetail';
  static const addVisit    = 'addVisit';
  static const checkIn     = 'checkIn';
  static const leadForm    = 'leadForm';
  static const kyc         = 'kyc';
  static const submissionStatus = 'submissionStatus';
  static const dashboard = 'dashboard';
  static const dashboardLeadDetail = 'dashboardLeadDetail';
}

// ─────────────────────────────────────────────────────────────────────────────
// router
// ─────────────────────────────────────────────────────────────────────────────
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false, // set true during development
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
  routes: [
    // ── Task 1 ───────────────────────────────────────────────────────────────
    GoRoute(
      path: '/',
      name: AppRoutes.visitPlan,
      builder: (context, state) => const VisitPlanScreen(),
    ),

    GoRoute(
      path: '/visit-detail/:id',
      name: AppRoutes.visitDetail,
      builder: (context, state) {
        // Pass VisitModel via `extra`; id from pathParam as fallback
        final visit = state.extra as VisitModel?;
        final visitId = state.pathParameters['id'] ?? '';

        return VisitDetailScreen(visit: visit, visitId: visitId);
      },
    ),

    GoRoute(
      path: '/add-visit',
      name: AppRoutes.addVisit,
      builder: (context, state) => const AddVisitScreen(),
    ),

    // ── Task 2 ───────────────────────────────────────────────────────────────
    GoRoute(
      path: '/check-in/:visitId',
      name: AppRoutes.checkIn,
      builder: (context, state) {
        final visit = state.extra as VisitModel?;
        final visitId = state.pathParameters['visitId'] ?? '';
        return CheckInScreen(visit: visit, visitId: visitId);
      },
    ),

    // ── Task 3 ───────────────────────────────────────────────────────────────
    GoRoute(
      path: '/lead-form',
      name: AppRoutes.leadForm,
      builder: (context, state) => const LeadFormScreen(),
    ),

    // ── Task 4 ───────────────────────────────────────────────────────────────
    GoRoute(
      path: '/kyc',
      name: AppRoutes.kyc,
      builder: (context, state) => const KycScreen(),
    ),

    GoRoute(
      path: '/submission-status',
      name: AppRoutes.submissionStatus,
      builder: (context, state) => const SubmissionStatusScreen(),
    ),

    GoRoute(
      path: '/dashboard',
      name: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
        path: '/dashboardLeadDetail/:id',
      name: AppRoutes.dashboardLeadDetail,
      builder: (context, state) {
        final leadId = state.pathParameters['id'] ?? '';
        return DashboardLeadDetailScreen(leadId: leadId);

      }),
  ],
);
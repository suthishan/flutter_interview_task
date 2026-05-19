import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:japfa_pocket_feed/features/check_in/screens/check_in_screen.dart';
import 'package:japfa_pocket_feed/features/dashboard/lead_detail_screen.dart';
import 'package:japfa_pocket_feed/features/dashboard/screens/dashboard_screen.dart';
import 'package:japfa_pocket_feed/features/kyc/screens/kyc_upload_screen.dart';
import 'package:japfa_pocket_feed/features/lead/screens/lead_form_screen.dart';
import 'package:japfa_pocket_feed/features/visit_plan/screens/visit_plan_screen.dart';

class StubScreen extends StatelessWidget {
  final String title;
  const StubScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.update, size: 64, color: Colors.grey.shade400),
          Text(
            '$title Comming Soon!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const VisitPlanScreen()),
    GoRoute(
      path: '/add-visit',
      builder: (_, __) => const StubScreen(title: 'Add Visit'),
    ),
    GoRoute(
      path: '/visit-detail',
      builder: (_, state) => StubScreen(title: 'Visit Detail'),
    ),
    GoRoute(
      path: '/check-in',
      builder: (_, state) {
        final visitId = state.extra as String?;
        return CheckInScreen(visitId: visitId);
      },
    ),
    GoRoute(path: '/lead-form', builder: (_, __) => const LeadFormScreen()),
    GoRoute(path: '/kyc-upload', builder: (_, __) => const KycUploadScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(
      path: '/lead-detail',
      builder: (_, state) {
        final leadId = state.extra as String;
        return LeadDetailScreen(leadId: leadId);
      },
    ),
  ],
);

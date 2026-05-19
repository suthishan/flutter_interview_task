import 'package:flutter/material.dart';
import 'package:japfa_pocket_feed/features/check_in/providers/check_in_provider.dart';
import 'package:japfa_pocket_feed/features/dashboard/providers/dashboard_provider.dart';
import 'package:japfa_pocket_feed/features/kyc/providers/kyc_provider.dart';
import 'package:japfa_pocket_feed/features/lead/providers/lead_provider.dart';
import 'package:provider/provider.dart';
import 'package:japfa_pocket_feed/core/theme/app_theme.dart';
import 'package:japfa_pocket_feed/core/routes/app_router.dart';
import 'package:japfa_pocket_feed/features/visit_plan/providers/visit_plan_provider.dart';

void main() {
  runApp(const PocketFeedApp());
}

class PocketFeedApp extends StatelessWidget {
  const PocketFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitPlanProvider()),
        ChangeNotifierProvider(create: (_) => CheckInProvider()),
        ChangeNotifierProvider(create: (_) => LeadProvider()),
        ChangeNotifierProvider(create: (_) => KycProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        title: 'Japfa Pocket Feed',
      ),
    );
  }
}

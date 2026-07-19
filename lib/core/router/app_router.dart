import 'package:go_router/go_router.dart';

import '../../features/groups/presentation/screens/home_screen.dart';

/// Route path constants.
///
/// All route paths in one place. Never hardcode paths in widgets.
/// New routes are added here as features are built.
abstract final class AppRoutes {
  static const String home = '/';
}

/// App router configuration using GoRouter.
///
/// Routes are added incrementally as features are built.
/// Each feature branch adds its own routes here.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

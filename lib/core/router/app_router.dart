import 'package:go_router/go_router.dart';

import '../../features/groups/presentation/screens/create_group_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/groups/presentation/screens/groups_screen.dart';

/// Route path constants.
///
/// All route paths in one place. Never hardcode paths in widgets.
/// New routes are added here as features are built.
abstract final class AppRoutes {
  static const String home = '/';
  static const String createGroup = '/create-group';
  static const String groupDetail = '/group/:groupId';
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
      builder: (context, state) => const GroupsScreen(),
    ),
    GoRoute(
      path: AppRoutes.createGroup,
      name: 'createGroup',
      builder: (context, state) => const CreateGroupScreen(),
    ),
    GoRoute(
      path: AppRoutes.groupDetail,
      name: 'groupDetail',
      builder: (context, state) {
        final groupId = state.pathParameters['groupId']!;
        return GroupDetailScreen(groupId: groupId);
      },
    ),
  ],
);

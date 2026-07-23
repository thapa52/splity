import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/groups/data/models/group_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(GroupModelAdapter());

  // Open Hive boxes
  await Hive.openBox<GroupModel>(AppConstants.groupsBox);

  runApp(const ProviderScope(child: SplityApp()));
}

/// Root widget for Splity.
///
/// Wrapped in [ProviderScope] for Riverpod state management.
/// Uses [GoRouter] for navigation and custom [AppTheme] for styling.
class SplityApp extends StatelessWidget {
  const SplityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Splity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}

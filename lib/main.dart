import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/expenses/data/models/expense_model.dart';
import 'features/expenses/data/models/expense_split_model.dart';
import 'features/groups/data/models/group_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(GroupModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(ExpenseSplitModelAdapter());

  // Open Hive boxes
  await Hive.openBox<GroupModel>(AppConstants.groupsBox);
  await Hive.openBox<ExpenseModel>(AppConstants.expensesBox);

  runApp(const ProviderScope(child: SplityApp()));
}

/// Root widget for Splity.
///
/// Watches [ThemeNotifier] for dynamic theme switching.
class SplityApp extends ConsumerWidget {
  const SplityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'Splity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}

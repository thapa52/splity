import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/group_provider.dart';
import '../widgets/group_card.dart';

/// Home screen that displays all groups.
///
/// Shows a summary stats card, list of group cards,
/// and handles loading, error, and empty states.
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💸', style: TextStyle(fontSize: 22)),
            Gap(8),
            Text('Splity'),
          ],
        ),
        actions: [
          // === THEME TOGGLE ===
          Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeNotifierProvider);
              final isDarkMode =
                  themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);

              return IconButton(
                icon: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed:
                    () =>
                        ref.read(themeNotifierProvider.notifier).toggleTheme(),
                tooltip: isDarkMode ? 'Switch to Light' : 'Switch to Dark',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: _buildBody(context, ref, groupState, isDark),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createGroup),
        icon: const Icon(Icons.group_add_rounded),
        label: const Text('New Group'),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    GroupState state,
    bool isDark,
  ) {
    if (state.isLoading) {
      return const LoadingWidget(message: 'Loading groups...');
    }

    if (state.hasError) {
      return AppErrorWidget(
        message: state.errorMessage ?? 'Failed to load groups',
        onRetry: () => ref.read(groupNotifierProvider.notifier).refresh(),
      );
    }

    if (!state.hasGroups) {
      return EmptyStateWidget(
        icon: Icons.group_outlined,
        title: 'No groups yet',
        subtitle:
            'Create your first group to start\nsplitting expenses with friends!',
        buttonLabel: 'Create Group',
        onButtonPressed: () => context.push(AppRoutes.createGroup),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(groupNotifierProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          // === STATS SUMMARY CARD ===
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildStatsCard(state, isDark),
            ),
          ),

          // === GROUPS LIST ===
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final group = state.groups[index];
              return GroupCard(
                group: group,
                onTap: () => context.push('/group/${group.id}'),
                onDelete: () => _deleteGroup(context, ref, group.id),
              );
            }, childCount: state.groups.length),
          ),

          // === BOTTOM PADDING FOR FAB ===
          const SliverToBoxAdapter(child: Gap(100)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(GroupState state, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                label: 'Groups',
                value: '${state.groups.length}',
                icon: Icons.group_rounded,
                color: AppColors.primary,
                isDark: isDark,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: _buildStatItem(
                label: 'Members',
                value:
                    '${state.groups.fold<int>(0, (sum, g) => sum + g.members.length)}',
                icon: Icons.people_rounded,
                color: AppColors.secondary,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const Gap(8),
        Text(value, style: AppTextStyles.h2.copyWith(color: color)),
        const Gap(2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Future<void> _deleteGroup(
    BuildContext context,
    WidgetRef ref,
    String groupId,
  ) async {
    final success = await ref
        .read(groupNotifierProvider.notifier)
        .removeGroup(groupId);

    if (context.mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete group'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                const Text('💸 '),
                Text('About Splity', style: AppTextStyles.h3),
              ],
            ),
            content: Text(
              'Splity is a smart bill splitter that helps you '
              'split expenses with friends and groups.\n\n'
              'Built with Flutter, Clean Architecture, and Riverpod.\n\n'
              'Version ${AppConstants.appVersion}',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../providers/group_provider.dart';
import '../widgets/group_card.dart';

/// Home screen that displays all groups.
///
/// Shows a list of group cards with swipe-to-delete.
/// FAB navigates to create group screen.
/// Empty state shown when no groups exist.
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splity'),
        actions: [
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
    // === LOADING STATE ===
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // === ERROR STATE ===
    if (state.hasError) {
      return _buildErrorState(context, ref, state, isDark);
    }

    // === EMPTY STATE ===
    if (!state.hasGroups) {
      return _buildEmptyState(isDark);
    }

    // === GROUPS LIST ===
    return _buildGroupsList(context, ref, state);
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    GroupState state,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const Gap(16),
            Text(
              state.errorMessage ?? 'Something went wrong',
              style: AppTextStyles.bodyLarge.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            ElevatedButton.icon(
              onPressed:
                  () => ref.read(groupNotifierProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No groups yet',
              style: AppTextStyles.h3.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            const Gap(8),
            Text(
              'Create your first group to start\nsplitting expenses with friends!',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(
    BuildContext context,
    WidgetRef ref,
    GroupState state,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(groupNotifierProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 100, // Space for FAB
        ),
        itemCount: state.groups.length,
        itemBuilder: (context, index) {
          final group = state.groups[index];
          return GroupCard(
            group: group,
            onTap: () => context.push('/group/${group.id}'),
            onDelete: () => _deleteGroup(context, ref, group.id),
          );
        },
      ),
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
            title: const Text('About Splity'),
            content: const Text(
              'Splity is a smart bill splitter that helps you '
              'split expenses with friends and groups.\n\n'
              'Built with Flutter, Clean Architecture, and Riverpod.',
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

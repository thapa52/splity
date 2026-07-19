import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Temporary home screen to verify theme and navigation work.
///
/// Will be replaced with the real groups list screen later.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splity')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text('Splity', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(
              'Smart Bill Splitter',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: const Text('Create Group')),
          ],
        ),
      ),
    );
  }
}

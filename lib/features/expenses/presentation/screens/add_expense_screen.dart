import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../groups/domain/entities/group.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_split.dart';
import '../providers/expense_provider.dart';
import '../widgets/split_summary_card.dart';

/// Screen for adding a new expense to a group.
///
/// Contains a form with:
/// - Expense title and optional description
/// - Amount input
/// - Category selector
/// - Who paid dropdown
/// - Split type toggle (equal / unequal)
/// - Split preview card
class AddExpenseScreen extends ConsumerStatefulWidget {
  final Group group;

  const AddExpenseScreen({super.key, required this.group});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = AppConstants.expenseCategories.first;
  String? _selectedPayer;
  bool _isEqualSplit = true;
  bool _isSubmitting = false;

  /// Controllers for unequal split amounts — one per member
  final Map<String, TextEditingController> _splitControllers = {};

  @override
  void initState() {
    super.initState();
    // Set first member as default payer
    if (widget.group.members.isNotEmpty) {
      _selectedPayer = widget.group.members.first;
    }

    // Create a controller for each member for unequal splits
    for (final member in widget.group.members) {
      _splitControllers[member] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    for (final controller in _splitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === TITLE ===
            _buildTitleField(),
            const Gap(16),

            // === DESCRIPTION ===
            _buildDescriptionField(),
            const Gap(16),

            // === AMOUNT ===
            _buildAmountField(),
            const Gap(24),

            // === CATEGORY ===
            _buildCategorySelector(isDark),
            const Gap(24),

            // === PAID BY ===
            _buildPayerSelector(isDark),
            const Gap(24),

            // === SPLIT TYPE TOGGLE ===
            _buildSplitToggle(isDark),
            const Gap(16),

            // === UNEQUAL SPLIT INPUTS ===
            if (!_isEqualSplit) ...[
              _buildUnequalSplitInputs(isDark),
              const Gap(16),
            ],

            // === SPLIT PREVIEW ===
            if (_amountController.text.isNotEmpty) ...[
              _buildSplitPreview(),
              const Gap(24),
            ],

            // === SUBMIT BUTTON ===
            _buildSubmitButton(),
            const Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Expense Title',
        hintText: 'e.g. Dinner, Uber, Groceries',
        prefixIcon: Icon(Icons.receipt_rounded),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        hintText: 'e.g. Friday night dinner at restaurant',
        prefixIcon: Icon(Icons.notes_rounded),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: '0.00',
        prefixIcon: Icon(Icons.currency_rupee_rounded),
        prefixText: '${AppConstants.currency} ',
      ),
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.labelLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.expenseCategories.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final category = AppConstants.expenseCategories[index];
              final isSelected = category == _selectedCategory;

              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight)
                                  .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    category,
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPayerSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paid by',
          style: AppTextStyles.labelLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.group.members.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final member = widget.group.members[index];
              final isSelected = member == _selectedPayer;

              return GestureDetector(
                onTap: () => setState(() => _selectedPayer = member),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.secondary
                              : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight)
                                  .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    member,
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSplitToggle(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Type',
          style: AppTextStyles.labelLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEqualSplit = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        _isEqualSplit ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _isEqualSplit
                              ? AppColors.primary
                              : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight)
                                  .withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Equal Split',
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          _isEqualSplit
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEqualSplit = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        !_isEqualSplit ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          !_isEqualSplit
                              ? AppColors.primary
                              : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight)
                                  .withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Unequal Split',
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          !_isEqualSplit
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnequalSplitInputs(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter each member\'s share',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const Gap(12),
        ...widget.group.members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _splitControllers[member],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: member,
                prefixText: '${AppConstants.currency} ',
                hintText: '0.00',
              ),
              onChanged: (_) => setState(() {}),
            ),
          );
        }),
        // === REMAINING AMOUNT INDICATOR ===
        _buildRemainingAmount(isDark),
      ],
    );
  }

  Widget _buildRemainingAmount(bool isDark) {
    final totalAmount = double.tryParse(_amountController.text) ?? 0;
    final splitSum = _calculateUnequalSplitSum();
    final remaining = totalAmount - splitSum;

    Color color;
    String text;

    if (remaining.abs() < 0.01) {
      color = AppColors.success;
      text = 'Splits add up correctly ✓';
    } else if (remaining > 0) {
      color = AppColors.warning;
      text =
          '${AppConstants.currency}${remaining.toStringAsFixed(2)} remaining to assign';
    } else {
      color = AppColors.error;
      text =
          '${AppConstants.currency}${remaining.abs().toStringAsFixed(2)} over the total amount';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            remaining.abs() < 0.01
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            color: color,
            size: 20,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitPreview() {
    final splits = _calculateSplits();
    if (splits.isEmpty) return const SizedBox.shrink();

    final amount = double.tryParse(_amountController.text) ?? 0;

    return SplitSummaryCard(
      splits: splits,
      paidBy: _selectedPayer ?? '',
      totalAmount: amount,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        child:
            _isSubmitting
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : const Text('Add Expense'),
      ),
    );
  }

  /// Calculates splits based on current split type.
  List<ExpenseSplit> _calculateSplits() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return [];

    if (_isEqualSplit) {
      return _calculateEqualSplits(amount);
    } else {
      return _calculateUnequalSplits();
    }
  }

  /// Splits amount equally among all members.
  ///
  /// Handles rounding by giving the remainder to the first member.
  /// Example: 100 / 3 = 33.33, 33.33, 33.34
  List<ExpenseSplit> _calculateEqualSplits(double amount) {
    final members = widget.group.members;
    final perPerson = (amount / members.length * 100).floor() / 100;
    final remainder = amount - (perPerson * members.length);

    return members.asMap().entries.map((entry) {
      final isFirst = entry.key == 0;
      final splitAmount =
          isFirst
              ? double.parse((perPerson + remainder).toStringAsFixed(2))
              : perPerson;

      return ExpenseSplit(memberName: entry.value, amount: splitAmount);
    }).toList();
  }

  /// Gets unequal split amounts from text controllers.
  List<ExpenseSplit> _calculateUnequalSplits() {
    return widget.group.members.map((member) {
      final controller = _splitControllers[member];
      final amount = double.tryParse(controller?.text ?? '') ?? 0;
      return ExpenseSplit(
        memberName: member,
        amount: double.parse(amount.toStringAsFixed(2)),
      );
    }).toList();
  }

  /// Sum of all unequal split amounts.
  double _calculateUnequalSplitSum() {
    return widget.group.members.fold<double>(0, (sum, member) {
      final controller = _splitControllers[member];
      final amount = double.tryParse(controller?.text ?? '') ?? 0;
      return sum + amount;
    });
  }

  /// Validates and submits the form.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select who paid'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final splits = _calculateSplits();

    // Validate unequal splits sum
    if (!_isEqualSplit) {
      final splitsSum = splits.fold<double>(
        0,
        (sum, split) => sum + split.amount,
      );
      final difference = (splitsSum - amount).abs();
      if (difference > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Split amounts must equal ${AppConstants.currency}${amount.toStringAsFixed(2)}',
            ),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final expense = Expense(
      id: const Uuid().v4(),
      groupId: widget.group.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: amount,
      category: _selectedCategory,
      paidBy: _selectedPayer!,
      splits: splits,
      createdAt: DateTime.now(),
    );

    final success = await ref
        .read(expenseNotifierProvider(widget.group.id).notifier)
        .addNewExpense(expense);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${expense.title} added!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else {
      final errorMessage =
          ref.read(expenseNotifierProvider(widget.group.id)).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Failed to add expense'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

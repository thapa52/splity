import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/group.dart';
import '../providers/group_provider.dart';
import '../widgets/member_chip.dart';

/// Available emojis for group selection.
const List<String> _groupEmojis = [
  '👥',
  '🏠',
  '✈️',
  '🍕',
  '🎉',
  '🏖️',
  '🎓',
  '💼',
  '🏕️',
  '🎮',
  '🍔',
  '☕',
  '🎬',
  '🛒',
  '⚽',
  '🎵',
];

/// Screen for creating a new group.
///
/// Contains a form with:
/// - Group name input
/// - Optional description
/// - Emoji picker
/// - Member name input with add/remove
class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _memberController = TextEditingController();

  String _selectedEmoji = '👥';
  final List<String> _members = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _memberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === EMOJI PICKER ===
            _buildEmojiPicker(isDark),
            const Gap(24),

            // === GROUP NAME ===
            _buildNameField(isDark),
            const Gap(16),

            // === DESCRIPTION ===
            _buildDescriptionField(isDark),
            const Gap(24),

            // === ADD MEMBERS SECTION ===
            _buildMembersSection(isDark),
            const Gap(32),

            // === CREATE BUTTON ===
            _buildCreateButton(),
            const Gap(16),
          ],
        ),
      ),
    );
  }

  /// Horizontal scrollable emoji picker.
  Widget _buildEmojiPicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose an icon',
          style: AppTextStyles.labelLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _groupEmojis.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final emoji = _groupEmojis[index];
              final isSelected = emoji == _selectedEmoji;

              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = emoji),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight)
                                  .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Group name text field with validation.
  Widget _buildNameField(bool isDark) {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Group Name',
        hintText: 'e.g. Goa Trip, Roommates',
        prefixIcon: Icon(Icons.group_rounded),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a group name';
        }
        return null;
      },
    );
  }

  /// Optional description field.
  Widget _buildDescriptionField(bool isDark) {
    return TextFormField(
      controller: _descriptionController,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        hintText: 'e.g. Weekend trip expenses',
        prefixIcon: Icon(Icons.notes_rounded),
      ),
    );
  }

  /// Members section with input field and chips.
  Widget _buildMembersSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members (${_members.length})',
          style: AppTextStyles.labelLarge.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(8),
        Text(
          'Add at least 2 members to split expenses',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const Gap(12),

        // === MEMBER INPUT ROW ===
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _memberController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Enter member name',
                  prefixIcon: Icon(Icons.person_add_rounded),
                ),
                onFieldSubmitted: (_) => _addMember(),
              ),
            ),
            const Gap(8),
            IconButton.filled(
              onPressed: _addMember,
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(48, 48),
              ),
            ),
          ],
        ),
        const Gap(16),

        // === MEMBER CHIPS ===
        if (_members.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _members
                    .map(
                      (member) => MemberChip(
                        name: member,
                        onRemove: () => _removeMember(member),
                      ),
                    )
                    .toList(),
          ),

        // === MINIMUM MEMBERS WARNING ===
        if (_members.isNotEmpty && _members.length < 2)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Add at least one more member',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
      ],
    );
  }

  /// Create group button.
  Widget _buildCreateButton() {
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
                : const Text('Create Group'),
      ),
    );
  }

  /// Adds a member to the list.
  void _addMember() {
    final name = _memberController.text.trim();

    if (name.isEmpty) {
      return;
    }

    // Check for duplicate names
    final isDuplicate = _members.any(
      (m) => m.toLowerCase() == name.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name is already added'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _members.add(name);
      _memberController.clear();
    });
  }

  /// Removes a member from the list.
  void _removeMember(String name) {
    setState(() {
      _members.remove(name);
    });
  }

  /// Validates and submits the form.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_members.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 2 members'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final group = Group(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      emoji: _selectedEmoji,
      members: List.from(_members),
      createdAt: DateTime.now(),
    );

    final success = await ref
        .read(groupNotifierProvider.notifier)
        .createNewGroup(group);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${group.name} created!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else {
      final errorMessage = ref.read(groupNotifierProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Failed to create group'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

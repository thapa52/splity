import 'package:flutter/material.dart';

/// Centralized color palette for Splity.
///
/// All colors used across the app should be referenced from here.
/// This makes theme changes and brand updates a single-file change.
abstract final class AppColors {
  // === PRIMARY ===
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);

  // === SECONDARY ===
  static const Color secondary = Color(0xFF00C9A7);
  static const Color secondaryLight = Color(0xFF5DFFD6);
  static const Color secondaryDark = Color(0xFF009B7D);

  // === BACKGROUND — LIGHT THEME ===
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // === BACKGROUND — DARK THEME ===
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // === TEXT — LIGHT THEME ===
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // === TEXT — DARK THEME ===
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // === STATUS COLORS ===
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // === SETTLEMENT SPECIFIC ===
  static const Color owes = Color(0xFFEF4444);
  static const Color owed = Color(0xFF22C55E);
  static const Color settled = Color(0xFF6B7280);

  // === EXPENSE CATEGORIES ===
  static const Color food = Color(0xFFFF6B6B);
  static const Color transport = Color(0xFF4ECDC4);
  static const Color shopping = Color(0xFFFFE66D);
  static const Color entertainment = Color(0xFFA78BFA);
  static const Color utilities = Color(0xFF60A5FA);
  static const Color rent = Color(0xFFF97316);
  static const Color other = Color(0xFF9CA3AF);
}

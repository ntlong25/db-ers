import 'package:flutter/material.dart';

/// Bảng màu toàn app — Vibrant Gen-Z Sporty
/// Electric Blue #00E5FF + Orange #FF6D00
class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────
  static const bg      = Color(0xFF070B14); // nền sâu
  static const card    = Color(0xFF0D1424); // card surface
  static const surface = Color(0xFF111827); // elevated surface
  static const divider = Color(0xFF1A2540);

  // ── Accent ──────────────────────────────────────────
  static const accent = Color(0xFF00E5FF); // electric blue
  static const orange = Color(0xFFFF6D00); // sporty orange
  static const green = Color(0xFF00E676); // sporty green

  // ── Status ──────────────────────────────────────────
  static const success = Color(0xFF00E676); // xanh lá
  static const warning = Color(0xFFFFAB00); // amber
  static const danger  = Color(0xFFFF1744); // đỏ

  // ── Text ────────────────────────────────────────────
  static const textPrimary   = Color(0xFFEEF2FF);
  static const textSecondary = Color(0xFF8892AA);
  static const textDim       = Color(0xFF3D4A60);

  // ── Gradients ───────────────────────────────────────
  static const accentGradient = LinearGradient(
    colors: [accent, orange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

import 'package:flutter/material.dart';

/// Zentrale Farbpalette der App (Dark Theme).
/// Verwendung: AppColors.primary, AppColors.secondary, etc.
class AppColors {
  AppColors._(); // Verhindert Instanziierung

  // ── Primärfarben (Orange) ─────────────────────────────
  static const Color primary       = Color(0xFFFF9800); // Orange – Transaktionsbeträge
  static const Color primaryLight  = Color(0xFFFFB74D); // Helles Orange
  static const Color primaryDark   = Color(0xFFE65100); // Dunkles Orange

  // ── Sekundärfarben (Grün) ─────────────────────────────
  static const Color secondary     = Color(0xFF4CAF50); // Grün – "Du bekommst"-Betrag
  static const Color secondaryLight = Color(0xFF81C784); // Helles Grün
  static const Color secondaryDark = Color(0xFF388E3C); // Dunkles Grün
  static const Color amountGreen   = Color(0xFF82FFA3); // Hellgrün für Beträge

  // ── Hintergrund & Oberflächen ─────────────────────────
  static const Color background    = Color(0xFF1E1E1E); // Tiefes Schwarz
  static const Color surface       = Color(0xFF232323); // Dunkelgraue Oberfläche
  static const Color card          = Color(0xFF232323); // Card-Hintergrund
  static const Color cardBorder = Color(0xFF292929); // Leicht helleres Card
  static const Color cardHighlighted = Color(0xFF252525); // Hervorgehobenes Card

  // ── Inputfelder ───────────────────────────────────────
  static const Color inputSurface          = Color(0xFF000000); // Card-Hintergrund

  // ── Text ──────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF); // Weiß
  static const Color textSecondary = Color(0xFFB0B0B0); // Gedämpftes Grau
  static const Color textOnPrimary = Color(0xFF000000); // Schwarz auf Orange
  static const Color textHint      = Color(0xFF757575); // Hint-Grau

  // ── Status / Feedback ─────────────────────────────────
  static const Color success       = Color(0xFF4CAF50); // Grün
  static const Color warning       = Color(0xFFFF9800); // Orange
  static const Color error         = Color(0xFFEF5350); // Rot
  static const Color info          = Color(0xFF42A5F5); // Blau

  // ── Sonstiges ─────────────────────────────────────────
  static const Color divider       = Color(0xFF3A3A3A); // Subtiler Teiler
  static const Color disabled      = Color(0xFF616161); // Deaktiviert
  static const Color shadow        = Color(0x80000000); // Schwarz 50 %

  // ── Bottom Navigation ─────────────────────────────────
  static const Color navBar        = Color(0xFF1E1E1E); // Nav-Hintergrund
  static const Color navActive     = Color(0xFFFF9800); // Aktives Icon (Orange)
  static const Color navInactive   = Color(0xFF757575); // Inaktives Icon
}

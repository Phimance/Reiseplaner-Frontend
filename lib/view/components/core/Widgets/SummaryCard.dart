import 'package:flutter/material.dart';
import 'package:reiseplaner/view/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final IconData leadingIcon;
  final String leadingText;
  final String title;
  final String dateRange;
  final List<String> avatars;
  final VoidCallback? onSettings;
  final VoidCallback? onAdd;
  final Color backgroundColor;
  final Color avatarColor;
  final int maxVisibleAvatars;

  const SummaryCard({
    super.key,
    this.leadingIcon = Icons.location_on_outlined,
    this.leadingText = 'Location',
    required this.title,
    required this.dateRange,
    required this.avatars,
    this.onSettings,
    this.onAdd,
    // ADVOCATUS DIABOLI: Nutze deine eigenen Konstanten als Default!
    this.backgroundColor = AppColors.card,
    this.avatarColor = AppColors.primary,
    this.maxVisibleAvatars = 3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisibleAvatars).toList();
    final hiddenAvatarCount = avatars.length - visibleAvatars.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor, // Nutzt jetzt AppColors.card
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1), // Optional: Subtile Kontur
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow, // Nutzt jetzt AppColors.shadow
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          // --- HEADER ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(leadingIcon, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 6),
              // Expanded schützt den Text vor Overflow UND drückt das Zahnrad
              // gnadenlos und dynamisch an den rechten Rand - egal auf welchem Gerät!
              Expanded(
                child: Text(
                  leadingText,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onSettings != null)
                GestureDetector(
                  onTap: onSettings,
                  child: Container(
                    color: Colors.transparent, // Vergrößert die Klickfläche unsichtbar
                    // Der geometrische Trick: right: 5
                    // Der Plus-Button unten ist 32px breit (Radius 16).
                    // Das Icon hier ist 22px breit.
                    // Durch 5 Pixel rechtes Padding zentrieren wir die 22px exakt über den 32px!
                    padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 5),
                    child: const Icon(Icons.settings, color: AppColors.textSecondary, size: 22),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          // --- TITLE ---
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary, // Nutzt AppColors.textPrimary
              fontSize: 26,
              fontWeight: FontWeight.bold,
              // Schatten deaktiviert, da sie auf dunklen Cards oft schmutzig wirken.
              // Falls gewollt: shadows: [Shadow(color: AppColors.shadow, blurRadius: 2)]
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // --- BOTTOM ROW ---
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dateRange,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),

              // --- AVATARS ---
              ...visibleAvatars.map((a) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: avatarColor, // Nutzt AppColors.primary
                  child: Text(
                    a,
                    style: const TextStyle(
                        color: AppColors.textOnPrimary, // Schwarz auf Orange!
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),
                  ),
                ),
              )),
              if (hiddenAvatarCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.surface, // Abhebung von der Card
                    child: Text(
                      '+$hiddenAvatarCount',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              if (onAdd != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: onAdd,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.secondary, // Z.B. Grün für "Hinzufügen"
                      child: const Icon(Icons.add, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:reiseplaner/view/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final IconData leadingIcon;
  final String leadingText;
  final String title;
  final String dateRange;
  final List<String> avatars;
  final VoidCallback? onSettings;
  final Color backgroundColor;
  final Color avatarColor;
  final int maxVisibleAvatars;
  final bool showCalendarIcon;

  const SummaryCard({
    super.key,
    this.leadingIcon = Icons.location_on_outlined,
    this.leadingText = 'Location',
    required this.title,
    required this.dateRange,
    required this.avatars,
    this.onSettings,
    // ADVOCATUS DIABOLI: Nutze deine eigenen Konstanten als Default!
    this.backgroundColor = AppColors.card,
    this.avatarColor = AppColors.primary,
    this.maxVisibleAvatars = 3,
    this.showCalendarIcon = true,
  });

  static const double _avatarRadius = 16.0;
  static const double _avatarOverlap =
      10.0; // wie weit jeder Avatar unter dem nächsten versteckt wird

  static const double _stackBottomPadding = 4.0;

  Widget _buildAvatarStack(List<String> visible, int hiddenCount) {
    final stackWidth = visible.isEmpty
        ? 0.0
        : _avatarRadius * 2 +
              (visible.length - 1) * (_avatarRadius * 2 - _avatarOverlap);

    Widget avatarStack = SizedBox(
      width: stackWidth,
      height: _avatarRadius * 2 + _stackBottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * (_avatarRadius * 2 - _avatarOverlap),
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.card, width: 2),
                ),
                child: CircleAvatar(
                  radius: _avatarRadius,
                  backgroundColor: avatarColor,
                  child: Text(
                    visible[i],
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (hiddenCount <= 0) return avatarStack;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatarStack,
        const SizedBox(width: 2),
        CircleAvatar(
          radius: _avatarRadius,
          backgroundColor: AppColors.surface,
          child: Text(
            '+$hiddenCount',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisibleAvatars).toList();
    final hiddenAvatarCount = avatars.length - visibleAvatars.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        // Nutzt jetzt AppColors.card
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        // Optional: Subtile Kontur
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
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onSettings != null)
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    highlightColor: AppColors.primary.withValues(alpha: 0.15),
                    splashColor: AppColors.primary.withValues(alpha: 0.25),
                    onTap: onSettings,
                    child: Icon(
                      Icons.settings,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
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
              if (showCalendarIcon)
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              if (showCalendarIcon) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dateRange,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),

              // --- AVATARS (stacked like a deck of cards) ---
              _buildAvatarStack(visibleAvatars, hiddenAvatarCount),
            ],
          ),
        ],
      ),
    );
  }
}

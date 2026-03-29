import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String? label;
  final Widget child;

  const PageHeader({
    super.key,
    this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          "$label",
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      ),
      Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface, // Nutzt jetzt AppColors.card
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
          child: child
        )
      ],
    );
  }
}


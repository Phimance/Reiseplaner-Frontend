import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PersonLabel extends StatelessWidget {
  final String initial;
  final String name;
  final Color avatarColor;
  final double radius;

  const PersonLabel({
    super.key,
    required this.initial,
    required this.name,
    this.avatarColor = AppColors.primary,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: avatarColor,
          child: Text(
            initial,
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}


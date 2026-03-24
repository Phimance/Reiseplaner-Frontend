import 'package:flutter/material.dart';
import '../../../../view/theme/app_colors.dart';

class ReiseButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ReiseButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<ReiseButton> createState() => _ReiseButtonState();
}

class _ReiseButtonState extends State<ReiseButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _pressed ? AppColors.cardHighlighted : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: _pressed ? 12 : 4,
              offset: Offset(0, _pressed ? 6 : 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(widget.icon, size: 32, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}


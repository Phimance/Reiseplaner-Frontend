import 'package:flutter/material.dart';
import '../../../../view/theme/app_colors.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const TextInputField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class DateInputField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<DateTime>? onChanged;

  const DateInputField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.onChanged,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.inputSurface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      widget.controller?.text = formatted;
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap: _pickDate,
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              onTap: _pickDate,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'TT.MM.JJJJ',
                hintStyle: const TextStyle(color: AppColors.textHint),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: InputBorder.none,
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      );
  }
}

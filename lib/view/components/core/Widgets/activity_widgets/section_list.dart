import 'activity_section.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class SectionList extends StatelessWidget {
  final List<DaySection> items;

  const SectionList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ...items,
            ],
    );
  }
}

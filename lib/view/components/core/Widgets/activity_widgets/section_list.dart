import 'activity_section.dart';
import 'package:flutter/material.dart';

class SectionList extends StatelessWidget {
  final List<DaySection> items;

  const SectionList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}

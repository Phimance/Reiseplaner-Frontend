import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/activity_widgets/section_list.dart';
import '../../../core/app_state.dart';
import '../../theme/app_colors.dart';
import '../core/Widgets/PageHeader.dart';
import '../core/Widgets/activity_widgets/activity_item.dart';
import '../core/Widgets/activity_widgets/activity_section.dart';
import 'add_entity/add_activity_screen.dart';
import 'show_details/activity_details_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final events = appState.events;
    final now = DateTime.now();

    // Nach echtem Datum gruppieren/sortieren (nicht nach formatiertem String)
    final groupedByDate = <DateTime, List<({DateTime start, dynamic event})>>{};
    final dateFormatter = DateFormat('EEEE, dd.MM.yyyy', 'de_DE');
    final timeFormatter = DateFormat('HH:mm');

    for (final event in events) {
      try {
        final start = DateTime.parse(event.datumStart);
        final dayKey = DateTime(start.year, start.month, start.day);
        groupedByDate.putIfAbsent(dayKey, () => []);
        groupedByDate[dayKey]!.add((start: start, event: event));
      } catch (_) {
        continue;
      }
    }

    final sortedDates = groupedByDate.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    for (final date in sortedDates) {
      groupedByDate[date]!.sort((a, b) => a.start.compareTo(b.start));
    }

    final anstehendeAktivitaeten = events.where((event) {
      try {
        return DateTime.parse(event.datumStart).isAfter(now);
      } catch (_) {
        return false;
      }
    }).length;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageHeader(
              label: 'Es stehen',
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '$anstehendeAktivitaeten',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const TextSpan(
                      text: ' Aktivitäten an',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Text(
                  'Keine Events vorhanden. Füge ein neues Event hinzu!',
                  textAlign: TextAlign.center,
                ),
              )
            else
              SectionList(
                items: sortedDates.map((date) {
                  final dayItems = groupedByDate[date]!
                      .map(
                        (item) => ActivityItem(
                          title: item.event.titel,
                          date: timeFormatter.format(item.start),
                          location: item.event.location,
                          onTap: () => showActivityDetailsSheet(context, item.event),
                        ),
                      )
                      .toList();

                  return DaySection(
                    day: dateFormatter.format(date),
                    items: dayItems,
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddActivityScreen(),
          ),
        ),
        backgroundColor: const Color(0xFF444444),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF666666), width: 1),
        ),
        child: Icon(Icons.add_box_outlined, size: 30, color: AppColors.primary)
      ),
    );
  }
}
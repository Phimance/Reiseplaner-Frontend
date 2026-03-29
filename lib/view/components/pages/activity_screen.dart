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
  List<DaySection> _buildSections({
    required BuildContext context,
    required List<({DateTime start, dynamic event})> entries,
    required bool newestFirst,
  }) {
    final grouped = <DateTime, List<({DateTime start, dynamic event})>>{};
    final dateFormatter = DateFormat('EEEE, dd.MM.yyyy', 'de_DE');
    final timeFormatter = DateFormat('HH:mm');

    for (final entry in entries) {
      final dayKey = DateTime(entry.start.year, entry.start.month, entry.start.day);
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(entry);
    }

    final dates = grouped.keys.toList()
      ..sort((a, b) => newestFirst ? b.compareTo(a) : a.compareTo(b));

    for (final date in dates) {
      grouped[date]!.sort(
        (a, b) => newestFirst
            ? b.start.compareTo(a.start)
            : a.start.compareTo(b.start),
      );
    }

    return dates.map((date) {
      final items = grouped[date]!
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
        items: items,
      );
    }).toList();
  }

  DaySection _buildSummarySection({
    required BuildContext context,
    required List<({DateTime start, dynamic event})> entries,
  }) {
    final timeFormatter = DateFormat('dd.MM.yyyy');

    final sorted = [...entries]
      ..sort((a, b) => b.start.compareTo(a.start));

    final items = sorted
        .map(
          (item) => ActivityItem(
            title: item.event.titel,
            date: timeFormatter.format(item.start),
            location: item.event.location,
            isPast: true,
            onTap: () => showActivityDetailsSheet(context, item.event),
          ),
        )
        .toList();

    return DaySection(day: 'Vergangene Aktivitäten', items: items);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final events = appState.events;
    final now = DateTime.now();

    final upcomingEntries = <({DateTime start, dynamic event})>[];
    final pastEntries = <({DateTime start, dynamic event})>[];

    for (final event in events) {
      try {
        final start = DateTime.parse(event.datumStart);
        DateTime end;
        try {
          end = DateTime.parse(event.datumEnde);
        } catch (_) {
          end = start;
        }

        if (end.isBefore(now)) {
          pastEntries.add((start: start, event: event));
        } else {
          upcomingEntries.add((start: start, event: event));
        }
      } catch (_) {
        continue;
      }
    }

    final upcomingSections = _buildSections(
      context: context,
      entries: upcomingEntries,
      newestFirst: false,
    );
    final pastSummarySection = _buildSummarySection(
      context: context,
      entries: pastEntries,
    );

    final anstehendeAktivitaeten = upcomingEntries.length;

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
              Column(
                children: [
                  if (upcomingSections.isNotEmpty)
                    SectionList(items: upcomingSections)
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'Keine anstehenden Events.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  if (pastEntries.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SectionList(items: [pastSummarySection]),
                  ],
                ],
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
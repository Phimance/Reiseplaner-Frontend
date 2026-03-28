import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/activity_widgets/section_list.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/activity_widgets/activity_item.dart';
import '../core/Widgets/activity_widgets/activity_section.dart';
import 'add_entity/add_activity_screen.dart';
import 'show_details/activity_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    // Gruppen nach Datum sortieren
    final groupedByDate = <String, List<ActivityItem>>{};
    final dateFormatter = DateFormat('EEEE, dd.MM.yyyy', 'de_DE');

    for (final event in events) {
      try {
        final dateTime = DateTime.parse(event.datumStart);
        final formattedDate = dateFormatter.format(dateTime);

        groupedByDate.putIfAbsent(formattedDate, () => []);
        groupedByDate[formattedDate]!.add(
          ActivityItem(
            title: event.titel,
            date: event.datumStart.split('T')[1].substring(0, 5),
            location: event.location,
            onTap: () => showActivityDetailsSheet(context, event),
          ),
        );
      } catch (_) {
        continue;
      }
    }

    // Sortierte Datum-Liste
    final sortedDates = groupedByDate.keys.toList();

    return Scaffold(
      body: events.isEmpty
          ? const Center(
        child: Text(
          'Keine Events vorhanden. Füge ein neues Event hinzu!',
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SectionList(
              items: sortedDates.map((date) {
                return DaySection(
                  day: date,
                  items: groupedByDate[date] ?? [],
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
        child: SvgPicture.asset(
          'assets/icons/pen-icon.svg',
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
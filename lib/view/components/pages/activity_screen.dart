import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/activity_widgets/section_list.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/activity_widgets/activity_item.dart';
import '../core/Widgets/activity_widgets/activity_section.dart';
import 'add_entity/add_activity_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
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
        // Parse YYYY-MM-DDTHH:MM:SS zu DateTime
        final dateTime = DateTime.parse(event.datumStart);
        // Formatiere zu "Tag, DD.MM.YYYY"
        final formattedDate = dateFormatter.format(dateTime);

        if (!groupedByDate.containsKey(formattedDate)) {
          groupedByDate[formattedDate] = [];
        }
        groupedByDate[formattedDate]!.add(
          ActivityItem(
            title: event.titel,
            date: event.datumStart.split('T')[1].substring(0, 5), // HH:MM
            location: event.location ?? 'Keine Location',
          ),
        );
      } catch (_) {
        // Falls Datumformat ungültig ist, überspring Event
        continue;
      }
    }

    // Sortierte Datum-Liste (nach Original-Datum sortieren, nicht nach String)
    final sortedDates = groupedByDate.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          events.isEmpty
              ? const Center(
                  child: Text('Keine Events vorhanden. Füge ein neues Event hinzu!'),
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
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddActivityScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
    Positioned(
    bottom: 16,
    right: 16,
    child: FloatingActionButton(
    onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddActivityScreen()),
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
        ],
      ),
    );
  }
}

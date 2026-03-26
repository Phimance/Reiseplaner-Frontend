import 'package:flutter/material.dart';
import 'package:reiseplaner/view/components/core/Widgets/activity_widgets/section_list.dart';
import '../core/Widgets/activity_widgets/activity_item.dart';
import '../core/Widgets/activity_widgets/activity_section.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // 1. Logic: Variables & State
  bool _isLoading = false;

  // 2. Logic: Lifecycle Methods
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    // Clean up controllers or listeners here
    super.dispose();
  }

  // 3. Logic: Functional Methods
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Add your data fetching or logic here

    setState(() => _isLoading = false);
  }

  // 4. Structure: The Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SectionList(
              items: [
                DaySection(
                  day: 'Mittwoch, 10.07.2026',
                  items: [
                    ActivityItem(
                      title: 'Essen Italiener',
                      date: '10:32',
                      location: 'Erfurt',
                    ),
                    ActivityItem(
                      title: 'Essen Italiener',
                      date: '10:33',
                      location: 'Erfurt',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
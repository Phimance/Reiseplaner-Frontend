import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/NoteCard.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // Beim ersten Laden der Seite sicherstellen, dass die Daten aktuell sind
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().ladeNotizen();
    });
  }

  void _showAddNoteModal(BuildContext context) {
    final titelController = TextEditingController();
    final inhaltController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF363636),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Neue Notiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titelController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Titel',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF444444),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: inhaltController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Inhalt',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF444444),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titelController.text.isNotEmpty) {
                      await context.read<AppState>().createNotiz(
                            titelController.text,
                            inhaltController.text,
                          );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Speichern',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    'Eure Notizen',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (appState.aktiveGruppe == null)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Bitte wähle zuerst eine Gruppe aus.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => appState.ladeNotizen(),
                      color: const Color(0xFFFF9800),
                      backgroundColor: const Color(0xFF444444),
                      child: appState.isLoading && appState.notizen.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : appState.notizen.isEmpty
                              ? ListView(
                                  children: const [
                                    SizedBox(height: 100),
                                    Center(
                                      child: Text(
                                        'Noch keine Notizen vorhanden.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                                  itemCount: appState.notizen.length,
                                  itemBuilder: (context, index) {
                                    final notiz = appState.notizen[index];
                                    return NoteCard(
                                      title: notiz.name,
                                      content: notiz.inhalt,
                                    );
                                  },
                                ),
                    ),
                  ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showAddNoteModal(context),
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
            ),
          ],
        );
      },
    );
  }
}

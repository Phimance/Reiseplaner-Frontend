import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_state.dart';
import '../../../api/models/models.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().ladeNotizen();
    });
  }

  void _showNoteModal(BuildContext context, {Notiz? existingNote}) {
    final isEditing = existingNote != null;
    final titelController = TextEditingController(text: existingNote?.name ?? '');
    final inhaltController = TextEditingController(text: existingNote?.inhalt ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF363636),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
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
              Text(
                isEditing ? 'Notiz bearbeiten' : 'Neue Notiz',
                style: const TextStyle(
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
                      final appState = context.read<AppState>();
                      if (isEditing) {
                        final updatedNote = Notiz(
                          id: existingNote.id,
                          name: titelController.text,
                          inhalt: inhaltController.text,
                          notizblockId: existingNote.notizblockId,
                        );
                        await appState.updateNotiz(updatedNote);
                      } else {
                        await appState.createNotiz(
                          titelController.text,
                          inhaltController.text,
                        );
                      }
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
                  child: Text(
                    isEditing ? 'Aktualisieren' : 'Speichern',
                    style: const TextStyle(
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

  void _confirmDelete(BuildContext context, Notiz notiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF363636),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.5),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Notiz löschen', style: TextStyle(color: Colors.white)),
        content: Text('Möchtest du die Notiz "${notiz.name}" wirklich löschen?', 
          style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (notiz.id != null) {
                await context.read<AppState>().deleteNotiz(notiz.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
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
                                      onTap: () => _showNoteModal(context, existingNote: notiz),
                                      onDelete: () => _confirmDelete(context, notiz),
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
                onPressed: () => _showNoteModal(context),
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

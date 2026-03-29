import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_state.dart';
import '../../../api/models/models.dart';
import '../../theme/app_colors.dart';
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
    
    // StatefulBuilder, damit das Modal seinen eigenen Zustand (Checkliste vs Text) verwalten kann
    bool isChecklistMode = existingNote?.inhalt.contains('- [ ]') ?? existingNote?.inhalt.contains('- [x]') ?? false;

    // Logik für Checklisten-Verhalten (Enter-Taste -> neues Element)
    void onInhaltChanged(String text, StateSetter setModalState) {
      if (text.endsWith('\n') && isChecklistMode) {
        final lines = text.split('\n');
        if (lines.length >= 2) {
          final lastLine = lines[lines.length - 2];
          if (lastLine.startsWith('- [ ] ') || lastLine.startsWith('- [x] ')) {
            if (lastLine.trim() == '- [ ]' || lastLine.trim() == '- [x]') {
              final newText = text.substring(0, text.length - lastLine.length - 2) + '\n';
              inhaltController.text = newText;
            } else {
              inhaltController.text = text + '- [ ] ';
            }
            inhaltController.selection = TextSelection.fromPosition(
              TextPosition(offset: inhaltController.text.length),
            );
          }
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.shadow,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Notiz bearbeiten' : 'Neue Notiz',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      // Toggle Button für Modus (Text vs Checkliste)
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            isChecklistMode = !isChecklistMode;
                            if (isChecklistMode && inhaltController.text.isEmpty) {
                              inhaltController.text = '- [ ] ' + inhaltController.text;
                            }
                          });
                        },
                        icon: Icon(
                          isChecklistMode ? Icons.notes : Icons.checklist,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          isChecklistMode ? 'Text' : 'Checkliste',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titelController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Titel',
                      hintStyle: TextStyle(color: AppColors.textHint),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(color: AppColors.divider),
                  Expanded(
                    child: isChecklistMode 
                      ? _buildChecklistEditor(inhaltController, setModalState)
                      : _buildTextEditor(inhaltController, (val) => onInhaltChanged(val, setModalState)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titelController.text.isNotEmpty) {
                          final appState = context.read<AppState>();
                          final note = Notiz(
                            id: existingNote?.id,
                            name: titelController.text,
                            inhalt: inhaltController.text,
                            notizblockId: existingNote?.notizblockId,
                          );
                          if (isEditing) {
                            await appState.updateNotiz(note);
                          } else {
                            await appState.createNotiz(note.name, note.inhalt);
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isEditing ? 'Aktualisieren' : 'Speichern', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildTextEditor(TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, height: 1.5),
      decoration: const InputDecoration(
        hintText: 'Notiz hier schreiben...',
        hintStyle: TextStyle(color: AppColors.textHint),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildChecklistEditor(TextEditingController controller, StateSetter setModalState) {
    final lines = controller.text.split('\n');
    
    return ListView.builder(
      itemCount: lines.length + 1,
      itemBuilder: (context, index) {
        // PLUS Button als letztes Element
        if (index == lines.length) {
          return Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {
                setModalState(() {
                  final current = controller.text;
                  if (current.isEmpty) {
                    controller.text = '- [ ] ';
                  } else {
                    controller.text = current.endsWith('\n') ? '$current- [ ] ' : '$current\n- [ ] ';
                  }
                });
              },
              icon: const Icon(Icons.add, color: AppColors.primary, size: 24),
              label: const Text('Punkt hinzufügen', style: TextStyle(color: AppColors.primary, fontSize: 16)),
            ),
          );
        }

        String line = lines[index];
        bool isChecked = line.startsWith('- [x] ');
        bool isBullet = line.startsWith('- [ ] ') || isChecked;
        String textOnly = isBullet ? (line.length > 6 ? line.substring(6) : '') : line;


        return isBullet ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setModalState(() {
                    lines[index] = isChecked ? '- [ ] $textOnly' : '- [x] $textOnly';
                    controller.text = lines.join('\n');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isChecked ? AppColors.primary : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  key: Key('note_line_$index'),
                  controller: TextEditingController(text: textOnly)..selection = TextSelection.fromPosition(TextPosition(offset: textOnly.length)),
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: isChecked ? AppColors.textSecondary : AppColors.textPrimary,
                    fontSize: 17,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Listenpunkt...',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (newVal) {
                    lines[index] = (isChecked ? '- [x] ' : '- [ ] ') + newVal;
                    controller.text = lines.join('\n');
                  },
                  onSubmitted: (_) {
                    setModalState(() {
                      lines.insert(index + 1, '- [ ] ');
                      controller.text = lines.join('\n');
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                onPressed: () {
                  setModalState(() {
                    lines.removeAt(index);
                    controller.text = lines.join('\n');
                  });
                },
              ),
            ],
          ),
        ) : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(line, style: TextStyle(color: AppColors.textSecondary, fontSize: 17), softWrap: true),
                ),
              ],
            )
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Notiz notiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.divider,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        title: const Text('Notiz löschen', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Möchtest du die Notiz "${notiz.name}" wirklich löschen?', 
          style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: AppColors.textHint)),
          ),
          TextButton(
            onPressed: () async {
              if (notiz.id != null) {
                await context.read<AppState>().deleteNotiz(notiz.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: AppColors.error)),
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
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                if (appState.aktiveGruppe == null)
                  const Expanded(child: Center(child: Text('Bitte wähle zuerst eine Gruppe aus.', style: TextStyle(color: AppColors.textHint))))
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => appState.ladeNotizen(),
                      color: AppColors.primary,
                      backgroundColor: AppColors.divider,
                      child: appState.isLoading && appState.notizen.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : appState.notizen.isEmpty
                              ? ListView(children: const [SizedBox(height: 100), Center(child: Text('Noch keine Notizen vorhanden.', style: TextStyle(color: AppColors.textHint)))])
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                                  itemCount: appState.notizen.length,
                                  itemBuilder: (context, index) {
                                    final notiz = appState.notizen[index];
                                    return NoteCard(
                                      title: notiz.name,
                                      content: notiz.inhalt.replaceAll('- [ ] ', '○ ').replaceAll('- [x] ', '✓ '),
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
                backgroundColor: AppColors.divider,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.disabled, width: 1)),
                child: SvgPicture.asset('assets/icons/pen-icon.svg', width: 30, height: 30),
              ),
            ),
          ],
        );
      },
    );
  }
}

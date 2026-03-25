import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import für SVG-Unterstützung
import '../core/Widgets/NoteCard.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Stack, um den FAB (Floating Action Button) zu platzieren.
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // Unten Platz für den Button lassen
                children: const [
                  NoteCard(
                    title: 'Packliste',
                    content: 'The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.',
                  ),
                  NoteCard(
                    title: 'Packliste',
                    content: 'The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.',
                  ),
                  NoteCard(
                    title: 'Packliste',
                    content: 'The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.',
                  ),
                  NoteCard(
                    title: 'Packliste',
                    content: 'The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.',
                  ),
                ],
              ),
            ),
          ],
        ),
        // Button manuell hinzugefügt
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              debugPrint('Notiz-Button gedrückt!');
              //TODO: Hier die Logik zum Hinzufügen einbauen
            },
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
              // Falls das SVG bereits eine Farbe hat (wie in deiner Datei), kannst du colorFilter nutzen oder weglassen.
              // Hier ein Beispiel, falls du es übersteuern willst:
              // colorFilter: const ColorFilter.mode(Color(0xFFFF9800), BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}

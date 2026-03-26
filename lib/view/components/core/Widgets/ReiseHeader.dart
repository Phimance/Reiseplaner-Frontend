import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/models/models.dart'; // Geändert auf models.dart
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import '../../pages/reisegruppen/add_gruppe_screen.dart';
import 'Button.dart';

class ReiseHeader extends StatelessWidget {
  const ReiseHeader({super.key});

  void _showGruppenAuswahl(BuildContext context) {
    final appState = context.read<AppState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final gruppen = appState.gruppen;
        final aktive = appState.aktiveGruppe;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gruppe auswählen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SimpleButton(
                      icon: Icons.add,
                      size: 48,
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddGruppeScreen(),
                          ),
                        );
                      },
                    )
                  ],
                )
              ),
              const Divider(color: AppColors.divider),
              ...gruppen.map((gruppe) {
                final isSelected = aktive != null && gruppe.id == aktive.id;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? AppColors.primary : AppColors.navInactive,
                  ),
                  title: Text(
                    gruppe.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    appState.setAktiveGruppe(gruppe);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final gruppenName = appState.aktiveGruppe?.name ?? 'Keine Gruppe';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            gruppenName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_outlined, size: 38),
          onPressed: () => _showGruppenAuswahl(context),
        ),
      ],
    );
  }
}

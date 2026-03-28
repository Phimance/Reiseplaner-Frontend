import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../api/models/models.dart';
import '../../../../core/app_state.dart';
import '../../../theme/app_colors.dart';
import '../add_entity/add_activity_screen.dart';

Future<void> showActivityDetailsSheet(BuildContext context, Event event) async {
  await showModalBottomSheet(
	context: context,
	isScrollControlled: true,
	backgroundColor: AppColors.surface,
	shape: const RoundedRectangleBorder(
	  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
	),
	builder: (sheetContext) {
	  return SafeArea(
		child: Padding(
		  padding: EdgeInsets.fromLTRB(
			20,
			20,
			20,
			20 + MediaQuery.of(sheetContext).viewInsets.bottom,
		  ),
		  child: SingleChildScrollView(
			child: Column(
			  mainAxisSize: MainAxisSize.min,
			  crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
				Text(
				  event.titel,
				  style: const TextStyle(
					fontSize: 24,
					fontWeight: FontWeight.bold,
					color: AppColors.textPrimary,
				  ),
				),
				const SizedBox(height: 16),
				_DetailLine(label: 'Beschreibung', value: _valueOrDash(event.beschreibung)),
				_DetailLine(label: 'Location', value: _valueOrDash(event.location)),
				_DetailLine(label: 'Start', value: _formatDateTime(event.datumStart)),
				_DetailLine(label: 'Ende', value: _formatDateTime(event.datumEnde)),
				const SizedBox(height: 20),
				Row(
				  children: [
					Expanded(
					  child: ElevatedButton.icon(
						onPressed: () {
						  Navigator.push(
							context,
							MaterialPageRoute(
							  builder: (_) => AddActivityScreen(existingEvent: event),
							),
						  );
						},
						icon: const Icon(Icons.edit),
						label: const Text('Bearbeiten'),
						style: ElevatedButton.styleFrom(
						  backgroundColor: AppColors.primary,
						  foregroundColor: AppColors.textOnPrimary,
						  minimumSize: const Size.fromHeight(48),
						),
					  ),
					),
					const SizedBox(width: 12),
					Expanded(
					  child: ElevatedButton.icon(
						onPressed: () async {
						  final shouldDelete = await showDialog<bool>(
							context: sheetContext,
							builder: (dialogContext) {
							  return AlertDialog(
								backgroundColor: AppColors.surface,
								title: const Text('Event löschen?'),
								content: const Text(
								  'Diese Aktivität wird dauerhaft gelöscht.',
								  style: TextStyle(color: AppColors.textSecondary),
								),
								actions: [
								  TextButton(
									onPressed: () => Navigator.pop(dialogContext, false),
									child: const Text('Abbrechen'),
								  ),
								  TextButton(
									onPressed: () => Navigator.pop(dialogContext, true),
									child: const Text(
									  'Löschen',
									  style: TextStyle(color: AppColors.error),
									),
								  ),
								],
							  );
							},
						  );

						  if (shouldDelete != true) return;

						  try {
							await sheetContext.read<AppState>().deleteEvent(event.id);
							if (sheetContext.mounted) {
							  Navigator.pop(sheetContext);
							  ScaffoldMessenger.of(context).showSnackBar(
								const SnackBar(content: Text('Event gelöscht.')),
							  );
							}
						  } catch (e) {
							if (sheetContext.mounted) {
							  ScaffoldMessenger.of(sheetContext).showSnackBar(
								SnackBar(content: Text('Fehler: $e')),
							  );
							}
						  }
						},
						icon: const Icon(Icons.delete_outline),
						label: const Text('Löschen'),
						style: ElevatedButton.styleFrom(
						  backgroundColor: AppColors.error,
						  foregroundColor: AppColors.textPrimary,
						  minimumSize: const Size.fromHeight(48),
						),
					  ),
					),
				  ],
				),
			  ],
			),
		  ),
		),
	  );
	},
  );
}

String _valueOrDash(String? value) {
  if (value == null || value.trim().isEmpty) return '-';
  return value.trim();
}

String _formatDateTime(String raw) {
  try {
	final parsed = DateTime.parse(raw);
	return DateFormat('dd.MM.yyyy, HH:mm').format(parsed);
  } catch (_) {
	return raw;
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
	return Padding(
	  padding: const EdgeInsets.only(bottom: 10),
	  child: Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
		  Text(
			label,
			style: const TextStyle(
			  color: AppColors.textSecondary,
			  fontSize: 13,
			  fontWeight: FontWeight.w600,
			),
		  ),
		  const SizedBox(height: 2),
		  Text(
			value,
			style: const TextStyle(
			  color: AppColors.textPrimary,
			  fontSize: 16,
			),
		  ),
		],
	  ),
	);
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/activity.dart';
import '../cubit/trips_cubit.dart';

const _categories = <String, IconData>{
  'sight': Icons.photo_camera_outlined,
  'food': Icons.restaurant_outlined,
  'transport': Icons.directions_transit_outlined,
  'stay': Icons.hotel_outlined,
  'activity': Icons.hiking_outlined,
};

Future<void> showActivityFormSheet(
  BuildContext context, {
  required String tripId,
  Activity? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ActivityFormSheet(tripId: tripId, existing: existing),
  );
}

class _ActivityFormSheet extends StatefulWidget {
  const _ActivityFormSheet({required this.tripId, this.existing});

  final String tripId;
  final Activity? existing;

  @override
  State<_ActivityFormSheet> createState() => _ActivityFormSheetState();
}

class _ActivityFormSheetState extends State<_ActivityFormSheet> {
  late final TextEditingController _title;
  late final TextEditingController _note;
  late TimeOfDay _time;
  late String _category;
  String? _error;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _note = TextEditingController(text: widget.existing?.note ?? '');
    _time = _parseTime(widget.existing?.time) ?? const TimeOfDay(hour: 9, minute: 0);
    _category = widget.existing?.category ?? 'sight';
  }

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null || !raw.contains(':')) return null;
    final parts = raw.split(':');
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'What are you doing?');
      return;
    }
    final cubit = context.read<TripsCubit>();
    if (widget.existing != null) {
      cubit.updateActivity(
        widget.tripId,
        widget.existing!.copyWith(
          title: title,
          time: _format(_time),
          note: _note.text.trim(),
          category: _category,
        ),
      );
    } else {
      cubit.addActivity(
        widget.tripId,
        Activity(
          id: 'a${DateTime.now().microsecondsSinceEpoch}',
          title: title,
          time: _format(_time),
          note: _note.text.trim(),
          category: _category,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 4, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null ? 'NEW ACTIVITY' : 'EDIT ACTIVITY',
              style: AppTypography.eyebrow,
            ),
            const SizedBox(height: 8),
            Text(
              'Add to the itinerary',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Activity'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 18, color: AppColors.inkSoft),
                          const SizedBox(width: 10),
                          Text(
                            _format(_time),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _categories.entries.map((e) {
                final active = e.key == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? AppColors.ink : AppColors.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: active ? AppColors.ink : AppColors.line,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e.value,
                          size: 16,
                          color: active ? Colors.white : AppColors.inkSoft,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e.key[0].toUpperCase() + e.key.substring(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: active ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _note,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Notes (optional)'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _save,
              style:
                  FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              child: Text(widget.existing == null
                  ? 'Add activity'
                  : 'Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

IconData activityIcon(String category) =>
    _categories[category] ?? Icons.place_outlined;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format.dart';
import '../../../core/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/destination.dart';
import '../../../data/models/trip.dart';
import '../cubit/trips_cubit.dart';

Future<void> showTripFormSheet(
  BuildContext context, {
  Trip? existing,
  Destination? presetDestination,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _TripFormSheet(
      existing: existing,
      presetDestination: presetDestination,
    ),
  );
}

class _TripFormSheet extends StatefulWidget {
  const _TripFormSheet({this.existing, this.presetDestination});

  final Trip? existing;
  final Destination? presetDestination;

  @override
  State<_TripFormSheet> createState() => _TripFormSheetState();
}

class _TripFormSheetState extends State<_TripFormSheet> {
  late final TextEditingController _title;
  Destination? _destination;
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final preset = widget.presetDestination ??
        (widget.existing != null
            ? sampleDestinations.firstWhere(
                (d) => d.name == widget.existing!.destinationName,
                orElse: () => sampleDestinations.first,
              )
            : null);
    _destination = preset;
    _title = TextEditingController(
      text: widget.existing?.title ??
          (preset != null ? 'Trip to ${preset.name}' : ''),
    );
    final today = DateTime.now();
    _start = widget.existing?.startDate ?? today.add(const Duration(days: 14));
    _end = widget.existing?.endDate ?? today.add(const Duration(days: 18));
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  String? _error;

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        if (_end.isBefore(_start)) _end = _start;
      } else {
        _end = picked;
        if (_end.isBefore(_start)) _start = _end;
      }
    });
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Give your trip a name.');
      return;
    }
    if (_destination == null) {
      setState(() => _error = 'Choose a destination.');
      return;
    }
    final cubit = context.read<TripsCubit>();
    final cover = _destination!.image;
    if (widget.existing != null) {
      cubit.updateTrip(widget.existing!.copyWith(
        title: title,
        destinationName: _destination!.name,
        cover: cover,
        startDate: _start,
        endDate: _end,
      ));
    } else {
      cubit.addTrip(Trip(
        id: 't${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        destinationName: _destination!.name,
        cover: cover,
        startDate: _start,
        endDate: _end,
      ));
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
              widget.existing == null ? 'NEW TRIP' : 'EDIT TRIP',
              style: AppTypography.eyebrow,
            ),
            const SizedBox(height: 8),
            Text(
              widget.existing == null ? 'Plan something good' : 'Fine-tune it',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Trip name'),
            ),
            const SizedBox(height: 14),
            _DestinationPicker(
              value: _destination,
              onChanged: (d) => setState(() {
                _destination = d;
                if (_title.text.trim().isEmpty) {
                  _title.text = 'Trip to ${d.name}';
                }
              }),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Start',
                    value: _start,
                    onTap: () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: 'End',
                    value: _end,
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.error_outline,
                      size: 16, color: AppColors.terracotta),
                  const SizedBox(width: 8),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.terracotta,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _save,
              style:
                  FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              child: Text(widget.existing == null
                  ? 'Create trip'
                  : 'Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationPicker extends StatelessWidget {
  const _DestinationPicker({required this.value, required this.onChanged});

  final Destination? value;
  final ValueChanged<Destination> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Destination>(
      initialValue: value,
      isExpanded: true,
      hint: const Text('Destination'),
      borderRadius: BorderRadius.circular(18),
      items: sampleDestinations
          .map(
            (d) => DropdownMenuItem(
              value: d,
              child: Text('${d.name}, ${d.country}'),
            ),
          )
          .toList(),
      onChanged: (d) {
        if (d != null) onChanged(d);
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              shortDate(value),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

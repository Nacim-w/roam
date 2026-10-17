import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/destination.dart';
import '../../../data/models/trip.dart';
import '../cubit/trips_cubit.dart';
import 'trip_form_sheet.dart';

Future<void> showAddToTripSheet(
  BuildContext context,
  Destination destination,
) {
  final trips = context.read<TripsCubit>().state.trips;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ADD TO A TRIP', style: AppTypography.eyebrow),
              const SizedBox(height: 8),
              Text(
                'Where should ${destination.name} go?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              _NewTripRow(
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showTripFormSheet(context, presetDestination: destination);
                },
              ),
              if (trips.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('YOUR TRIPS', style: AppTypography.eyebrow),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: trips.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final Trip trip = trips[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            trip.cover.isNotEmpty
                                ? trip.cover
                                : destination.image,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: AppColors.surfaceAlt,
                            ),
                          ),
                        ),
                        title: Text(
                          trip.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          dateRange(trip.startDate, trip.endDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: const Icon(Icons.add_circle_outline,
                            color: AppColors.terracotta),
                        onTap: () {
                          context.read<TripsCubit>().addActivity(
                                trip.id,
                                Activity(
                                  id: 'a${DateTime.now().microsecondsSinceEpoch}',
                                  title: 'Explore ${destination.name}',
                                  time: '09:00',
                                  note: destination.tagline,
                                  category: 'sight',
                                ),
                              );
                          Navigator.of(sheetContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content:
                                  Text('Added to "${trip.title}"'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _NewTripRow extends StatelessWidget {
  const _NewTripRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.ink,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              'Start a new trip',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

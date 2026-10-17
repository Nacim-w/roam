import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/trip.dart';
import '../../widgets/photo.dart';
import 'cubit/trips_cubit.dart';
import 'cubit/trips_state.dart';
import 'widgets/activity_form_sheet.dart';
import 'widgets/activity_tile.dart';
import 'widgets/trip_form_sheet.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) {
        final trip = state.byId(tripId);
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('This trip no longer exists.')),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _header(context, trip),
              SliverToBoxAdapter(child: _metaRow(context, trip)),
              SliverToBoxAdapter(child: _itineraryHeader(context, trip)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                sliver: SliverToBoxAdapter(
                  child: trip.activities.isEmpty
                      ? _emptyItinerary(context)
                      : ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          itemCount: trip.activities.length,
                          onReorder: (oldIndex, newIndex) => context
                              .read<TripsCubit>()
                              .reorderActivities(trip.id, oldIndex, newIndex),
                          itemBuilder: (context, i) {
                            final a = trip.activities[i];
                            return ActivityTile(
                              key: ValueKey(a.id),
                              activity: a,
                              index: i,
                              onTap: () => showActivityFormSheet(
                                context,
                                tripId: trip.id,
                                existing: a,
                              ),
                              onDelete: () => context
                                  .read<TripsCubit>()
                                  .deleteActivity(trip.id, a.id),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                showActivityFormSheet(context, tripId: trip.id),
            backgroundColor: AppColors.ink,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add activity'),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, Trip trip) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.canvas,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: _glass(Icons.arrow_back),
        ),
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () => showTripFormSheet(context, existing: trip),
            child: _glass(Icons.edit_outlined),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => _confirmDelete(context, trip),
            child: _glass(Icons.delete_outline),
          ),
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Photo(asset: trip.cover, gradient: photoScrim),
            Positioned(
              left: 24,
              right: 24,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trip.destinationName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(BuildContext context, Trip trip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          _MetaTile(
            icon: Icons.calendar_today_outlined,
            value: dateRange(trip.startDate, trip.endDate),
          ),
          const SizedBox(width: 12),
          _MetaTile(
            icon: Icons.nightlight_outlined,
            value: countLabel(trip.nights, 'night'),
          ),
          const SizedBox(width: 12),
          _MetaTile(
            icon: Icons.check_circle_outline,
            value: countLabel(trip.activities.length, 'stop'),
          ),
        ],
      ),
    );
  }

  Widget _itineraryHeader(BuildContext context, Trip trip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ITINERARY', style: AppTypography.eyebrow),
          const SizedBox(height: 6),
          Text(
            'Day by day',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _emptyItinerary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_note_outlined,
              color: AppColors.inkSoft, size: 32),
          const SizedBox(height: 12),
          Text(
            'Nothing planned yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add activity" to start building your days.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _glass(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, size: 19, color: Colors.white),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Trip trip) async {
    final cubit = context.read<TripsCubit>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text('"${trip.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      cubit.deleteTrip(trip.id);
      navigator.maybePop();
    }
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.terracotta),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

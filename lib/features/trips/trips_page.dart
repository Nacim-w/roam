import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import 'cubit/trips_cubit.dart';
import 'cubit/trips_state.dart';
import 'trip_detail_page.dart';
import 'widgets/trip_card.dart';
import 'widgets/trip_form_sheet.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTripFormSheet(context),
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New trip'),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your trips',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.trips.isEmpty
                              ? 'Nothing planned yet'
                              : '${state.trips.length} '
                                  '${state.trips.length == 1 ? 'adventure' : 'adventures'} waiting',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.trips.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.map_outlined,
                      title: 'No trips yet',
                      message:
                          'Start planning your next escape. Add a destination, '
                          'then build a day-by-day itinerary.',
                      action: FilledButton.icon(
                        onPressed: () => showTripFormSheet(context),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Plan a trip'),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    sliver: SliverList.separated(
                      itemCount: state.trips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, i) {
                        final trip = state.trips[i];
                        return _Reveal(
                          index: i,
                          child: TripCard(
                            trip: trip,
                            onDelete: () => context
                                .read<TripsCubit>()
                                .deleteTrip(trip.id),
                            onTap: () => Navigator.of(context).push(
                              RoamPageRoute(
                                child: TripDetailPage(tripId: trip.id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

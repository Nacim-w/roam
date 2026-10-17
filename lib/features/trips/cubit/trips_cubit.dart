import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/activity.dart';
import '../../../data/models/trip.dart';
import '../../../data/repositories/roam_repository.dart';
import 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit(this._repository) : super(TripsState(_repository.loadTrips()));

  final RoamRepository _repository;

  Trip? byId(String id) => state.byId(id);

  void _commit(List<Trip> trips) {
    emit(TripsState(trips));
    _repository.saveTrips(trips);
  }

  void addTrip(Trip trip) {
    _commit([trip, ...state.trips]);
  }

  void updateTrip(Trip trip) {
    _commit([
      for (final t in state.trips) if (t.id == trip.id) trip else t,
    ]);
  }

  void deleteTrip(String tripId) {
    _commit(state.trips.where((t) => t.id != tripId).toList());
  }

  void addActivity(String tripId, Activity activity) {
    _commit([
      for (final t in state.trips)
        if (t.id == tripId)
          t.copyWith(activities: [...t.activities, activity])
        else
          t,
    ]);
  }

  void updateActivity(String tripId, Activity activity) {
    _commit([
      for (final t in state.trips)
        if (t.id == tripId)
          t.copyWith(
            activities: [
              for (final a in t.activities)
                if (a.id == activity.id) activity else a,
            ],
          )
        else
          t,
    ]);
  }

  void deleteActivity(String tripId, String activityId) {
    _commit([
      for (final t in state.trips)
        if (t.id == tripId)
          t.copyWith(
            activities:
                t.activities.where((a) => a.id != activityId).toList(),
          )
        else
          t,
    ]);
  }

  void reorderActivities(String tripId, int oldIndex, int newIndex) {
    final trip = state.byId(tripId);
    if (trip == null) return;
    final items = [...trip.activities];
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);
    updateTrip(trip.copyWith(activities: items));
  }
}

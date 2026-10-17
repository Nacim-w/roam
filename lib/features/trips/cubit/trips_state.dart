import 'package:equatable/equatable.dart';

import '../../../data/models/trip.dart';

class TripsState extends Equatable {
  const TripsState(this.trips);

  final List<Trip> trips;

  Trip? byId(String id) {
    for (final t in trips) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  List<Object?> get props => [trips];
}

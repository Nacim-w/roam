import '../models/trip.dart';

abstract class RoamRepository {
  List<String> loadFavoriteIds();
  Future<void> saveFavoriteIds(List<String> ids);

  List<Trip> loadTrips();
  Future<void> saveTrips(List<Trip> trips);

  String newId();
}

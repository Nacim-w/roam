import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/trip.dart';
import 'roam_repository.dart';

class LocalRoamRepository implements RoamRepository {
  LocalRoamRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'roam.favorites';
  static const _tripsKey = 'roam.trips';

  @override
  List<String> loadFavoriteIds() {
    return _prefs.getStringList(_favoritesKey) ?? const [];
  }

  @override
  Future<void> saveFavoriteIds(List<String> ids) {
    return _prefs.setStringList(_favoritesKey, ids);
  }

  @override
  List<Trip> loadTrips() {
    final raw = _prefs.getString(_tripsKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveTrips(List<Trip> trips) {
    final raw = jsonEncode(trips.map((t) => t.toJson()).toList());
    return _prefs.setString(_tripsKey, raw);
  }

  @override
  String newId() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}

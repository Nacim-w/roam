import 'package:equatable/equatable.dart';

import '../../../data/models/destination.dart';

class ExploreState extends Equatable {
  const ExploreState({
    required this.destinations,
    this.category = 'All',
    this.query = '',
  });

  final List<Destination> destinations;
  final String category;
  final String query;

  List<Destination> get visible {
    final q = query.trim().toLowerCase();
    return destinations.where((d) {
      final matchesCategory =
          category == 'All' || d.category == category;
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.country.toLowerCase().contains(q) ||
          d.region.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  bool get isSearching => query.trim().isNotEmpty;

  ExploreState copyWith({
    List<Destination>? destinations,
    String? category,
    String? query,
  }) {
    return ExploreState(
      destinations: destinations ?? this.destinations,
      category: category ?? this.category,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [destinations, category, query];
}

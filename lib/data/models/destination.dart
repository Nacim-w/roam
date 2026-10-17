import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.category,
    required this.tagline,
    required this.description,
    required this.image,
    required this.rating,
    required this.bestSeason,
    required this.highlights,
  });

  final String id;
  final String name;
  final String country;
  final String region;
  final String category;
  final String tagline;
  final String description;
  final String image;
  final double rating;
  final String bestSeason;
  final List<String> highlights;

  @override
  List<Object?> get props => [id];
}

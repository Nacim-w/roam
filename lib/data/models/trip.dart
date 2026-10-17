import 'package:equatable/equatable.dart';

import 'activity.dart';

class Trip extends Equatable {
  const Trip({
    required this.id,
    required this.title,
    required this.destinationName,
    required this.cover,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
  });

  final String id;
  final String title;
  final String destinationName;
  final String cover;
  final DateTime startDate;
  final DateTime endDate;
  final List<Activity> activities;

  int get nights => endDate.difference(startDate).inDays;

  Trip copyWith({
    String? title,
    String? destinationName,
    String? cover,
    DateTime? startDate,
    DateTime? endDate,
    List<Activity>? activities,
  }) {
    return Trip(
      id: id,
      title: title ?? this.title,
      destinationName: destinationName ?? this.destinationName,
      cover: cover ?? this.cover,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'destinationName': destinationName,
        'cover': cover,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'activities': activities.map((a) => a.toJson()).toList(),
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'] as String,
        title: json['title'] as String,
        destinationName: json['destinationName'] as String? ?? '',
        cover: json['cover'] as String? ?? '',
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        activities: (json['activities'] as List<dynamic>? ?? [])
            .map((e) => Activity.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props =>
      [id, title, destinationName, cover, startDate, endDate, activities];
}

import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.title,
    required this.time,
    this.note = '',
    this.category = 'sight',
  });

  final String id;
  final String title;
  final String time;
  final String note;
  final String category;

  Activity copyWith({String? title, String? time, String? note, String? category}) {
    return Activity(
      id: id,
      title: title ?? this.title,
      time: time ?? this.time,
      note: note ?? this.note,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time,
        'note': note,
        'category': category,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        title: json['title'] as String,
        time: json['time'] as String? ?? '',
        note: json['note'] as String? ?? '',
        category: json['category'] as String? ?? 'sight',
      );

  @override
  List<Object?> get props => [id, title, time, note, category];
}

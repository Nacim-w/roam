import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  const FavoritesState(this.ids);

  final Set<String> ids;

  bool contains(String id) => ids.contains(id);

  @override
  List<Object?> get props => [ids];
}

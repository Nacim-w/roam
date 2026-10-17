import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/roam_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repository)
      : super(FavoritesState(_repository.loadFavoriteIds().toSet()));

  final RoamRepository _repository;

  bool isFavorite(String id) => state.contains(id);

  Future<void> toggle(String id) async {
    final next = Set<String>.from(state.ids);
    if (!next.add(id)) {
      next.remove(id);
    }
    emit(FavoritesState(next));
    await _repository.saveFavoriteIds(next.toList());
  }
}

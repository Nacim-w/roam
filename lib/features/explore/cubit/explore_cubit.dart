import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sample_data.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(const ExploreState(destinations: sampleDestinations));

  void selectCategory(String category) {
    if (category == state.category) return;
    emit(state.copyWith(category: category));
  }

  void search(String query) {
    emit(state.copyWith(query: query));
  }

  void clearSearch() {
    if (state.query.isEmpty) return;
    emit(state.copyWith(query: ''));
  }
}

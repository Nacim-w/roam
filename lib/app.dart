import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_shell.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/roam_repository.dart';
import 'features/explore/cubit/explore_cubit.dart';
import 'features/favorites/cubit/favorites_cubit.dart';
import 'features/trips/cubit/trips_cubit.dart';

class RoamApp extends StatelessWidget {
  const RoamApp({super.key, required this.repository});

  final RoamRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExploreCubit()),
        BlocProvider(create: (_) => FavoritesCubit(repository)),
        BlocProvider(create: (_) => TripsCubit(repository)),
      ],
      child: MaterialApp(
        title: 'Roam',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}

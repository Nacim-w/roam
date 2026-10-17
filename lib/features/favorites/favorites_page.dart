import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/page_route.dart';
import '../../core/sample_data.dart';
import '../../widgets/empty_state.dart';
import '../destination/destination_detail_page.dart';
import 'cubit/favorites_cubit.dart';
import 'cubit/favorites_state.dart';
import '../explore/widgets/destination_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            final saved = sampleDestinations
                .where((d) => state.contains(d.id))
                .toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          saved.isEmpty
                              ? 'Your wish list is empty'
                              : '${saved.length} place'
                                  '${saved.length == 1 ? '' : 's'} on your list',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (saved.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.favorite_border,
                      title: 'Nothing saved yet',
                      message:
                          'Tap the heart on any destination to keep it here '
                          'for later.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.74,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final d = saved[i];
                          final tag = 'fav-${d.id}';
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration:
                                Duration(milliseconds: 380 + i * 70),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 20),
                                child: child,
                              ),
                            ),
                            child: DestinationCard(
                              destination: d,
                              heroTag: tag,
                              isFavorite: true,
                              onToggleFavorite: () =>
                                  context.read<FavoritesCubit>().toggle(d.id),
                              onTap: () => Navigator.of(context).push(
                                RoamPageRoute(
                                  child: DestinationDetailPage(
                                    destination: d,
                                    heroTag: tag,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: saved.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

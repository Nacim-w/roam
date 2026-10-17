import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/page_route.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/destination.dart';
import '../../../widgets/empty_state.dart';
import '../../destination/destination_detail_page.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../../favorites/cubit/favorites_state.dart';
import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';
import '../widgets/category_bar.dart';
import '../widgets/destination_card.dart';
import '../widgets/featured_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  bool _searchOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Destination d, String heroTag) {
    Navigator.of(context).push(
      RoamPageRoute(
        child: DestinationDetailPage(
          destination: d,
          heroTag: heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ExploreCubit, ExploreState>(
          builder: (context, state) {
            final visible = state.visible;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(state)),
                if (_searchOpen)
                  SliverToBoxAdapter(child: _searchField()),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                SliverToBoxAdapter(
                  child: CategoryBar(
                    selected: state.category,
                    onSelect: context.read<ExploreCubit>().selectCategory,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                if (visible.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.travel_explore,
                      title: 'No places found',
                      message:
                          'Try another search or pick a different category to '
                          'keep exploring.',
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: FeaturedCard(
                      destination: visible.first,
                      heroTag: 'featured-${visible.first.id}',
                      onTap: () =>
                          _openDetail(visible.first, 'featured-${visible.first.id}'),
                    ),
                  ),
                  SliverToBoxAdapter(child: _sectionLabel(context, visible)),
                  SliverToBoxAdapter(
                    child: _DestinationGrid(
                      key: ValueKey('${state.category}|${state.query}'),
                      destinations: visible,
                      onOpen: _openDetail,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(ExploreState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Roam',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              _CircleIcon(
                icon: _searchOpen ? Icons.close : Icons.search,
                onTap: () {
                  setState(() => _searchOpen = !_searchOpen);
                  if (!_searchOpen) {
                    _searchController.clear();
                    context.read<ExploreCubit>().clearSearch();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Where will you wander next?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: context.read<ExploreCubit>().search,
        decoration: const InputDecoration(
          hintText: 'Search destinations, countries, regions',
          prefixIcon: Icon(Icons.search, color: AppColors.inkSoft),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, List<Destination> visible) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DESTINATIONS', style: AppTypography.eyebrow),
                const SizedBox(height: 6),
                Text(
                  'Places to fall for',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Text(
            '${visible.length}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _DestinationGrid extends StatelessWidget {
  const _DestinationGrid({
    super.key,
    required this.destinations,
    required this.onOpen,
  });

  final List<Destination> destinations;
  final void Function(Destination, String) onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: destinations.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.74,
        ),
        itemBuilder: (context, i) {
          final d = destinations[i];
          final tag = 'explore-${d.id}';
          return _RevealItem(
            index: i,
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              buildWhen: (prev, next) =>
                  prev.contains(d.id) != next.contains(d.id),
              builder: (context, favState) {
                return DestinationCard(
                  destination: d,
                  heroTag: tag,
                  isFavorite: favState.contains(d.id),
                  onToggleFavorite: () =>
                      context.read<FavoritesCubit>().toggle(d.id),
                  onTap: () => onOpen(d, tag),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Fades and lifts a grid cell into place, with a small cascade between
/// siblings. Re-runs whenever the grid is rebuilt for a new filter.
class _RevealItem extends StatelessWidget {
  const _RevealItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + (index % 6) * 70),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 24),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: 20, color: AppColors.ink),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/destination.dart';
import '../../widgets/photo.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../favorites/cubit/favorites_state.dart';
import '../trips/widgets/add_to_trip_sheet.dart';

class DestinationDetailPage extends StatefulWidget {
  const DestinationDetailPage({
    super.key,
    required this.destination,
    required this.heroTag,
  });

  final Destination destination;
  final String heroTag;

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  final _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  static const _expandedHeight = 400.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset >
        _expandedHeight - kToolbarHeight - 24;
    if (show != _showAppBarTitle) {
      setState(() => _showAppBarTitle = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.canvas,
            leading: _GlassButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).maybePop(),
            ),
            title: AnimatedOpacity(
              opacity: _showAppBarTitle ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: Text(
                d.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            actions: [
              BlocBuilder<FavoritesCubit, FavoritesState>(
                buildWhen: (p, n) => p.contains(d.id) != n.contains(d.id),
                builder: (context, favState) {
                  final active = favState.contains(d.id);
                  return _GlassButton(
                    icon: active ? Icons.favorite : Icons.favorite_border,
                    color: active ? const Color(0xFFE4572E) : Colors.white,
                    onTap: () =>
                        context.read<FavoritesCubit>().toggle(d.id),
                  );
                },
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Photo(
                    asset: d.image,
                    heroTag: widget.heroTag,
                    gradient: photoScrim,
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${d.region} · ${d.country}'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          d.name,
                          style: const TextStyle(
                            fontFamily: 'Playfair',
                            color: Colors.white,
                            fontSize: 40,
                            height: 1.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _metaRow(d),
                  const SizedBox(height: 24),
                  Text(
                    d.tagline,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    d.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Text('HIGHLIGHTS', style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.terracotta)),
                  const SizedBox(height: 16),
                  ...d.highlights.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.place_outlined,
                                size: 18, color: AppColors.olive),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              h,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ctaBar(context, d),
    );
  }

  Widget _metaRow(Destination d) {
    return Row(
      children: [
        _MetaChip(
          icon: Icons.star_rounded,
          label: d.rating.toStringAsFixed(1),
          tint: const Color(0xFFC0603C),
        ),
        const SizedBox(width: 10),
        _MetaChip(
          icon: Icons.wb_sunny_outlined,
          label: d.bestSeason,
          tint: AppColors.olive,
        ),
      ],
    );
  }

  Widget _ctaBar(BuildContext context, Destination d) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, 16 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: FilledButton.icon(
        onPressed: () => showAddToTripSheet(context, d),
        icon: const Icon(Icons.add_road, size: 20),
        label: const Text('Add to a trip'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.line),
        boxShadow: AppTheme.cardShadow(strength: 0.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

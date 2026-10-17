import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/destination.dart';
import '../../../widgets/photo.dart';

class DestinationCard extends StatefulWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.heroTag,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Destination destination;
  final String heroTag;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppTheme.cardShadow(strength: _pressed ? 0.6 : 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Photo(
                  asset: d.image,
                  heroTag: widget.heroTag,
                  gradient: photoScrim,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _FavoriteButton(
                    active: widget.isFavorite,
                    onTap: widget.onToggleFavorite,
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        d.country.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          color: Colors.white,
                          fontSize: 21,
                          height: 1.1,
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
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            active ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(active),
            size: 18,
            color: active ? const Color(0xFFE4572E) : Colors.white,
          ),
        ),
      ),
    );
  }
}

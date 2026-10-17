import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/trip.dart';
import '../../../widgets/photo.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onDelete,
  });

  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 168,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: AppTheme.cardShadow(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Dismissible(
            key: ValueKey(trip.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete trip?'),
                      content: Text(
                          '"${trip.title}" and its itinerary will be removed.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
            onDismissed: (_) => onDelete(),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: const Color(0xFF9E4A2C),
              child: const Icon(Icons.delete_outline,
                  color: Colors.white, size: 26),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Photo(
                  asset: trip.cover.isNotEmpty
                      ? trip.cover
                      : 'assets/images/kyoto.jpg',
                  gradient: photoScrim,
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              trip.destinationName.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trip.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Playfair',
                                color: Colors.white,
                                fontSize: 25,
                                height: 1.1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 13, color: Colors.white70),
                                const SizedBox(width: 6),
                                Text(
                                  dateRange(trip.startDate, trip.endDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  countLabel(
                                      trip.activities.length, 'activity',
                                      'activities'),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
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

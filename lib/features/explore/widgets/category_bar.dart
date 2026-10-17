import 'package:flutter/material.dart';

import '../../../core/sample_data.dart';
import '../../../core/theme/app_colors.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: destinationCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final label = destinationCategories[i];
          final active = label == selected;
          return GestureDetector(
            onTap: () => onSelect(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.ink : AppColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: active ? AppColors.ink : AppColors.line,
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppColors.ink,
                ),
                child: Text(label),
              ),
            ),
          );
        },
      ),
    );
  }
}

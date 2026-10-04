import 'package:flutter/material.dart';

import '../models/dare_card.dart';

class DareCardWidget extends StatelessWidget {
  final DareCard card;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  const DareCardWidget({
    super.key,
    required this.card,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final double cardWidth = compact ? 240 : 260; 
    final double cardHeight = compact ? 340 : 330;

    final cardColor = isDark
        ? const Color(0xFF241E23)
        : Colors.white;

    final borderColor = selected
        ? colorScheme.primary
        : colorScheme.primary.withValues(
            alpha: isDark ? 0.35 : 0.18,
          );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        height: cardHeight,
        padding: EdgeInsets.all(compact ? 16 : 22),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderColor,
            width: selected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.28 : 0.08,
              ),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 10 : 12,
                vertical: compact ? 5 : 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: isDark ? 0.16 : 0.08,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                card.category.toUpperCase(),
                style: TextStyle(
                  fontSize: compact ? 9 : 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: compact ? 12 : 18),
            Text(
              card.title,
              textAlign: TextAlign.center,
              maxLines: compact ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 18 : 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: compact ? 12 : 18),
            SizedBox(height: compact ? 12 : 18),
            Flexible(
              child: Center(
                child: Text(
                  card.text,
                  textAlign: TextAlign.center,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: compact ? 14 : 18,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

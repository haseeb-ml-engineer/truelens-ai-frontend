import 'package:flutter/material.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/widgets/app_card.dart';

class ExplainabilityAccordion extends StatefulWidget {
  final List<String> indicators;

  const ExplainabilityAccordion({
    super.key,
    required this.indicators,
  });

  @override
  State<ExplainabilityAccordion> createState() => _ExplainabilityAccordionState();
}

class _ExplainabilityAccordionState extends State<ExplainabilityAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.indicators.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: AppSpacing.spacing12),
                      Text(
                        'Explainability Breakdown',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.spacing16,
                right: AppSpacing.spacing16,
                bottom: AppSpacing.spacing16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.indicators.asMap().entries.map((entry) {
                  final index = entry.key;
                  final indicator = entry.value;
                  // Assign mock weights for visual ranking
                  final weight = 100 - (index * 15);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$weight%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacing12),
                        Expanded(
                          child: Text(
                            indicator,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AppSpacing.animFast,
          ),
        ],
      ),
    );
  }
}

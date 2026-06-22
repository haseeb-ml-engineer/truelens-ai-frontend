import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:deepshield_ai/core/theme/app_spacing.dart';

class RadialConfidenceGauge extends StatelessWidget {
  final double percent;
  final Color color;
  final String calibrationText;

  const RadialConfidenceGauge({
    super.key,
    required this.percent,
    required this.color,
    required this.calibrationText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentText = (percent * 100).toInt().toString();

    return Column(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _ArcPainter(
                  percent: percent,
                  color: color,
                  backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  strokeWidth: 14,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentText%',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'CONFIDENCE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        Text(
          calibrationText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _ArcPainter({
    required this.percent,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startAngle = math.pi * 0.8;
    final sweepAngle = math.pi * 1.4;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    final foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle * percent, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

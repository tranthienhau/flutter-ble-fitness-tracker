import 'dart:math';
import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

/// Circular speedometer gauge used on the live-session screen.
class Speedometer extends StatelessWidget {
  final double speedKmh;
  final double maxKmh;
  const Speedometer({super.key, required this.speedKmh, this.maxKmh = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: CustomPaint(
        painter: _GaugePainter((speedKmh / maxKmh).clamp(0, 1)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CURRENT SPEED', style: AppTheme.labelCaps(size: 11, color: AppColors.primary)),
              const SizedBox(height: 8),
              Text(speedKmh.toStringAsFixed(1), style: AppTheme.stat(size: 60)),
              Text('km/h', style: AppTheme.labelCaps(size: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double fraction;
  _GaugePainter(this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 12;
    const start = pi * 0.75;
    const sweep = pi * 1.5;

    final track = Paint()
      ..color = AppColors.surfaceHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false, track);

    final prog = Paint()
      ..shader = const SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [Color(0xFFFFB694), AppColors.primary],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep * fraction, false, prog);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.fraction != fraction;
}

/// A labelled stat tile (distance, duration, etc.).
class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final Color accent;
  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.accent = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card(accentLeft: accent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 6),
            Text(label.toUpperCase(), style: AppTheme.labelCaps(size: 10)),
          ]),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTheme.stat(size: 26)),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(unit!, style: AppTheme.labelCaps(size: 10)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Small orange sparkline used in the history list.
class Sparkline extends StatelessWidget {
  final List<SpeedSample> samples;
  final double height;
  const Sparkline({super.key, required this.samples, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SparkPainter(samples)),
    );
  }
}

class _SparkPainter extends CustomPainter {
  final List<SpeedSample> samples;
  _SparkPainter(this.samples);

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;
    final maxV = samples.map((e) => e.speedKmh).reduce(max);
    final minV = samples.map((e) => e.speedKmh).reduce(min);
    final range = (maxV - minV).abs() < 0.001 ? 1 : (maxV - minV);
    final path = Path();
    for (var i = 0; i < samples.length; i++) {
      final x = size.width * i / (samples.length - 1);
      final y = size.height - ((samples[i].speedKmh - minV) / range) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.samples != samples;
}

/// BLE signal strength bars (1..4).
class SignalBars extends StatelessWidget {
  final int bars;
  final Color color;
  const SignalBars({super.key, required this.bars, this.color = AppColors.tertiary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        final active = i < bars;
        return Container(
          width: 4,
          height: 4.0 + i * 3,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: active ? color : AppColors.surfaceHighest,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

String fmtDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  final h = d.inHours;
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

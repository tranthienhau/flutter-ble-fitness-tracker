import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets.dart';

class SummaryScreen extends ConsumerWidget {
  final TrainingSession session;
  const SummaryScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Session Summary', style: AppTheme.labelCaps(size: 14, color: AppColors.onSurface)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(Icons.emoji_events, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 12),
                Text('Workout Complete', style: AppTheme.stat(size: 26)),
                const SizedBox(height: 6),
                Text('Great pace! Your dog performed at peak athletic levels today.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                child: StatTile(
                    icon: Icons.straighten,
                    label: 'Total Distance',
                    value: session.distanceKm.toStringAsFixed(2),
                    unit: 'km')),
            const SizedBox(width: 12),
            Expanded(
                child: StatTile(
                    icon: Icons.timer_outlined,
                    label: 'Duration',
                    value: fmtDuration(session.duration))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: StatTile(
                    icon: Icons.speed,
                    label: 'Avg Speed',
                    value: session.avgSpeedKmh.toStringAsFixed(1),
                    unit: 'km/h')),
            const SizedBox(width: 12),
            Expanded(
                child: StatTile(
                    icon: Icons.bolt,
                    label: 'Max Speed',
                    value: session.maxSpeedKmh.toStringAsFixed(1),
                    unit: 'km/h')),
          ]),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SPEED OVER TIME', style: AppTheme.labelCaps(size: 11)),
                const SizedBox(height: 16),
                SizedBox(height: 160, child: _SpeedChart(samples: session.samples)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outline),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref.read(historyProvider.notifier).remove(session.id);
                  Navigator.of(context).pop();
                },
                child: Text('DELETE', style: AppTheme.labelCaps(size: 12, color: AppColors.onSurface)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('DONE', style: AppTheme.labelCaps(size: 12, color: AppColors.onPrimary)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _SpeedChart extends StatelessWidget {
  final List<SpeedSample> samples;
  const _SpeedChart({required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.length < 2) {
      return Center(child: Text('No data', style: TextStyle(color: AppColors.onSurfaceVariant)));
    }
    final spots = samples
        .map((s) => FlSpot(s.elapsed.inSeconds.toDouble(), s.speedKmh))
        .toList();
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

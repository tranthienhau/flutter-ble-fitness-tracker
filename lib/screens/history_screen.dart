import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets.dart';
import 'summary_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(historyProvider);
    final totalKm = sessions.fold<double>(0, (a, s) => a + s.distanceKm);
    final totalMin = sessions.fold<int>(0, (a, s) => a + s.duration.inMinutes);

    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.outline))),
            child: Text('HISTORY', style: AppTheme.labelCaps(size: 18, color: AppColors.onSurface)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _WeeklyCard(km: totalKm, minutes: totalMin, sessions: sessions.length),
                const SizedBox(height: 24),
                Text('RECENT SESSIONS', style: AppTheme.labelCaps(size: 11)),
                const SizedBox(height: 12),
                ...sessions.map((s) => _SessionCard(
                      session: s,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => SummaryScreen(session: s))),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyCard extends StatelessWidget {
  final double km;
  final int minutes;
  final int sessions;
  const _WeeklyCard({required this.km, required this.minutes, required this.sessions});

  @override
  Widget build(BuildContext context) {
    Widget col(String value, String label) => Column(
          children: [
            Text(value, style: AppTheme.stat(size: 24)),
            const SizedBox(height: 4),
            Text(label, style: AppTheme.labelCaps(size: 9)),
          ],
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text('WEEKLY PERFORMANCE', style: AppTheme.labelCaps(size: 11, color: AppColors.primary)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              col(km.toStringAsFixed(1), 'KM'),
              col('${minutes}m', 'TOTAL TIME'),
              col(sessions.toString().padLeft(2, '0'), 'SESSIONS'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final TrainingSession session;
  final VoidCallback onTap;
  const _SessionCard({required this.session, required this.onTap});

  String _when(DateTime d) {
    final now = DateTime.now();
    final day = DateTime(d.year, d.month, d.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;
    final hm = '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    if (diff == 0) return 'Today $hm';
    if (diff == 1) return 'Yesterday $hm';
    return '${d.month}/${d.day} $hm';
  }

  @override
  Widget build(BuildContext context) {
    Widget metric(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.labelCaps(size: 9)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          ],
        );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_when(session.startedAt),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
              ],
            ),
            Text(session.label, style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                metric('DURATION', fmtDuration(session.duration)),
                const SizedBox(width: 24),
                metric('DISTANCE', '${session.distanceKm.toStringAsFixed(1)} km'),
                const SizedBox(width: 24),
                metric('AVG SPEED', '${session.avgSpeedKmh.toStringAsFixed(1)} km/h'),
              ],
            ),
            const SizedBox(height: 12),
            Sparkline(samples: session.samples),
          ],
        ),
      ),
    );
  }
}

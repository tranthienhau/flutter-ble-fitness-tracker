import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../theme.dart';
import '../widgets.dart';
import 'summary_screen.dart';

class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(bleControllerProvider).connected;
    final m = ref.watch(sessionControllerProvider);
    final session = ref.read(sessionControllerProvider.notifier);

    if (connected == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bluetooth_disabled, size: 64, color: AppColors.onSurfaceVariant),
                const SizedBox(height: 16),
                Text('No sensor connected', style: AppTheme.stat(size: 20)),
                const SizedBox(height: 8),
                Text('Connect your Firepaw sensor to start a session.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          _ConnectedBar(name: connected.name),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              children: [
                Center(child: Speedometer(speedKmh: m.speedKmh, maxKmh: 20)),
                const SizedBox(height: 28),
                Row(children: [
                  Expanded(
                      child: StatTile(
                          icon: Icons.straighten,
                          label: 'Distance',
                          value: m.distanceKm.toStringAsFixed(2),
                          unit: 'km')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: StatTile(
                          icon: Icons.timer_outlined,
                          label: 'Elapsed',
                          value: fmtDuration(m.elapsed),
                          accent: AppColors.tertiary)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                      child: StatTile(
                          icon: Icons.speed,
                          label: 'Avg Speed',
                          value: m.avgSpeedKmh.toStringAsFixed(1),
                          unit: 'km/h')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: StatTile(
                          icon: Icons.bolt,
                          label: 'Max Speed',
                          value: m.maxSpeedKmh.toStringAsFixed(1),
                          unit: 'km/h')),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: SizedBox(
              height: 56,
              child: m.running
                  ? FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final s = session.stop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SummaryScreen(session: s)));
                      },
                      icon: const Icon(Icons.stop_circle),
                      label: Text('FINISH WORKOUT',
                          style: AppTheme.labelCaps(size: 14, color: Colors.black)),
                    )
                  : FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: session.start,
                      icon: const Icon(Icons.play_arrow),
                      label: Text('START SESSION',
                          style: AppTheme.labelCaps(size: 14, color: AppColors.onPrimary)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectedBar extends StatelessWidget {
  final String name;
  const _ConnectedBar({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.outline))),
      child: Row(
        children: [
          Text('FIREPAW', style: AppTheme.labelCaps(size: 16, color: AppColors.primary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.circle, size: 8, color: AppColors.tertiary),
              const SizedBox(width: 6),
              Text(name, style: AppTheme.labelCaps(size: 10, color: AppColors.onSurface)),
            ]),
          ),
        ],
      ),
    );
  }
}

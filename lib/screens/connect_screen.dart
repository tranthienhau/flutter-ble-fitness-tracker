import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets.dart';

class ConnectScreen extends ConsumerWidget {
  final VoidCallback onConnected;
  const ConnectScreen({super.key, required this.onConnected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bleControllerProvider);
    final ctrl = ref.read(bleControllerProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          _Header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const SizedBox(height: 24),
                _ScanPulse(scanning: state.status == ScanStatus.scanning),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DISCOVERED DEVICES', style: AppTheme.labelCaps(size: 11)),
                    Text('${state.sensors.length} FOUND',
                        style: AppTheme.labelCaps(size: 11, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.status == ScanStatus.idle && state.sensors.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('Tap "Scan for Sensors" to discover your Firepaw treadmill sensor.',
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.onSurfaceVariant)),
                  ),
                ...state.sensors.map((s) => _SensorCard(
                      sensor: s,
                      connected: state.connected?.id == s.id,
                      onConnect: () async {
                        await ctrl.connect(s);
                        onConnected();
                      },
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: SizedBox(
              height: 56,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: state.status == ScanStatus.scanning ? null : ctrl.scan,
                icon: const Icon(Icons.refresh),
                label: Text('SCAN FOR SENSORS', style: AppTheme.labelCaps(size: 14, color: AppColors.onPrimary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.surfaceHigh))),
      alignment: Alignment.centerLeft,
      child: Text('CONNECT SENSOR',
          style: AppTheme.labelCaps(size: 18, color: AppColors.primaryDeep)),
    );
  }
}

class _ScanPulse extends StatefulWidget {
  final bool scanning;
  const _ScanPulse({required this.scanning});
  @override
  State<_ScanPulse> createState() => _ScanPulseState();
}

class _ScanPulseState extends State<_ScanPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                if (widget.scanning)
                  ...List.generate(3, (i) {
                    final v = ((_c.value + i / 3) % 1.0);
                    return Container(
                      width: 80 + v * 120,
                      height: 80 + v * 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: (1 - v) * 0.4)),
                      ),
                    );
                  }),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 40)],
                  ),
                  child: const Icon(Icons.bluetooth_searching, color: AppColors.onPrimary, size: 44),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final BleSensor sensor;
  final bool connected;
  final VoidCallback onConnect;
  const _SensorCard({required this.sensor, required this.connected, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    final low = sensor.bars <= 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card(
          accentLeft: connected ? AppColors.tertiary : AppColors.outlineVariant),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.surfaceHighest, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.sensors, color: connected ? AppColors.tertiary : AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sensor.name, style: const TextStyle(fontSize: 16, color: AppColors.onSurface)),
                const SizedBox(height: 6),
                Row(children: [
                  SignalBars(bars: sensor.bars, color: connected ? AppColors.tertiary : (low ? AppColors.error : AppColors.onSurfaceVariant)),
                  const SizedBox(width: 8),
                  Text(
                    connected ? 'CONNECTED' : (low ? 'LOW SIGNAL' : 'READY TO PAIR'),
                    style: AppTheme.labelCaps(
                        size: 10, color: connected ? AppColors.tertiary : AppColors.onSurfaceVariant),
                  ),
                ]),
              ],
            ),
          ),
          if (connected)
            const Icon(Icons.check_circle, color: AppColors.tertiary)
          else
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onConnect,
              child: Text('CONNECT', style: AppTheme.labelCaps(size: 11, color: AppColors.onPrimary)),
            ),
        ],
      ),
    );
  }
}

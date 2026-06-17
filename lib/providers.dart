import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'ble_service.dart';
import 'models.dart';

final bleServiceProvider = Provider<BleService>((ref) => SimulatedBleService());

// ---------------------------------------------------------------------------
// Connection state
// ---------------------------------------------------------------------------
enum ScanStatus { idle, scanning, done }

@immutable
class BleState {
  final ScanStatus status;
  final List<BleSensor> sensors;
  final BleSensor? connected;
  const BleState({this.status = ScanStatus.idle, this.sensors = const [], this.connected});

  BleState copyWith({ScanStatus? status, List<BleSensor>? sensors, BleSensor? connected, bool clearConnected = false}) =>
      BleState(
        status: status ?? this.status,
        sensors: sensors ?? this.sensors,
        connected: clearConnected ? null : (connected ?? this.connected),
      );
}

class BleController extends StateNotifier<BleState> {
  BleController(this._service) : super(const BleState());
  final BleService _service;

  Future<void> scan() async {
    state = state.copyWith(status: ScanStatus.scanning, sensors: const []);
    final found = await _service.scan();
    state = state.copyWith(status: ScanStatus.done, sensors: found);
  }

  Future<void> connect(BleSensor sensor) async {
    await _service.connect(sensor);
    state = state.copyWith(connected: sensor);
  }

  Future<void> disconnect() async {
    await _service.disconnect();
    state = state.copyWith(clearConnected: true);
  }
}

final bleControllerProvider =
    StateNotifierProvider<BleController, BleState>((ref) => BleController(ref.watch(bleServiceProvider)));

// ---------------------------------------------------------------------------
// Live session
// ---------------------------------------------------------------------------
@immutable
class LiveMetrics {
  final bool running;
  final Duration elapsed;
  final double speedKmh;
  final double distanceKm;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final List<SpeedSample> samples;

  const LiveMetrics({
    this.running = false,
    this.elapsed = Duration.zero,
    this.speedKmh = 0,
    this.distanceKm = 0,
    this.avgSpeedKmh = 0,
    this.maxSpeedKmh = 0,
    this.samples = const [],
  });
}

class SessionController extends StateNotifier<LiveMetrics> {
  SessionController(this._ref) : super(const LiveMetrics());
  final Ref _ref;

  StreamSubscription<WheelRevolution>? _sub;
  int? _lastRevs;
  Duration? _lastTime;
  double _distanceM = 0;
  double _maxKmh = 0;
  final List<SpeedSample> _samples = [];

  void start() {
    final service = _ref.read(bleServiceProvider);
    _reset();
    state = const LiveMetrics(running: true);
    _sub = service.wheelRevolutions().listen((rev) {
      final circ = service.wheelCircumferenceM;
      if (_lastRevs != null && _lastTime != null) {
        final dRevs = rev.cumulativeRevolutions - _lastRevs!;
        final dt = (rev.lastEventTime - _lastTime!).inMilliseconds / 1000.0;
        if (dt > 0) {
          final dMeters = dRevs * circ;
          _distanceM += dMeters;
          final speedKmh = (dMeters / dt) * 3.6;
          _maxKmh = speedKmh > _maxKmh ? speedKmh : _maxKmh;
          final elapsed = rev.lastEventTime;
          final distanceKm = _distanceM / 1000.0;
          final avg = elapsed.inMilliseconds > 0 ? distanceKm / (elapsed.inMilliseconds / 3600000.0) : 0.0;
          _samples.add(SpeedSample(elapsed, speedKmh));
          state = LiveMetrics(
            running: true,
            elapsed: elapsed,
            speedKmh: speedKmh,
            distanceKm: distanceKm,
            avgSpeedKmh: avg,
            maxSpeedKmh: _maxKmh,
            samples: List.unmodifiable(_samples),
          );
        }
      }
      _lastRevs = rev.cumulativeRevolutions;
      _lastTime = rev.lastEventTime;
    });
  }

  /// Stops the session, persists it to history, and returns the saved record.
  TrainingSession stop() {
    _sub?.cancel();
    final m = state;
    final session = TrainingSession(
      id: 'S${DateTime.now().millisecondsSinceEpoch}',
      startedAt: DateTime.now(),
      label: 'Treadmill Session',
      duration: m.elapsed,
      distanceKm: m.distanceKm,
      avgSpeedKmh: m.avgSpeedKmh,
      maxSpeedKmh: m.maxSpeedKmh,
      samples: m.samples,
    );
    _ref.read(historyProvider.notifier).add(session);
    state = const LiveMetrics();
    return session;
  }

  void _reset() {
    _lastRevs = null;
    _lastTime = null;
    _distanceM = 0;
    _maxKmh = 0;
    _samples.clear();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final sessionControllerProvider =
    StateNotifierProvider<SessionController, LiveMetrics>((ref) => SessionController(ref));

// ---------------------------------------------------------------------------
// History
// ---------------------------------------------------------------------------
class HistoryController extends StateNotifier<List<TrainingSession>> {
  HistoryController() : super(_seed());

  void add(TrainingSession s) => state = [s, ...state];
  void remove(String id) => state = state.where((e) => e.id != id).toList();

  static List<TrainingSession> _seed() {
    List<SpeedSample> curve(double peak) => List.generate(
        24, (i) => SpeedSample(Duration(seconds: i * 60), (peak * (0.4 + 0.6 * (1 - ((i - 12).abs() / 12)))).clamp(0, peak)));
    final now = DateTime.now();
    return [
      TrainingSession(
        id: 'seed1',
        startedAt: now.subtract(const Duration(hours: 3)),
        label: 'Morning Endurance Run',
        duration: const Duration(minutes: 45),
        distanceKm: 5.15,
        avgSpeedKmh: 8.5,
        maxSpeedKmh: 12.4,
        samples: curve(12.4),
      ),
      TrainingSession(
        id: 'seed2',
        startedAt: now.subtract(const Duration(days: 1)),
        label: 'Recovery Pace',
        duration: const Duration(minutes: 32),
        distanceKm: 3.37,
        avgSpeedKmh: 4.2,
        maxSpeedKmh: 6.1,
        samples: curve(6.1),
      ),
      TrainingSession(
        id: 'seed3',
        startedAt: now.subtract(const Duration(days: 2)),
        label: 'High-Intensity Interval',
        duration: const Duration(minutes: 58),
        distanceKm: 8.69,
        avgSpeedKmh: 12.1,
        maxSpeedKmh: 18.3,
        samples: curve(18.3),
      ),
    ];
  }
}

final historyProvider =
    StateNotifierProvider<HistoryController, List<TrainingSession>>((ref) => HistoryController());

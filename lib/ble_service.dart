import 'dart:async';
import 'dart:math';

import 'models.dart';

/// A raw reading from the BLE wheel-rotation (CSC-style) speed sensor:
/// cumulative wheel revolutions plus the timestamp of the last wheel event.
/// This mirrors the Bluetooth CSC Measurement characteristic so the app logic
/// is identical whether the data comes from real hardware or this simulator.
class WheelRevolution {
  final int cumulativeRevolutions;
  final Duration lastEventTime;
  const WheelRevolution(this.cumulativeRevolutions, this.lastEventTime);
}

/// BLE transport abstraction. The simulated implementation lets the whole app
/// be demoed on a simulator with no hardware; swapping in flutter_reactive_ble
/// for the real Firepaw sensor only touches this one class.
abstract class BleService {
  /// Treadmill wheel circumference in metres (used to convert revs -> distance).
  double get wheelCircumferenceM;

  Future<List<BleSensor>> scan();
  Future<void> connect(BleSensor sensor);
  Future<void> disconnect();

  /// Cumulative wheel-revolution stream from the connected sensor.
  Stream<WheelRevolution> wheelRevolutions();
}

class SimulatedBleService implements BleService {
  @override
  final double wheelCircumferenceM = 1.20; // ~38cm dia treadmill drum

  final _rng = Random(42);

  @override
  Future<List<BleSensor>> scan() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    return const [
      BleSensor(id: 'A3', name: 'Firepaw Sensor #A3', rssi: -52),
      BleSensor(id: 'B7', name: 'Firepaw Sensor #B7', rssi: -71),
      BleSensor(id: 'X1', name: 'Firepaw Sensor #X1', rssi: -88),
    ];
  }

  @override
  Future<void> connect(BleSensor sensor) async {
    await Future.delayed(const Duration(milliseconds: 900));
  }

  @override
  Future<void> disconnect() async {}

  @override
  Stream<WheelRevolution> wheelRevolutions() async* {
    // Models a treadmill warm-up -> steady run -> cool-down speed profile and
    // emits cumulative revolutions every 250ms like a real CSC sensor.
    const tick = Duration(milliseconds: 250);
    int cumulative = 0;
    Duration t = Duration.zero;
    while (true) {
      await Future.delayed(tick);
      t += tick;
      final targetKmh = _targetSpeed(t);
      // revs this tick = speed(m/s) * dt(s) / circumference, with light jitter.
      final mps = targetKmh / 3.6;
      final revs = (mps * (tick.inMilliseconds / 1000.0)) / wheelCircumferenceM;
      final jittered = revs * (0.95 + _rng.nextDouble() * 0.1);
      cumulative += jittered.round().clamp(0, 1000);
      // ensure forward progress at speed
      if (jittered > 0 && jittered < 1) cumulative += 1;
      yield WheelRevolution(cumulative, t);
    }
  }

  double _targetSpeed(Duration t) {
    final s = t.inMilliseconds / 1000.0;
    if (s < 6) return 4 + s * 1.2; // warm up to ~11
    if (s < 26) return 11 + sin(s / 3) * 1.5; // steady run, gentle variation
    return max(0, 12 - (s - 26) * 1.0); // cool down
  }
}

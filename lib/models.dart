import 'package:flutter/foundation.dart';

/// A discovered BLE speed sensor (Firepaw treadmill sensor).
@immutable
class BleSensor {
  final String id;
  final String name;
  final int rssi; // signal strength, dBm
  const BleSensor({required this.id, required this.name, required this.rssi});

  /// Signal bars 1..4 derived from RSSI.
  int get bars {
    if (rssi >= -55) return 4;
    if (rssi >= -67) return 3;
    if (rssi >= -80) return 2;
    return 1;
  }
}

/// A single live speed/distance sample emitted while a session is running.
@immutable
class SpeedSample {
  final Duration elapsed;
  final double speedKmh;
  const SpeedSample(this.elapsed, this.speedKmh);
}

/// A completed (or in-progress) training session.
@immutable
class TrainingSession {
  final String id;
  final DateTime startedAt;
  final String label;
  final Duration duration;
  final double distanceKm;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final List<SpeedSample> samples;

  const TrainingSession({
    required this.id,
    required this.startedAt,
    required this.label,
    required this.duration,
    required this.distanceKm,
    required this.avgSpeedKmh,
    required this.maxSpeedKmh,
    this.samples = const [],
  });
}

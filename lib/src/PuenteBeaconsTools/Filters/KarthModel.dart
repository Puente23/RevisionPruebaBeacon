import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class KarthmantModel with ChangeNotifier {
  KarthmantModel(double processNoise, double sensorNoise, double estimatedError,
      double initValue) {
    q = processNoise;
    r = sensorNoise;
    p = estimatedError;
    x = initValue;
    if (kDebugMode) {
      print("Kalman Filter Initializad");
    }
  }
  static const double training_Prdiction_limit = 500;
  late double q;
  late double r;
  late double p;
  late double x;
  late double k;
  double predictionCycle = 0;
  late var _beaconScanner;
  List<Beacon> _beacons = [];
  List<Beacon> get beacons => _beacons;

  // Function to start scanning for beacons
  Future<void> locateBeacons() async {
    await _beaconScanner.initializeScanning();
    _beaconScanner.ranging().listen((RangingResult result) {
      try {
        if (result.beacons.isNotEmpty) {
          _beacons = result.beacons;
          notifyListeners();
        }
      } on Exception catch (e) {
        print(e);
      }
    });
  }

  Future<void> stopScanning() async {
    _beaconScanner?.stopScanning();
  }

  double getFilterValue(double mesurement) {
    // prediction phase
    p = p + q;

    // measurement update
    k = p / (p + r);
    x = x + k * (mesurement - x);
    p = (1 - k) * p;

    return x;
  }
}

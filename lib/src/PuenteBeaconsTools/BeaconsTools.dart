import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:ejemplocodec/src/Data/models.dart';
import 'package:ejemplocodec/src/PuenteBeaconsTools/DistanceAlgorithms/BeaconLibraryModels.dart';
import 'package:ejemplocodec/src/PuenteBeaconsTools/DistanceAlgorithms/LogDistancePathLoss.dart';
import 'package:ejemplocodec/src/PuenteBeaconsTools/Filters/KarthModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_blue/flutter_blue.dart'
    show BluetoothDevice, DeviceIdentifier, FlutterBlue, Guid, ScanResult;
import 'package:flutter_blue/gen/flutterblue.pbjson.dart';

List<Beacon> beaconList = [];

KarthmantModel kf = KarthmantModel(0.065, 1.4, 0, 0);
final StreamController<String> beaconEventsController =
    StreamController<String>.broadcast();

abstract class Beacon {
  final int tx;
  final ScanResult scanResult;
  double get rawRssi => scanResult.rssi.toDouble();
  double get kfRssi => kf.getFilterValue(rawRssi);

  String get name => scanResult.device.name;
  DeviceIdentifier get id => scanResult.device.id;
  int get hash;
  int get txAt1Meter => tx;
  double get rawRssiLogDistance {
    return LogDistancePathLoss(rawRssi).getCalculatedDistance();
  }

  double get kfRssiLogDistance {
    return LogDistancePathLoss(kfRssi).getCalculatedDistance();
  }

  double get rawRssiLibraryDistance {
    return BeaconLibraryModels().getCalculatedDistance(rawRssi, txAt1Meter);
  }

  double get kfRssiLibraryDistance {
    return BeaconLibraryModels().getCalculatedDistance(kfRssi, txAt1Meter);
  }

  const Beacon({required this.tx, required this.scanResult});

  static List<BluetoothDevice> fromScanResult(ScanResult scanResult) {
    List<BluetoothDevice> beaconList = <BluetoothDevice>[];
    try {
      for (int i = 0; i < beaconList.length; i++) {
        beaconList.add(scanResult.device);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error: " + e.toString());
      }
    }
    return beaconList;
  }
}

import 'package:ejemplocodec/src/Providers/BeaconsProvider.dart';

class Beacon {
  final String? ubicacion;
  final String id;
  final String uuid;
  final int major;
  final int minor;
  final double rssi;
  final double accuracy;

  Beacon({
    this.ubicacion,
    required this.id,
    required this.accuracy,
    required this.uuid,
    required this.major,
    required this.minor,
    required this.rssi,
  });

  Map<String, dynamic> toMap() {
    return {
      'ubicacion': ubicacion,
      'id': id,
      'uuid': uuid,
      'major': major,
      'minor': minor,
      'rssi': rssi,
      'accuracy': accuracy
    };
  }

  factory Beacon.fromMap(Map<String, dynamic> map) {
    return Beacon(
        id: map[BeaconDbHelper.columnId],
        uuid: map[BeaconDbHelper.columnUuid],
        major: map[BeaconDbHelper.columnMajor],
        minor: map[BeaconDbHelper.columnMinor],
        rssi: map[BeaconDbHelper.columnRssi],
        ubicacion: map[BeaconDbHelper.ubicacion],
        accuracy: map[BeaconDbHelper.columnMajor]);
  }
}

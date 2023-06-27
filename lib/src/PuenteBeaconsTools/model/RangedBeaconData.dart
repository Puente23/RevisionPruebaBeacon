class RangedBeaconData {
  List<double> rawRssi = <double>[];
  List<double> rawRssiDistance = <double>[];
  List<double> kfRssi = <double>[];
  List<double> kfRssiDistance = <double>[];

  late double x;
  late double y;

  RangedBeaconData(String? pPhoneMake, String? pBeaconUUID, int? pTxAt1Meter) {
    late String? phoneMake = pPhoneMake;
    late String? beaconUUID = pBeaconUUID;
    late int? txAt1Meter = pTxAt1Meter;
  }

  late String phoneMake;
  late String beaconUUID;
  late int txAt1Meter;

  addRawRssi(double rssi) {
    rawRssi.add(rssi);
  }

  addkfRssi(double rssi) {
    kfRssi.add(rssi);
  }

  addRawRssiDistance(double distance) {
    rawRssiDistance.add(distance);
  }

  addkfRssiDistance(double distance) {
    kfRssiDistance.add(distance);
  }

  Map<String, dynamic> toJson() => {
        'phoneMake': phoneMake,
        'beaconUUID': beaconUUID,
        'txAt1Meter': txAt1Meter,
        'rawRssi': rawRssi,
        'rawRssiDist': rawRssiDistance,
        'kfRssi': kfRssi,
        'kfRssiDist': kfRssiDistance,
      };
}

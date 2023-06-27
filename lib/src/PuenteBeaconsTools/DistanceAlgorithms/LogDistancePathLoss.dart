import 'dart:core';
import 'dart:math';

class LogDistancePathLoss {
  LogDistancePathLoss(double rssiMeasured) {
    rssi = rssiMeasured;
  }
  get referencePathLoss => null;
  double log10(num x) => log(x) / ln10;
  late double rssi;
  final double referenceDistance = 0.944;
  final double referencesRSSI = -55;
  final double pathlossExponent = 0.3;
  final double flatFlandingMitigation = 0;
/*
Rssi= distance
ReferenceDistance= 0.944
ReferencesRSSI= -55
PathlossExponent=0.3
FlatFlandingMitigation=0
*/
  double getCalculatedDistance() {
    double distance;
    if (rssi <= 0 ||
        referenceDistance <= 0 ||
        pathlossExponent <= 0 ||
        referencePathLoss <= 0) {
      throw Exception("All parameters must be greater than zero.");
    }
    double rssiDIFF = rssi - referencesRSSI - flatFlandingMitigation;
    num i = pow(10, -(rssiDIFF / 10 * pathlossExponent));
    distance = referenceDistance * i;
    return referencePathLoss +
        10 * pathlossExponent * log10(distance / referenceDistance);
  }
}

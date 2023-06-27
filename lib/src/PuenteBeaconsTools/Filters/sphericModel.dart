import 'dart:math';

double sphericModel(double lat1, double long1, double alt1, double lat2,
    double long2, double alt2) {
  const double R = 6371000; // radio de la tierra en metros
  final double lat1Rad = lat1 * pi / 180;
  final double lat2Rad = lat2 * pi / 180;
  final double deltaLat = (lat2 - lat1) * pi / 180;
  final double deltaLong = (long2 - long1) * pi / 180;

  final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(deltaLong / 2) * sin(deltaLong / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final double distance = R * c;
  final double altitude = alt2 - alt1;

  return sqrt(distance * distance + altitude * altitude);
}

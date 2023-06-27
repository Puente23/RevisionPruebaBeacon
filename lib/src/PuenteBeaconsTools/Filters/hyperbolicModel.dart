import 'dart:math';

double hyperbolicModel(
    double x1, double y1, double z1, double x2, double y2, double z2) {
  final double distance = (x1 * x2 + y1 * y2 + z1 * z2 - 1) / 2;
  return acos(distance);
}

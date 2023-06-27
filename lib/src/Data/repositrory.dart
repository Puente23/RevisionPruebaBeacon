import 'package:ejemplocodec/src/models/model.dart';
import 'package:flutter/services.dart' show rootBundle;

class InfoSensorServices {
  static Future<String> _loadAStudentAsset() async {
    return await rootBundle.loadString('assets/menu.json');
  }

  static Future loadStudent() async {
    String jsonString = await _loadAStudentAsset();
    return opcionesModelFromJson(jsonString);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show TargetPlatform;

import 'package:beacon_broadcast/beacon_broadcast.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'BeaconInfo.dart';
import 'RangedBeaconData.dart';

class AppStateModel extends foundation.ChangeNotifier {
  // Singleton
  AppStateModel._();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final AppStateModel _instance = AppStateModel._();

  static AppStateModel get instance => _instance;

  bool wifiEnabled = false;
  bool bluetoothEnabled = false;
  bool gpsEnabled = false;
  bool gpsAllowed = false;

  PermissionStatus locationPermissionStatus = PermissionStatus.limited;

  late BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  late String beaconStatusMessage;
  late bool isBroadcasting = false;
  late bool isScanning = false;

  Uuid uuid = const Uuid();

  String id = "";

  String phoneMake = "";

  late List<BeaconInfo> anchorBeacons;

  final String anchorKey = 'AnchorNodes';
  final String rangedKey = 'RangedNodes';
  final String wtKey = 'WeightedTri';
  final String minmaxKey = 'MinMax';

  /* late CollectionReference anchorPath =
      FirebaseFirestore.instance.collection('AnchorNodes');

  late CollectionReference rangedPath =
      FirebaseFirestore.instance.collection('RangedNodes');

  late CollectionReference wtPath =
      FirebaseFirestore.instance.collection('WeightedTri');

  late CollectionReference minmaxPath =
      FirebaseFirestore.instance.collection('MinMax');
*/
  //late Stream<QuerySnapshot> beaconSnapshots;

  // ignore: cancel_subscriptions
  late StreamSubscription beaconStream;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void init() async {
    debugPrint("init() called");
    // _prefs.initPrefs();
    anchorBeacons = <BeaconInfo>[];

    // FirebaseFirestore.instance.settings;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    phoneMake = androidInfo.model.toString();
    print('Running on $phoneMake');

    id = uuid.v1().toString();
    id = id.replaceAll(RegExp('-'), '');

    if (Platform.isAndroid) {
      // For Android, the user's uuid has to be 20 chars long to conform
      // with Eddystones NamespaceId length
      // Also has to be without hyphens
      id = id.substring(0, 20);

      if (id.length == 20) {
        debugPrint("Android users ID is the correct format");
      } else {
        debugPrint('user ID was of an incorrect format');
        debugPrint(id);
      }
    }
    streamAnchorBeacons();
  }

  /*void registerBeacon(BeaconInfo bc, String path) async {
    await anchorPath.doc(path).set(bc.toJson());
  }

  void removeBeacon(String path) async {
    await anchorPath.doc(path).delete();
  }*/
  Future<void> registerBeacon(BeaconInfo bc, String beaconPath) async {
    List<String> beaconList =
        (await _prefs).getStringList(anchorKey) ?? <String>[];
    beaconList.add(bc.toJson().toString());
    await (await _prefs).setStringList(anchorKey, beaconList);
  }

  Future<void> removeBeacon(String path) async {
    List<String> beaconList = (await _prefs).getStringList(anchorKey) ?? [];
    beaconList.remove(path);
    await (await _prefs).setStringList(anchorKey, beaconList);
  }

  Future<void> uploadRangedBeaconData(
      RangedBeaconData rbd, String beaconName) async {
    await (await _prefs).setString(beaconName, rbd.toJson().toString());
  }

/*void streamAnchorBeacons() {
  List<String>? beaconList = _prefs.getStringList(anchorKey);
  anchorBeacons.clear();
  for (var item in beaconList!) {
    anchorBeacons = List.from(anchorBeacons);
    anchorBeacons.add(BeaconInfo.fromJson(item));
  }
  debugPrint("REGISTERED BEACONS: " + anchorBeacons.length.toString());
}*/

  void streamAnchorBeacons() async {
    List<String>? beaconList = (await _prefs).getStringList(anchorKey);
    anchorBeacons.clear();
    if (beaconList != null) {
      for (var item in beaconList) {
        anchorBeacons = List.from(anchorBeacons);
        var beaconInfo = jsonDecode(item);
        anchorBeacons.add(BeaconInfo.fromJson(beaconInfo));
      }
    }
    debugPrint("REGISTERED BEACONS: ${anchorBeacons.length}");
  }

  List<BeaconInfo> getAnchorBeacons() {
    return anchorBeacons;
  }

  Future<void> addWTXY(var coordinates) async {
    List<String> wtCoordinates = (await _prefs).getStringList(wtKey) ?? [];
    wtCoordinates.add(coordinates.toString());
    (await _prefs).setStringList(wtKey, wtCoordinates);
  }

  Future<void> addMinMaxXY(var coordinates) async {
    List<String> minmaxCoordinates =
        (await _prefs).getStringList(minmaxKey) ?? [];
    minmaxCoordinates.add(coordinates.toString());
    (await _prefs).setStringList(minmaxKey, minmaxCoordinates);
  }

  startBeaconBroadcast() async {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();

    var transmissionSupportStatus =
        await beaconBroadcast.checkTransmissionSupported();
    switch (transmissionSupportStatus) {
      case BeaconStatus.supported:
        print("Beacon advertising is supported on this device");

        if (Platform.isAndroid) {
          debugPrint("User beacon uuid: " + id);

          beaconBroadcast
              .setUUID(id)
              .setMajorId(aleatorio2(1, 99))
              .setTransmissionPower(-59)
              .setLayout(BeaconBroadcast.EDDYSTONE_UID_LAYOUT)
              .start();
        }

        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
          beaconStatusMessage = "Beacon is now advertising";
          //   isBroadcasting = true;
        });
        break;

      case BeaconStatus.notSupportedMinSdk:
        beaconStatusMessage =
            "Your Android system version is too low (min. is 21)";
        print(beaconStatusMessage);
        break;
      case BeaconStatus.notSupportedBle:
        beaconStatusMessage = "Your device doesn't support BLE";
        print(beaconStatusMessage);
        break;
      case BeaconStatus.notSupportedCannotGetAdvertiser:
        beaconStatusMessage = "Either your chipset or driver is incompatible";
        print(beaconStatusMessage);
        break;
    }
  }

  stopBeaconBroadcast() {
    beaconStatusMessage = "Beacon has stopped advertising";
    beaconBroadcast.stop();
    print(beaconStatusMessage);
  }

  checkGPS() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      print("GPS disabled");
      gpsEnabled = false;
    } else {
      print("GPS enabled");
      gpsEnabled = true;
    }
  }

  // Adapted from: https://dev.to/ahmedcharef/flutter-wait-user-enable-gps-permission-location-4po2#:~:text=Flutter%20Permission%20handler%20Plugin&text=Check%20if%20a%20permission%20is,permission%20status%20of%20location%20service.
  Future<bool> requestPermission(permission) async {
    if (await Permission.location.request().isGranted) {
      print("Permission granted.");
      return true;
    }
    return false;
  }

  // Adapted from: https://dev.to/ahmedcharef/flutter-wait-user-enable-gps-permission-location-4po2#:~:text=Flutter%20Permission%20handler%20Plugin&text=Check%20if%20a%20permission%20is,permission%20status%20of%20location%20service.
  Future<bool> requestLocationPermission({Function? onPermissionDenied}) async {
    var granted = await requestPermission(Permission.location);
    if (granted != true) {
      gpsAllowed = false;
      requestLocationPermission();
    } else {
      gpsAllowed = true;
    }
    debugPrint('requestLocationPermission $granted');
    return granted;
  }

  Future<void> checkLocationPermission() async {
    gpsAllowed = await requestPermission(Permission.location);
  }
}

int aleatorio2(int min, int max) {
  return Random().nextInt(max - min + 1) + min;
}

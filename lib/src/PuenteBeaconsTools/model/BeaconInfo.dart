import 'dart:convert';

BeaconInfo beaconFromJson(String str) => BeaconInfo.fromJson(json.decode(str));

String beaconToJson(BeaconInfo data) => json.encode(data.toJson());

class BeaconInfo {
  BeaconInfo(
      {required this.phoneMake,
      required this.beaconUUID,
      required this.txPower,
      required this.standardBroadcasting,
      this.x,
      this.y});

  final String phoneMake;
  final String beaconUUID;
  final String txPower;
  final String standardBroadcasting;

  var x;
  var y;

  factory BeaconInfo.fromJson(Map<String, dynamic> json) => BeaconInfo(
      phoneMake: json["phoneMake"],
      beaconUUID: json['beaconUUID'],
      txPower: json['txPower'],
      standardBroadcasting: json['standardBroadcasting'],
      x: json['xCoordinate'],
      y: json['yCoordinate']);

  Map<String, dynamic> toJson() => {
        'phoneMake': phoneMake,
        'beaconUUID': beaconUUID,
        'txPower': txPower,
        'standardBroadcasting': standardBroadcasting,
        'xCoordinate': x,
        'yCoordinate': y
      };
}

// To parse this JSON data, do
//
//     final tarea = tareaFromMap(jsonString);

import 'dart:convert';

import 'package:ejemplocodec/src/Providers/BeaconsProvider.dart';

class Tarea {
  Tarea({
    required this.opciones,
    required this.opcionesSecundarias,
    required this.actividades,
  });

  final List<Opcione> opciones;
  final List<Actividade> opcionesSecundarias;
  final List<Actividade> actividades;

  factory Tarea.fromJson(String str) => Tarea.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tarea.fromMap(Map<String, dynamic> json) => Tarea(
        opciones:
            List<Opcione>.from(json["Opciones"].map((x) => Opcione.fromMap(x))),
        opcionesSecundarias: List<Actividade>.from(
            json["OpcionesSecundarias"].map((x) => Actividade.fromMap(x))),
        actividades: List<Actividade>.from(
            json["Actividades"].map((x) => Actividade.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Opciones": List<dynamic>.from(opciones.map((x) => x.toMap())),
        "OpcionesSecundarias":
            List<dynamic>.from(opcionesSecundarias.map((x) => x.toMap())),
        "Actividades": List<dynamic>.from(actividades.map((x) => x.toMap())),
      };
}

class Actividade {
  Actividade({
    this.idOpcAct,
    required this.nombre,
    required this.estado,
    required this.refencia,
    this.idOpcSec,
  });

  final int? idOpcAct;
  final String nombre;
  final bool estado;
  final int refencia;
  final int? idOpcSec;

  factory Actividade.fromJson(String str) =>
      Actividade.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Actividade.fromMap(Map<String, dynamic> json) => Actividade(
        idOpcAct: json["idOpcAct"],
        nombre: json["nombre"],
        estado: json["estado"],
        refencia: json["refencia"],
        idOpcSec: json["idOpcSec"],
      );

  Map<String, dynamic> toMap() => {
        "idOpcAct": idOpcAct,
        "nombre": nombre,
        "estado": estado,
        "refencia": refencia,
        "idOpcSec": idOpcSec,
      };
}

class Opcione {
  Opcione({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  final int id;
  final String nombre;
  final bool estado;

  factory Opcione.fromJson(String str) => Opcione.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Opcione.fromMap(Map<String, dynamic> json) => Opcione(
        id: json["id"],
        nombre: json["nombre"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "estado": estado,
      };
}

class Usuario {
  final int id;
  final String nombre;
  final String tipo;
  final String apellido_M;
  final String apellido_P;
  final int id_dispositivo;
  static const String TABLENAME = "usuarios";
  Usuario(
      {required this.id,
      required this.nombre,
      required this.tipo,
      required this.apellido_M,
      required this.apellido_P,
      required this.id_dispositivo});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'apellido_M': apellido_M,
      'apellido_P': apellido_P,
      'id_dispositivo': id_dispositivo
    };
  }
}

class Ubicaciones {
  final int id;
  final String ubicacion;
  final String nombre;
  final String gps;
  static const String TABLENAME = "ubicaciones";
  Ubicaciones(
      {required this.id,
      required this.ubicacion,
      required this.nombre,
      required this.gps});
  Map<String, dynamic> toMap() {
    return {'id': id, 'ubicacion': ubicacion, 'nombre': nombre, 'gps': gps};
  }
}

Beacon0 beaconFromJson(String str) => Beacon0.fromJson(json.decode(str));

String beaconToJson(Beacon0 data) => json.encode(data.toJson());

class Beacon0 {
  Beacon0({
    this.name,
    required this.uuid,
    required this.macAddress,
    required this.major,
    required this.minor,
    required this.distance,
    required this.proximity,
    required this.scanTime,
    required this.rssi,
    required this.txPower,
    required this.id,
  });

  final String? name;
  final String id;
  final String uuid;
  final String macAddress;
  final String major;
  final String minor;
  final String distance;
  final String proximity;
  final String scanTime;
  final String rssi;
  final String txPower;

  factory Beacon0.fromJson(Map<String, dynamic> json) => Beacon0(
        name: json["name"],
        uuid: json["uuid"],
        macAddress: json["macAddress"],
        major: json["major"],
        minor: json["minor"],
        distance: json["distance"],
        proximity: json["proximity"],
        scanTime: json["scanTime"],
        rssi: json["rssi"],
        txPower: json["txPower"],
        id: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "id": uuid,
        "name": name,
        "uuid": uuid,
        "macAddress": macAddress,
        "major": major,
        "minor": minor,
        "distance": distance,
        "proximity": proximity,
        "scanTime": scanTime,
        "rssi": rssi,
        "txPower": txPower,
      };
}

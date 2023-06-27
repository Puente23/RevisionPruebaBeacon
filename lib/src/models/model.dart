import 'dart:convert';

import 'package:ejemplocodec/src/Domain/entities.dart';

OpcionesModel opcionesModelFromJson(String str) =>
    OpcionesModel.fromJson(json.decode(str));

String opcionesModelToJson(OpcionesModel data) => json.encode(data.toJson());

class OpcionesModel {
  OpcionesModel({
    required this.opciones,
    required this.opcionesSecundarias,
    required this.actividades,
  });

  List<OpcionesM> opciones;
  List<OpcionesSecundariasM> opcionesSecundarias;
  List<ActividadesM> actividades;

  factory OpcionesModel.fromJson(Map<String, dynamic> json) => OpcionesModel(
        opciones: List<OpcionesM>.from(
            json["Opciones"].map((x) => OpcionesM.fromJson(x))),
        opcionesSecundarias: List<OpcionesSecundariasM>.from(
            json["OpcionesSecundarias"]
                .map((x) => OpcionesSecundariasM.fromJson(x))),
        actividades: List<ActividadesM>.from(
            json["Actividades"].map((x) => ActividadesM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
        "OpcionesSecundarias":
            List<dynamic>.from(opcionesSecundarias.map((x) => x.toJson())),
        "Actividades": List<dynamic>.from(actividades.map((x) => x.toJson())),
      };
}

class ActividadesM extends Actividades {
  ActividadesM({
    required this.idOpcAct,
    required this.nombre,
    required this.estado,
    required this.refencia,
  }) : super(
            idOpcAct: idOpcAct,
            nombre: nombre,
            estado: estado,
            refencia: refencia);

  int idOpcAct;
  String nombre;
  bool estado;
  int refencia;

  factory ActividadesM.fromJson(Map<String, dynamic> json) => ActividadesM(
        idOpcAct: json["idOpcAct"],
        nombre: json["nombre"],
        estado: json["estado"],
        refencia: json["refencia"],
      );

  Map<String, dynamic> toJson() => {
        "idOpcAct": idOpcAct,
        "nombre": nombre,
        "estado": estado,
        "refencia": refencia,
      };
}

class OpcionesSecundariasM extends OpcionesSecundarias {
  OpcionesSecundariasM({
    required this.idOpcSec,
    required this.nombre,
    required this.estado,
    required this.refencia,
  }) : super(
            idOpcSec: idOpcSec,
            nombre: nombre,
            estado: estado,
            refencia: refencia);

  int idOpcSec;
  String nombre;
  bool estado;
  int refencia;

  factory OpcionesSecundariasM.fromJson(Map<String, dynamic> json) =>
      OpcionesSecundariasM(
        idOpcSec: json["idOpcSec"],
        nombre: json["nombre"],
        estado: json["estado"],
        refencia: json["refencia"],
      );

  Map<String, dynamic> toJson() => {
        "idOpcSec": idOpcSec,
        "nombre": nombre,
        "estado": estado,
        "refencia": refencia,
      };
}

class OpcionesM extends Opciones {
  OpcionesM({
    required this.id,
    required this.nombre,
    required this.estado,
  }) : super(
          id: id,
          nombre: nombre,
          estado: estado,
        );

  int id;
  String nombre;
  bool estado;

  factory OpcionesM.fromJson(Map<String, dynamic> json) => OpcionesM(
        id: json["id"],
        nombre: json["nombre"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "estado": estado,
      };
}

class Actividades {
  Actividades({
    required this.idOpcAct,
    required this.nombre,
    required this.estado,
    required this.refencia,
  });

  int idOpcAct;
  String nombre;
  bool estado;
  int refencia;
}

class OpcionesSecundarias {
  OpcionesSecundarias({
    required this.idOpcSec,
    required this.nombre,
    required this.estado,
    required this.refencia,
  });

  int idOpcSec;
  String nombre;
  bool estado;
  int refencia;
}

class Opciones {
  Opciones({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  int id;
  String nombre;
  bool estado;
}

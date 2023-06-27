import 'package:ejemplocodec/src/Domain/entities.dart';
import 'package:ejemplocodec/src/Providers/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double width;
  final double height;
  final Color color;

  const RoundButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width = 200,
      this.height = 50,
      this.color = const Color.fromARGB(255, 243, 159, 33)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RawMaterialButton(
        shape: const CircleBorder(),
        fillColor: color,
        elevation: 10,
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
/*
USO:
RoundButton(
  text: "Presioname",
  onPressed: () {
    print("Presionado");
  },
),

 */

//clases de Opciones de ubicacion, lugar en la ubicacion, Actividad en la ubicacion
class BotonCircularOpc extends StatelessWidget {
  const BotonCircularOpc({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final Opciones opcion;

  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 114, 7),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 206, 183, 56),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Color.fromARGB(255, 15, 16, 24),
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      child: IconButton(
        onPressed: () => infoData.setListOpcionesSec(opcion.id),
        icon: Column(
          children: [
            const Icon(
              Icons.home,
              size: 35.0,
            ),
            Text(
              opcion.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BotonCircularOpcSec extends StatelessWidget {
  const BotonCircularOpcSec({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final OpcionesSecundarias opcion;

  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 230, 114, 7),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
        color: Color.fromARGB(255, 230, 114, 7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        onPressed: () => infoData.setListActividades(opcion.idOpcSec),
        icon: Column(
          children: [
            const Icon(
              Icons.home,
              size: 35.0,
            ),
            Text(
              opcion.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BotonCircularAct extends StatelessWidget {
  const BotonCircularAct({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final Actividades opcion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 114, 7),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 230, 114, 7),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0),
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      child: ClipRect(
        child: IconButton(
          onPressed: () => print('${opcion.nombre} : ${opcion.idOpcAct}'),
          icon: Column(
            children: [
              const Icon(
                Icons.home,
                size: 25.0,
              ),
              Text(
                opcion.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

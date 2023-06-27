import 'dart:convert';

import 'package:ejemplocodec/src/Presentation/Pages/Homepage/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Preguntas extends StatefulWidget {
  @override
  _PreguntasPageState createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<Preguntas> {
  List<Pregunta> preguntas = [];
  late int preguntaActual = 0;
  late String jsonString;
  late int preguntasContestadas = 0;
  late int preguntasFaltantes = 0;

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  void cargarPreguntas() async {
    var url = 'https://awvm.000webhostapp.com/Beacons/cuestionario.php';

    try {
      var response = await http.get(Uri.parse(url));

      //if (response.statusCode) {
      List<dynamic> jsonPreguntas = jsonDecode(response.body);
      List<Pregunta> preguntas = [];

      jsonPreguntas.forEach((jsonPregunta) {
        Pregunta pregunta = Pregunta.fromJson(jsonPregunta);
        preguntas.add(pregunta);
      });

      setState(() {
        this.preguntas = preguntas;
      });
      //} else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      //}
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }

  void responderPregunta(String respuesta) {
    setState(() {
      preguntas[preguntaActual].respuestaSeleccionada = respuesta;
      preguntasContestadas = preguntas
          .where((pregunta) => pregunta.respuestaSeleccionada != null)
          .length;
      preguntasFaltantes = preguntas.length - preguntasContestadas;
      if (preguntaActual < preguntas.length - 1) {
        preguntaActual++;
      }
    });
  }

/*
  void responderPregunta(String respuesta, String string) {
    setState(() {
      preguntas[preguntaActual].respuestaSeleccionada = respuesta;
      if (preguntaActual < preguntas.length - 1) {
        preguntaActual++;
      }
    });
  }
*/
  Future<void> enviarRespuestas() async {
    List<Map<String, dynamic>> respuestas = preguntas.map((pregunta) {
      return {
        'id': pregunta.id,
        'respuesta': pregunta.respuestaSeleccionada,
      };
    }).toList();

    String respuestasString =
        respuestas.map((pregunta) => pregunta['respuesta']).join(',');

    String url =
        'https://awvm.000webhostapp.com/Beacons/quest.php'; // Reemplaza con la URL correcta
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({
      'quest_type': 1,
      'user_id': 3,
      'quest': 'preguntas',
      'answers': respuestasString,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // Respuestas enviadas exitosamente
        print('Respuestas enviadas correctamente');
        print('Respuesta del servidor: ${response.body}');
      } else {
        // Error al enviar las respuestas
        print('Error al enviar las respuestas');
      }
    } catch (e) {
      // Error de conexión
      print('Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Preguntas:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text('Preguntas contestadas: $preguntasContestadas'),
              Text('Preguntas faltantes: $preguntasFaltantes'),
              Text('Respuestas enviadas: $preguntaActual'),
              if (preguntas.isNotEmpty && preguntaActual < preguntas.length)
                Column(
                  children: [
                    ListTile(
                      title: Text(preguntas[preguntaActual].pregunta),
                      subtitle: Column(
                        children:
                            preguntas[preguntaActual].opciones.map((opcion) {
                          return RadioListTile(
                            title: Text(opcion),
                            value: opcion,
                            groupValue:
                                preguntas[preguntaActual].respuestaSeleccionada,
                            onChanged: (value) {
                              responderPregunta(value.toString());
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Anterior'),
                          onPressed: () {
                            setState(() {
                              if (preguntaActual > 0) {
                                preguntaActual--;
                              }
                            });
                          },
                        ),
                        ElevatedButton(
                          child: Text('Siguiente'),
                          onPressed: () {
                            setState(() {
                              if (preguntaActual < preguntas.length - 1) {
                                preguntaActual++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              if (preguntaActual + 1 == preguntas.length)
                ElevatedButton(
                  child: Text('Enviar respuestas'),
                  onPressed: () {
                    enviarRespuestas();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pregunta {
  String id;
  String pregunta;
  List<String> opciones;
  String respuestaSeleccionada;

  Pregunta({
    required this.id,
    required this.pregunta,
    required this.opciones,
    required this.respuestaSeleccionada,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id: json['id'],
      pregunta: json['pregunta'],
      opciones: List<String>.from(json['opciones']),
      respuestaSeleccionada: '',
    );
  }
}

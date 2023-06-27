import 'package:ejemplocodec/src/Presentation/Pages/Preguntas/Preguntas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/AppLocalizations.dart';
import '../Homepage/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Sensores/sensores.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routerName = 'Login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<String> idiomasAdmitidos = ['Español', 'Inglés', 'Alemán', 'Portugués'];

  late String _idiomaSeleccionado = idiomasAdmitidos[
      0]; // Establece el primer idioma como el idioma seleccionado por defecto
  String _errorMessage = '';

  void _cambiarIdioma(String idioma) {
    setState(() {
      _idiomaSeleccionado = idioma;
      // _AppLocalizationsDelegate.load(Locale(idioma)); // Carga las traducciones para el nuevo idioma
    });
  }

  void _validateFields() async {
    String username = _userController.text.trim();
    String password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa el usuario y la contraseña.';
      });
      return;
    }
    String url = 'https://awvm.000webhostapp.com/Beacons/login.php';
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map<String, String> body = {'nombre': username, 'contraseña': password};

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          _errorMessage = '';
        });
        print(data['id_users']);
        print(data['username']);
        print(data['role']);
        // Obtener una instancia de SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
// Guardar el dato en SharedPreferences
        String idUsers = data['id_users'];
        await prefs.setString('idUsers', idUsers);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Preguntas(),
          ),
        );

        // Aquí puedes realizar la navegación a la siguiente pantalla
      } else {
        setState(() {
          _errorMessage =
              'Credenciales inválidas. Por favor, intenta de nuevo.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Error en la solicitud HTTP: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Mi Aplicación'),
      ),*/
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80),
                const Text(
                  'Nombre Aplicación',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset(
                    'assets/logos/descarga.png', // Reemplaza 'assets/logo.png' con la ruta de tu logotipo de imagen
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'usuario@xyz.com',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Cntr4s3&a',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Iniciar sesión'),
                  onPressed: _validateFields,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descripción de la app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                DropdownButton<String>(
                  value: _idiomaSeleccionado,
                  items: idiomasAdmitidos.map((idioma) {
                    return DropdownMenuItem<String>(
                      value: idioma,
                      child: Text(idioma),
                    );
                  }).toList(),
                  onChanged: (nuevoIdioma) {
                    _cambiarIdioma(nuevoIdioma!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

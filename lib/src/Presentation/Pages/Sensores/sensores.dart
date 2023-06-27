import 'dart:convert';
import 'dart:math';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:ejemplocodec/src/Data/models.dart';
import 'package:ejemplocodec/src/Presentation/Pages/Sensores/detail.dart';
import 'package:ejemplocodec/src/Presentation/Pages/View/Notifier/Busqueda.dart';
import 'package:ejemplocodec/src/Providers/BeaconsProvider.dart';
//import 'package:ejemplocodec/src/PuenteBeaconsTools/PuenteBeacons.dart';
import 'package:ejemplocodec/src/PuenteBeaconsTools/model/AppStateModel.dart';
import 'package:ejemplocodec/src/Ui/Widgets/appbar.dart';
import 'package:ejemplocodec/src/Ui/Widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart' show BluetoothState;
import 'dart:async';
import 'dart:io' show Platform;
//import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/beacons_models.dart';
import 'package:http/http.dart' as http;

class Sensores extends StatefulWidget {
  const Sensores({super.key});
  static const String routerName = 'Sensores';
  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isPressed = false;
  bool isLoading = false;
  final String _tag = "Beacons Plugin";
  String _beaconResult = 'Not Scanned Yet.';
  String beacondistance = 'Distancia no optima';
  String comparadorname = " ";
  int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<String> _results = [];
  bool _isInForeground = true;
  final controller = Get.find<RequirementStateController>();
  StreamSubscription<BluetoothState>? _streamBluetooth;

  final ScrollController _scrollController = ScrollController();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppStateModel appStateModel = AppStateModel.instance;
    appStateModel.init();
    controller.startStream.listen((flag) {
      if (flag == true) {
        checkAllRequirements();
        initPlatformState();
      }
    });

    controller.pauseStream.listen((flag) {
      if (flag == true) {
        print("Nose puede");
      }
    });

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS =
        const DarwinInitializationSettings(onDidReceiveLocalNotification: null);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      print(
          'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
          'locationServiceEnabled=${controller.locationServiceEnabled}, '
          'bluetoothEnabled=${controller.bluetoothEnabled}');
    }
    if (Platform.isAndroid) {
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Background Locations",
          message:
              "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");
    }
    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        //print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          //_showNotification("Beacons monitoring started..");
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        } else if (call.method == 'isPermissionDialogShown') {
          _showNotification(
              "Prominent disclosure message is shown to the user!");
        }
      });
    } else if (Platform.isIOS) {
      // _showNotification("Beacons monitoring started..");
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");
    await BeaconsPlugin.addRegion(
        "Aruba", "4152554e-f99b-4a3b-86d0-947070693a78");
    await BeaconsPlugin.addRegion(
        "Cubeacon", "CB10023F-A318-3394-4199-A8730C7C1AEC");
    await BeaconsPlugin.addRegion(
        "AppleAirlocate", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0");
    await BeaconsPlugin.addRegion(
        "Kalops", "f7826da6-4fa2-4e98-8024-bc5b71e0893e");
    await BeaconsPlugin.addRegion(
        "RadBeaconDot", "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 5000, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 5000, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen((data) {
      if (data.isNotEmpty && isRunning) {
        setState(() {
          _beaconResult = data;
          Beacon0 beacon = beaconFromJson(data);
          //nuevo dispositivo
          _nrMessagesReceived++;
          _results.add(beacon.macAddress + "\n" + beacon.proximity);
          // Obtener una instancia de SharedPreferences
          //SharedPreferences prefs = await SharedPreferences.getInstance();
          //String savedIdUsers = prefs.getString('idUsers')!;
          //subir2(beacon, savedIdUsers);
          _nrMessagesReceived++;
        });
        Beacon0 beacon = beaconFromJson(data);
        if (!_isInForeground) {
          _showNotification('Beacon Encontrado: ${beacon.macAddress}');
        }
        print("Beacons DataReceived Example: $data");
      }
    }, onDone: () {
      print("buenas aqui imprimimos");
    }, onError: (error) {
      print("Error: $error");
    });
    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);
    if (!mounted) return;
  }

  checkAllRequirements() async {
    isLoading = true;
  }

  @override
  void dispose() {
    beaconEventsController.close();
    BeaconsPlugin.stopMonitoring();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(),
      drawer: const SideMenu(),
      body: isLoading
          ? const Center(
              child: IconButton(
                icon: SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Color.fromARGB(255, 255, 0, 0)),
                  ),
                ),
                onPressed: null,
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total de beacon: $_nrMessagesReceived',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF22369C),
                              fontWeight: FontWeight.bold,
                            )),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isRunning) {
                          await BeaconsPlugin.stopMonitoring();
                        } else {
                          initPlatformState();
                          await BeaconsPlugin.startMonitoring();
                        }
                        setState(() {
                          isRunning = !isRunning;
                        });
                      },
                      child: Text(isRunning ? 'Alto escaneo' : 'Inicio escaneo',
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  Visibility(
                    visible: _results.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _nrMessagesReceived = 0;
                            _results.clear();
                          });
                        },
                        child: const Text("Limpiar resultados",
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(child: _buildResultsList())
                ],
              ),
            ),
    );
  }

  void _showNotification(String subtitle) {
    var rng = Random();
    Future.delayed(const Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), _tag, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Widget _buildResultsList() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: _results.length,
        itemBuilder: (context, index) {
          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('dd-MM-yyyy – kk:mm:ss').format(now);
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  data: _results[index].toString(),
                  id: _results[index].length,
                ),
              ),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fecha y hora: $formattedDate",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1B26),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        _results[index],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1B26),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

bool subir(Beacon0 beacon) {
  double distancia = double.parse(beacon.distance);
  bool validar = false;
  if (distancia <= 0.5) {
    validar = true;
  }
  return validar;
}

Future<void> subir2(Beacon0 beacon, String savedIdUsers) async {
  // Realiza la lógica para subir el resultado del beacon a un archivo PHP
  // Utiliza los datos del beacon para formar el cuerpo de la solicitud HTTP
  String url = 'https://awvm.000webhostapp.com/Beacons/BeaconActual.php';
  String url2 = '';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {
    'uuid': beacon.uuid,
    'rssi': beacon.rssi,
    'major': beacon.major,
    'minor': beacon.minor,
    'id': beacon.id,
    'user_id': savedIdUsers
  };

  var response =
      await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // Realiza cualquier lógica adicional necesaria
  } else {
    print('Error al subir el resultado del beacon: ${response.statusCode}');
  }
}

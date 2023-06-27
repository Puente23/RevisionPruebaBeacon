import 'dart:async';
import 'package:ejemplocodec/src/Data/preferences.dart';
import 'package:ejemplocodec/src/Presentation/Pages/Configuraciones/conf.dart';
import 'package:ejemplocodec/src/Presentation/Pages/Login/Login.dart';
import 'package:ejemplocodec/src/Presentation/Pages/Sensores/sensores.dart';
import 'package:ejemplocodec/src/Presentation/Pages/View/Notifier/Busqueda.dart';
import 'package:ejemplocodec/src/Providers/DataProvider.dart';
import 'package:ejemplocodec/src/Providers/themeProvider.dart';
import 'package:ejemplocodec/src/Utils/AppLocalizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:ejemplocodec/src/Presentation/Pages/Homepage/home.dart';
import 'package:ejemplocodec/src/Presentation/Pages/View/BlueScreen/blue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ejemplocodec/widgets.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  flutterLocalNotificationsPlugin;
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode)),
        //ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode)),
      ],
      child: const FlutterBlueApp(),
    ),
  );
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RequirementStateController());
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      routes: {
        LoginPage.routerName: (_) => const LoginPage(),
        Conf.routerName: (_) => const Conf(),
        Sensores.routerName: (_) => const Sensores(),
        Home.routerName: (_) => const Home()
      },
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const LoginPage();
            }
            return BluetoothOffScreen(state: state);
          }),
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
//Función para verificar el estado del Bluetooth
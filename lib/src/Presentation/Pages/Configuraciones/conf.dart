import 'package:ejemplocodec/src/Data/preferences.dart';
import 'package:ejemplocodec/src/Providers/themeProvider.dart';
import 'package:ejemplocodec/src/Ui/Widgets/Botones.dart';
import 'package:ejemplocodec/src/Ui/Widgets/appbar.dart';
import 'package:ejemplocodec/src/Ui/Widgets/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Conf extends StatefulWidget {
  const Conf({Key? key}) : super(key: key);
  static const String routerName = 'Conf';

  @override
  State<Conf> createState() => _ConfState();
}

class _ConfState extends State<Conf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bar(),
      drawer: const SideMenu(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Ajustes',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300)),
              const Divider(),
              SwitchListTile.adaptive(
                  value: Preferences.isDarkmode,
                  title: const Text('Modo Oscuro'),
                  onChanged: (value) {
                    Preferences.isDarkmode = value;
                    final themeProvider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    value
                        ? themeProvider.setDarkmode()
                        : themeProvider.setLightMode();

                    setState(() {});
                  }),
            ]),
          )),
      //bottomNavigationBar: const Bto()
    );
  }
}

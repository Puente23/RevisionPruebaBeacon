import 'package:ejemplocodec/src/Presentation/Pages/Configuraciones/conf.dart';
import 'package:ejemplocodec/src/Presentation/Pages/screens.dart';
import 'package:flutter/material.dart'
    show
        AssetImage,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Container,
        DecorationImage,
        Drawer,
        DrawerHeader,
        EdgeInsets,
        Icon,
        Icons,
        Key,
        ListTile,
        ListView,
        Navigator,
        StatelessWidget,
        Text,
        Widget;
import 'package:ejemplocodec/src/Presentation/pages/screens.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.pages_outlined),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacementNamed(context, Home.routerName);
            },
          ),
          /*    ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Sensores'),
            onTap: () {
              Navigator.pushNamed(context, Sensores.routerName);
            },
          ),*/
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pushReplacementNamed(context, Conf.routerName);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/logos/descarga.png'),
              fit: BoxFit.cover)),
      child: Container(),
    );
  }
}

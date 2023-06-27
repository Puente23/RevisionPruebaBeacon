import 'package:flutter/material.dart';

class Bto extends StatefulWidget {
  const Bto({super.key});
  @override
  State<Bto> createState() => _Bto();
}

class _Bto extends State<Bto> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Identificador',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Informacion',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuraciones',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}

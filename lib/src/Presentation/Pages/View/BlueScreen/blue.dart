import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, required BluetoothState? state})
      : stat = state,
        super(key: key);

  final BluetoothState? stat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth esta ${stat?.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ejemplocodec/src/Providers/BeaconsProvider.dart';
import 'package:ejemplocodec/src/models/beacons_models.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String data;
  final int id;

  const DetailScreen({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dbHelper = BeaconDbHelper.instance;
  late String _data;
  late int _id;

  @override
  void initState() {
    super.initState();
    //_dbHelper.database;
    _data = widget.data;
    _id = widget.id;
    // _loadData();
  }

  @override
  void dispose() {
    // Limpiar controladores de texto
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadData() async {
    // Cargar datos de la base de datos y actualizar los controladores de texto
    final beacon = await _dbHelper.read(widget.id);
    setState(() {
      _titleController.text = beacon.uuid;
      _descriptionController.text = beacon.rssi.toString();
    });
  }

  void _saveData() async {
    final beacon = Beacon(
        uuid: widget.id.toString(),
        id: _titleController.text,
        ubicacion: _descriptionController.text,
        accuracy: 0.0,
        major: 0,
        minor: 0,
        rssi: 0.0);
    if (widget.id == null) {
      // Insertar un nuevo registro en la base de datos
      await _dbHelper.insert(beacon);
    } else {
      // Actualizar un registro existente en la base de datos
      await _dbHelper.update(beacon);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirme para editar"),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
// this will prevent the soft keyboard from covering the text fields
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20, child: Text(_data)),
              SizedBox(
                height: 20,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Ubicacion'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: TextField(
                  controller: _descriptionController,
                  enableInteractiveSelection: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: const InputDecoration(hintText: 'Mac Address'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  String newText = _data;
                  final updatedText = _descriptionController.text + newText;
                  _descriptionController.value =
                      _descriptionController.value.copyWith(
                    text: updatedText,
                    selection:
                        TextSelection.collapsed(offset: updatedText.length),
                  );
                },
                child: const Text("Es mi dispositivo"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String location = _titleController.text;
                  String macAddress = _descriptionController.text;
                  if (location.isNotEmpty && macAddress.isNotEmpty) {
                    Beacon beacon = Beacon(
                        uuid: "test",
                        major: 1,
                        minor: 1,
                        rssi: 1,
                        accuracy: 0.0,
                        id: '');
                    await BeaconDbHelper.instance.insert(beacon);
                  }
                },
                child: const Text("Subir beacon"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Ubicacion(),
                  //   ),
                  // );
                },
                child: const Text("Asignar Ubicacion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

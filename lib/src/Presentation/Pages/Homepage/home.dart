import 'package:ejemplocodec/src/Presentation/InputDecorations/butones.dart';
import 'package:ejemplocodec/src/Presentation/Pages/Preguntas/Preguntas.dart';
import 'package:ejemplocodec/src/Presentation/Pages/screens.dart';
import 'package:ejemplocodec/src/Providers/DataProvider.dart';
import 'package:ejemplocodec/src/Ui/Widgets/Botones.dart';
import 'package:ejemplocodec/src/Ui/Widgets/appbar.dart';
import 'package:ejemplocodec/src/Ui/Widgets/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ejemplocodec/src/Presentation/InputDecorations/butones.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routerName = 'Home';
  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    final TextEditingController _descriptionController =
        TextEditingController();
    List<Widget> children = [];
    List<Widget> children2 = [];
    List<Widget> children3 = [];
    for (var e in infoData.listOpciones) {
      if (e.estado) {
        children.add(BotonCircularOpc(opcion: e));
      }
    }

    for (var e in infoData.listOpcionesSec) {
      if (e.estado) {
        children2.add(BotonCircularOpcSec(opcion: e));
      }
    }

    for (var e in infoData.listActividades) {
      if (e.estado) {
        children3.add(BotonCircularAct(opcion: e));
      }
    }

    Widget myWidget = SizedBox(
      width: double.infinity,
      height: 110,
      //color: Colors.red,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.all(15.0),
          shrinkWrap: true,
          children: children),
    );

    Widget myWidget2 = SizedBox(
      width: double.infinity,
      height: 110,
      //color: Colors.green,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.all(15.0),
          shrinkWrap: true,
          children: children2),
    );

    List<Step> getStep() {
      return <Step>[
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text("UBICACIÓN"),
          content: Column(
            children: [myWidget],
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text("ZONA"),
          content: Column(
            children: [myWidget2],
          ),
        ),
        Step(
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text("ACTIVIDAD"),
          content: SizedBox(
            width: double.infinity,
            height: 500,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: children3,
            ),
          ),
        ),
      ];
    }

    Widget controlBuilders(context, details) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: _currentStep != 0,
              child: OutlinedButton.icon(
                onPressed: details.onStepCancel,
                label: const Text('Cancelar'),
                icon: const Icon(Icons.cancel),
                // la: Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                if (_currentStep == 2) {
                  // Realizar acción para finalizar y navegar a otra actividad
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Preguntas(),
                    ),
                  );
                } else {
                  // Realizar acción para continuar
                  details.onStepContinue();
                }
              },
              label: (_currentStep == 2)
                  ? const Text('Finalizar')
                  : const Text('Continuar'),
              icon: const Icon(Icons.check_circle),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: const Bar(),
        drawer: const SideMenu(),
        body: Stepper(
          controlsBuilder: controlBuilders,
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepCancel: () => _currentStep == 0
              ? null
              : setState(() {
                  _currentStep -= 1;
                }),
          onStepContinue: () {
            bool isLastStep = (_currentStep == getStep().length - 1);
            if (isLastStep) {
              //Do something with this information
            } else {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepTapped: (step) => setState(() {
            _currentStep = step;
          }),
          steps: getStep(),
        ));
  }
}

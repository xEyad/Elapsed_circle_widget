import 'package:circle_elapsed_widget/elapsedCircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color initialColor = Colors.yellow;
  Color secondColor = Colors.black;
  Color lateColor = Colors.purple;
  double selectedDiamterValue = 50;
  double selectedOuterRadiusValue = 5;
  final ctrl = ElapsedCircleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              _controls(),
              Spacer(),
              ElapsedCircle(
                controller: ctrl,
                initialColor: initialColor,
                secondColor: secondColor,
                lateColor: lateColor,
                expectedSeconds: 5,
              ),
              SizedBox(height: 100,),
              Spacer(),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            
          });
        },
        tooltip: 'Change colors',
        child: const Icon(Icons.restore),
      ),
    );
  }
  Widget _controls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text("Set your parameters"),

          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(
                child: _parameter(
                    label: "Diameter (${selectedDiamterValue.round()})",
                    input: Slider(
                      value: selectedDiamterValue,
                      max: 200,
                      divisions: 200 ~/ 5,
                      label: selectedDiamterValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          selectedDiamterValue = value;
                        });
                      },
                    )),
              ),
              Expanded(
                child: _parameter(
                    label:
                        "Outer bound radius (${selectedOuterRadiusValue.round()})",
                    input: Slider(
                      value: selectedOuterRadiusValue,
                      max: 200,
                      divisions: 200 ~/ 5,
                      label: selectedOuterRadiusValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          selectedOuterRadiusValue = value;
                        });
                      },
                    )),
              ),
            ],
          ),

          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(
                  child: _colorPickerField(
                      label: "Initial color",
                      onColorChanged: (Color clr) {
                        setState(() {
                          initialColor = clr;
                        });
                      },
                      value: initialColor)),
              Expanded(
                  child: _colorPickerField(
                      label: "Second color",
                      onColorChanged: (Color clr) {
                        setState(() {
                          secondColor = clr;
                        });
                      },
                      value: secondColor)),
              Expanded(
                  child: _colorPickerField(
                      label: "late color",
                      onColorChanged: (Color clr) {
                        setState(() {
                          lateColor = clr;
                        });
                      },
                      value: lateColor)),
            ],
          ),

          SizedBox(height: 20,),

          RaisedButton(onPressed: (){
            ctrl.updateParameters(
                initialColor: initialColor,
                secondColor: secondColor,
                lateColor: lateColor,
                outerBoundsRadius: selectedOuterRadiusValue,
                diameter: selectedDiamterValue);
          },
          color: Colors.blue,
          child: Text("Apply parameters",style: TextStyle(color: Colors.white),),
          )

        ],
      ),
    );
  }

  Widget _colorPickerField(
      {required String label,
      required Color value,
      required Function(Color) onColorChanged}) {
    return _parameter(
      label: label,
      input: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (c) {
                return Dialog(
                  child: IntrinsicHeight(
                    child: HueRingPicker(
                        pickerColor: value,
                        enableAlpha: true,
                        displayThumbColor: true,
                        onColorChanged: onColorChanged),
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: value,
          ),
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  Widget _parameter({required String label, required Widget input}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text(label),SizedBox(height: 10,), input],
    );
  }
}

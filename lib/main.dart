import 'package:circle_elapsed_widget/elapsedCircle.dart';
import 'package:flutter/material.dart';
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
class _MyHomePageState extends State<MyHomePage> 
{
  Color initialColor = Colors.yellow;
  Color secondColor = Colors.black;
  Color lateColor = Colors.purple;
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
          children: 
        [
          Text('''Current settings:
          expectedSeconds: 5
          Colors in order: [yellow,black,purple]
          New colors in order: [green,orange,red]
          '''),
          SizedBox(height: 10,),
          ElapsedCircle(
            controller: ctrl,
            initialColor: initialColor,secondColor: secondColor,lateColor: lateColor,expectedSeconds: 5,),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {            
            ctrl.updateParameters(
              initialColor: Colors.green,
              secondColor: Colors.orange,
              lateColor: Colors.red,
            );
          });
        },
        tooltip: 'change colors',
        child: const Icon(Icons.restore),
      ), 
    );
  }
}

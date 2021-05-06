import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/services.dart';

class Arview extends StatefulWidget {
  Arview({Key? key}) : super(key: key);

  @override
  _ArviewState createState() => _ArviewState();
}

class _ArviewState extends State<Arview> {
  late ArCoreController arCoreController;
  late ArCoreNode earth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Earth And Moon'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enablePlaneRenderer: true,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => print("this is " + name);
    _addEarth(arCoreController);
  }

  void _addEarth(ArCoreController controller) async {
    var d = await rootBundle.load('assets/earth.jpg');
    var bytes = d.buffer.asUint8List();

    final moonMaterial = ArCoreMaterial(color: Colors.grey);

    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    final earthMaterial = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      textureBytes: bytes,
    );

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    earth = ArCoreNode(
      shape: earthShape,
      children: [moon],
      name: "earth",
      position: vector.Vector3(0.0, -.4, -1),
      rotation: vector.Vector4(0, 0, 0, 0),
    );
    controller.addArCoreNode(earth);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AR extends StatefulWidget {
  @override
  _AR createState() => _AR();
}

class _AR extends State<AR> {
  ARKitController? arkitController;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    arkitController?.dispose();
    super.dispose();
  }

  void onARKitViewCreated(ARKitController arkitController) {

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty(image: 'https://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg'),
    );
    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: vector.Vector3(0, 0, -0.5),
      eulerAngles: vector.Vector3.zero(),
    );
    arkitController.add(node);

    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      rotation.x += 0.01;
      node.eulerAngles = rotation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ARKit in Flutter')),
        body: Container(
          child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: onARKitViewCreated,
          ),
        ),
    );
  }
}

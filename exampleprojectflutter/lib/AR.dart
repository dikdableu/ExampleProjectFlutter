import 'package:flutter/material.dart';
import 'dart:async';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math.dart';

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
    this.arkitController = arkitController;

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty(image: 'earth.jpg'),
    );
    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: Vector3(0, 0, -0.5),
      eulerAngles: Vector3.zero(),
    );
    this.arkitController.add(node);

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
        body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated));
  }
}

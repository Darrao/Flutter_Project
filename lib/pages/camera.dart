import 'dart:convert'; // Import pour base64Encode
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // Ajout de l'importation pour Uint8List
import 'dart:io' as io; // Ajout pour l'utilisation de File pour les plateformes non web

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(String?, Uint8List?) onPictureTaken;

  const CameraPage({
    super.key,
    required this.cameras,
    required this.onPictureTaken,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (kIsWeb) {
        final byteData = await image.readAsBytes();
        final bytes = Uint8List.fromList(byteData);
        widget.onPictureTaken(null, bytes);
      } else {
        final imagePath = image.path;
        widget.onPictureTaken(imagePath, null);
      }
    } catch (e) {
      print('Erreur lors de la prise de photo : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 2),
              ),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FilledButton(
                onPressed: _takePicture,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink),
                ),
                child: const Text('Take Pic'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
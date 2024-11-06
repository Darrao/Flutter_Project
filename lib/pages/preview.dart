import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key, required this.url, required this.bytes});

  final String? url;
  final Uint8List? bytes;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  TextEditingController captionController = TextEditingController();
  String location = "Unknown";

  Future<void> _postPic() async {
    String caption = captionController.text;

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> post = {
      "id": id,
      "url": "",
      "base64": "",
      "caption": caption,
      "date": DateTime.now().toString(),
      "location": location,
      "isFavorite": false,
    };

    String? url = widget.url;
    Uint8List? bytes = widget.bytes;

    if (kIsWeb && url != null) {
      final response = await http.readBytes(Uri.parse(url));
      if (response.isNotEmpty) {
        final base64Image = base64Encode(response);
        post["base64"] = base64Image;
      }
    } else {
      final directory = await getApplicationSupportDirectory();
      final newFilePath = '${directory.path}/posts/$id.jpg';
      if (url != null) {
        await File(url).copy(newFilePath);
        post["url"] = newFilePath;
      } else if (bytes != null) {
        final file = await File(newFilePath).create(recursive: true);
        file.writeAsBytesSync(bytes);
        post["url"] = newFilePath; // Assurez-vous de définir le chemin du fichier ici pour les images non web
      }
    }

    Navigator.of(context).pop(post); // Renvoie le nouveau post
  }

  Future<void> _addLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      location = "${position.latitude}, ${position.longitude}";
    });
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.pink)),
      body: Center(
        child: Column(children: [
          Text("Position: $location"),
          Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                fit: BoxFit.cover,
                image: widget.url == null
                    ? MemoryImage(widget.bytes ?? Uint8List(0))
                    : NetworkImage(widget.url ?? "") as ImageProvider,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 500,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: captionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.pink, width: 2),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: _addLocation,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.purple),
                    ),
                    child: const Text("Add location"),
                  ),
                  FilledButton(
                    onPressed: _postPic,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.pink),
                    ),
                    child: const Text("Post pic"),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
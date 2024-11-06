import 'package:flutter/material.dart';
import '../gallery_widgets/post_list.dart';
import './camera.dart';
import 'package:camera/camera.dart';
import 'preview.dart';
import 'dart:typed_data';

class GalleryPage extends StatefulWidget {
  final String name;
  final List<CameraDescription> cameras;

  const GalleryPage({
    super.key,
    required this.name,
    required this.cameras,
  });

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Map<String, dynamic>> _posts = [
    {
      "id": "1",
      "url":
      "https://images.unsplash.com/photo-1722151728302-399527ea42d7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzNHx8fGVufDB8fHx8fA%3D%3D",
      "caption": "Wow, super",
      "isFavorite": false,
    },
    {
      "id": "2",
      "url":
      "https://images.unsplash.com/photo-1721646120400-2411520f303a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzOHx8fGVufDB8fHx8fA%3D%3D",
      "caption": "Je viens d'acheter une voiture",
      "isFavorite": false,
    },
    {
      "id": "3",
      "url":
      "https://images.unsplash.com/photo-1722032259251-91cc9365b349?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1M3x8fGVufDB8fHx8fA%3D%3D",
      "caption": "Je suis riche",
      "isFavorite": false,
    },
  ];
  bool _isFiltered = false;

  void _toggleFavorite(String id) {
    setState(() {
      int indexId = _posts.indexWhere((item) => (item["id"] == id));
      if (indexId == -1) return;
      _posts[indexId]["isFavorite"] = !_posts[indexId]["isFavorite"];
    });
  }

  void _filterPosts() {
    setState(() {
      _isFiltered = !_isFiltered;
    });
  }

  void _openCamera() async {
    final newPost = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraPage(
          cameras: widget.cameras,
          onPictureTaken: (String? url, Uint8List? bytes) async {
            return await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PreviewPage(
                  url: url,
                  bytes: bytes,
                ),
              ),
            );
          },
        ),
      ),
    );

    if (newPost != null && newPost is Map<String, dynamic>) {
      setState(() {
        _posts.add(newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedPosts = _isFiltered
        ? _posts.where((item) => item["isFavorite"] as bool).toList()
        : _posts;
    displayedPosts.sort((a, b) => b["id"].compareTo(a["id"]));
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Hello ${widget.name}",
                style: const TextStyle(color: Colors.pink, fontSize: 45),
              ),
            ),
            PostList(
              posts: displayedPosts,
              toggleFavorite: (int id) => _toggleFavorite(id.toString()),
            ),
            FilledButton(
              onPressed: _filterPosts,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.pink),
              ),
              child: Text(_isFiltered ? "Show All" : "Show Favorites"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: _openCamera,
        tooltip: 'Take pic',
        child: const Icon(Icons.photo_camera, color: Colors.white),
      ),
    );
  }
}
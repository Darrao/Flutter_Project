import 'package:flutter/material.dart';
import 'dart:io'; // Import pour File

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.url,
    required this.caption,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  final String url;
  final String caption;
  final bool isFavorite;
  final VoidCallback toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: url.startsWith('http')
                    ? Image(
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  image: NetworkImage(url),
                )
                    : Image.file(
                  File(url),
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(caption),
              ),
              ElevatedButton(
                  onPressed: toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.pink,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
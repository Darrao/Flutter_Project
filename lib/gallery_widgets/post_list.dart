import 'package:flutter/material.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  const PostList({super.key, required this.posts, required this.toggleFavorite});

  final List<Map> posts;
  final Function(int) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                url: posts[index]["url"],
                caption: posts[index]["caption"],
                isFavorite: posts[index]["isFavorite"],
                toggleFavorite: () => toggleFavorite(posts[index]["id"]),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
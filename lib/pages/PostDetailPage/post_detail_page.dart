import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String? photoUrl;
  const PostDetailPage({Key? key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius:BorderRadius.circular(16),
            child: Image.network(photoUrl!)),
      ),
    );
  }
}

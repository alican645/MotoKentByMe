import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hata!'),
      ),
      body: const Center(
        child: Text(
          'Bir hata meydana geldi.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
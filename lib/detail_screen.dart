import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String payload;

  const DetailScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder Detail')),
      body: Center(
        child: Text(
          'Reminder: $payload',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

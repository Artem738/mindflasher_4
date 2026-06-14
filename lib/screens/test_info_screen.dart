import 'package:flutter/material.dart';

class TestInfoScreen extends StatelessWidget {
  const TestInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Info'),
      ),
      body: const Center(
        child: Text(
          'Пyтин Xуйло !!!',
          style: TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
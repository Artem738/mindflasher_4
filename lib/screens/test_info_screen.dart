import 'package:flutter/material.dart';

class TestInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Info'),
      ),
      body: Center(
        child: Text(
          'Пyтин Xуйло !!!',
          style: TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
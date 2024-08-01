import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${authProvider.user?.firstName ?? 'User'}!'),
            if (authProvider.user?.username != null)
              Text('Username: ${authProvider.user!.username}'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_user_control.dart';

class DeckListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<ProviderUserControl>().userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Deck List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, - ${userModel.firstname}, ${userModel.username}, ${userModel.email} \n token - ${userModel.token}',
              textAlign: TextAlign.center,
            ),
            Text('apiId ${userModel.apiId.toString()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final userControlProvider = context.read<ProviderUserControl>();
                userControlProvider.incrementApiId();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('apiId updated to ${userControlProvider.userModel.apiId}')),
                );
              },
              child: Text('Update apiId'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_user_login.dart';

class DeckListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<ProviderUserLogin>(context).userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Deck List'),
      ),
      body: Center(
        child: Text('Welcome,${userModel?.token},,${userModel?.firstname}, ${userModel?.username}'),
      ),
    );
  }
}


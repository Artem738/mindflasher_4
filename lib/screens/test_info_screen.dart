import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/util/snackbar_extension.dart';
import 'package:mindflasher_4/telegram/telegram_utils.dart';
import 'package:provider/provider.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

import 'package:mindflasher_4/main.dart'; // Импортируем файл с классом ProviderUserLogin

class TestInfoScreen extends StatelessWidget {
  final TelegramWebApp telegram = TelegramWebApp.instance;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProviderUserLogin>();
    final sharedPreferences = notifier.sharedPreferences;
    final user = context.read<ProviderUserLogin>().userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main App 2'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null) ...[
                Text('Logged in via Telegram'),
                Text('User ID: ${user.tgId}'),
                Text('First Name: ${user.firstname}'),
                SelectableText('initData: ${telegram.initData.toString()}'),
                SelectableText('initDataUnsafe: ${telegram.initDataUnsafe?.toReadableString() ?? 'null'}'),
                if (user.lastname != null) Text('Last Name: ${user.lastname}'),
                if (user.username != null) Text('Username: ${user.username}'),
                if (user.languageCode != null) Text('Language Code: ${user.languageCode}'),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () => TelegramUtil.showAlert(context, 'Sample Alert'),
                  child: Text('Show Alert'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () => TelegramUtil.showConfirm(context, 'Sample Confirm'),
                  child: Text('Show Confirm'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () => TelegramUtil.showScanQrPopup(context, 'Scan QR Code'),
                  child: Text('Scan QR Code'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () => TelegramUtil.readTextFromClipboard(context),
                  child: Text('Read Clipboard'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    'Snackbar message'.showSnackbar(context);
                  },
                  child: Text('Show Snackbar'),
                ),
              ] else
                Text('Simple login'),
              Text('SharedPreferences is ready: ${sharedPreferences != null}'),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  'Snackbar message'.showSnackbar(context);
                },
                child: Text('Show Snackbar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mindflasher_4/providers/provider_user_login.dart';
// import 'package:mindflasher_4/screens/util/snackbar_extension.dart';
// import 'package:mindflasher_4/telegram/telegram_utils.dart';
// import 'package:provider/provider.dart';
//
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:mindflasher_4/providers/devise_special_load/telegram_web_app_stub.dart' // Импортируется заглушка для Классов
// if (dart.library.html) 'package:mindflasher_4/providers/devise_special_load/telegram_web_app_web.dart';
//
// import 'package:mindflasher_4/main.dart';
//
// class TgTestInfoScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.watch<ProviderUserLogin>();
//     print ("WTF !!!");
//   print (notifier.isTelegramFeatureWorks);
//
//     if (kIsWeb && notifier.isTelegramFeatureWorks) {
//       print ("WEB !!!");
//       // Если функция Telegram работает, отображаем основной экран
//       final sharedPreferences = notifier.sharedPreferences;
//       final user = context.read<ProviderUserLogin>().userModel;
// //      final TelegramWebApp telegram = TelegramWebApp.instance;
//
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Main App 2'),
//         ),
//         body: Center(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (user != null) ...[
//                   Text('Logged in via Telegram'),
//                   Text('User ID: ${user.telegram_id}'),
//                   Text('First Name: ${user.tg_first_name}'),
//              //     SelectableText('initData: ${telegram.initData.toString()}'),
//                  // SelectableText('initDataUnsafe: ${telegram.initDataUnsafe?.toReadableString() ?? 'null'}'),
//                   if (user.tg_last_name != null) Text('Last Name: ${user.tg_last_name}'),
//                   if (user.tg_username != null) Text('tg_username: ${user.tg_username}'),
//                   if (user.language_code != null) Text('Language Code: ${user.language_code}'),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                     ),
//                     onPressed: () => TelegramUtil.showAlert(context, 'Sample Alert'),
//                     child: Text('Show Alert'),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                     ),
//                     onPressed: () => TelegramUtil.showConfirm(context, 'Sample Confirm'),
//                     child: Text('Show Confirm'),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                     ),
//                     onPressed: () => TelegramUtil.showScanQrPopup(context, 'Scan QR Code'),
//                     child: Text('Scan QR Code'),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                     ),
//                     onPressed: () => TelegramUtil.readTextFromClipboard(context),
//                     child: Text('Read Clipboard'),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                     ),
//                     onPressed: () {
//                       'Snackbar message'.showSnackbar(context);
//                     },
//                     child: Text('Show Snackbar'),
//                   ),
//                 ] else
//                   Text('Simple login'),
//                 Text('SharedPreferences is ready: ${sharedPreferences != null}'),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.blue,
//                   ),
//                   onPressed: () {
//                     'Snackbar message'.showSnackbar(context);
//                   },
//                   child: Text('Show Snackbar'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     } else {
//       // Если функция Telegram не работает, отображаем альтернативный экран
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Telegram Feature Unavailable'),
//         ),
//         body: Center(
//           child: Text('Telegram feature is currently unavailable.'),
//         ),
//       );
//     }
//   }
// }

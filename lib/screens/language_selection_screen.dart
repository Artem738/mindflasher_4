import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/translates/language_selection_screen_translate.dart';

import '../main.dart';

enum Language {
  english('en', 'English'),
  ukrainian('uk', 'Українська'),
  russian('ru', 'Русский');

  final String code;
  final String name;

  const Language(this.code, this.name);

  static Language fromCode(String? code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.english, // Default language
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final userLang = userModel.language_code ?? userModel.tg_language_code ?? 'en';
    final txt = LanguageSelectionScreenTranslate(userLang);

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Language.values.map((language) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _setLanguage(context, language),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              language.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _setLanguage(BuildContext context, Language language) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final userControl = Provider.of<ProviderUserControl>(context, listen: false);
    final userLogin = Provider.of<ProviderUserLogin>(context, listen: false);

    await userLogin.saveLanguageCode(language.code);
    if (userModel.token != null) {
      await userControl.updateUserLanguageCode(language.code);
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const IndexScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

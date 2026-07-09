import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
// Добавлен новый экран
import 'package:mindflasher_4/translates/user_settings_screen_translate.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/provider_user_control.dart';
import '../providers/provider_user_login.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    final baseFontSize = userModel.base_font_size;
    final colorScheme = Theme.of(context).colorScheme;

    var txt = UserSettingsScreenTranslate(userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('user_settings_title')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          (userModel.tg_first_name ?? userModel.name ?? '?')[0]
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${txt.tt('welcome')} ${userModel.tg_first_name ?? userModel.name ?? ''}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: (baseFontSize + 4).clamp(18.0, 26.0),
                            ),
                      ),
                      Text(
                        userModel.email ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: baseFontSize.clamp(14.0, 20.0),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, txt.tt('account_info'), baseFontSize),
              Card(
                child: Column(
                  children: [
                    _buildInfoTile(context, txt.tt('api_id'), (userModel.apiId ?? '').toString(),
                        Icons.vpn_key_outlined, baseFontSize),
                    _buildInfoTile(
                        context,
                        txt.tt('telegram_id'),
                        (userModel.telegram_id ?? '').toString(),
                        Icons.alternate_email,
                        baseFontSize),
                    _buildInfoTile(context, txt.tt('user_level'),
                        (userModel.user_lvl ?? '').toString(), Icons.trending_up, baseFontSize),
                    _buildInfoTile(context, txt.tt('ai_credits'),
                        (userModel.ai_credits ?? 0).toString(), Icons.stars_outlined, baseFontSize),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, txt.tt('settings_section'), baseFontSize),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.brightness_6_outlined),
                      title: Text(txt.tt('dark_mode'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      value: userModel.themeMode == ThemeMode.dark,
                      onChanged: userModel.themeMode == ThemeMode.system
                          ? null
                          : (bool value) {
                              context.read<ProviderUserLogin>().saveThemeMode(
                                  value ? ThemeMode.dark : ThemeMode.light);
                            },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.settings_brightness_outlined),
                      title: Text(txt.tt('system_theme'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      value: userModel.themeMode == ThemeMode.system,
                      onChanged: (bool value) {
                        context.read<ProviderUserLogin>().saveThemeMode(
                            value ? ThemeMode.system : ThemeMode.light);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.swipe_vertical_outlined),
                      title: Text(txt.tt('auto_close_cards'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      value: userModel.auto_close_cards,
                      onChanged: (bool value) {
                        context.read<ProviderUserControl>().updateAutoCloseCards(value);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.format_size),
                      title: Text(txt.tt('adjust_font_size_button'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FontSizeAdjustmentScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(txt.tt('change_lang_button'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LanguageSelectionScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(txt.tt('instruction'),
                          style: TextStyle(
                              fontSize: baseFontSize.clamp(14.0, 20.0))),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FirstEnterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeckIndexScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.home_outlined),
                label: Text(
                  txt.tt('to_main'),
                  style: TextStyle(
                    fontSize: (baseFontSize + 2).clamp(16.0, 22.0),
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String title, double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: (baseFontSize - 2).clamp(12.0, 16.0),
            ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value,
      IconData icon, double baseFontSize) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label,
          style: TextStyle(fontSize: (baseFontSize - 1).clamp(13.0, 18.0))),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: baseFontSize.clamp(14.0, 19.0),
            ),
      ),
    );
  }
}

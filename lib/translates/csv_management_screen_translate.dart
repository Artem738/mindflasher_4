// csv_management_screen_translate.dart
class CsvManagementScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('csv_management_title')  ${txt.tt('csv_management_title')}
    'csv_management_title': {
      'en': 'CSV Management',
      'ru': 'Управление CSV',
      'uk': 'Управління CSV',
    },
    // txt.tt('enter_csv_data')  ${txt.tt('enter_csv_data')}
    'enter_csv_data': {
      'en': 'Enter CSV Data:',
      'ru': 'Введите данные CSV:',
      'uk': 'Введіть дані CSV:',
    },
    // txt.tt('csv_placeholder')  ${txt.tt('csv_placeholder')}
    'csv_placeholder': {
      'en': 'Paste your CSV data here...',
      'ru': 'Вставьте свои данные CSV сюда...',
      'uk': 'Вставте свої дані CSV сюди...',
    },
    // txt.tt('upload_csv_button')  ${txt.tt('upload_csv_button')}
    'upload_csv_button': {
      'en': 'Upload CSV',
      'ru': 'Загрузить CSV',
      'uk': 'Завантажити CSV',
    },
    // txt.tt('failed_csv_insert')  ${txt.tt('failed_csv_insert')}
    'failed_csv_insert': {
      'en': 'Failed to insert CSV data',
      'ru': 'Не удалось вставить данные CSV',
      'uk': 'Не вдалося вставити дані CSV',
    },
  };

  final String languageCode;

  CsvManagementScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}

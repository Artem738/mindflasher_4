class TtsVoices {
  // Map of language code to male/female voice IDs
  static const Map<String, Map<String, String>> _voicesByLang = {
    'en': {
      'female': 'en-US-Neural2-F',
      'male': 'en-US-Neural2-J',
    },
    'de': {
      'female': 'de-DE-Neural2-F',
      'male': 'de-DE-Neural2-B',
    },
    'fr': {
      'female': 'fr-FR-Neural2-A',
      'male': 'fr-FR-Neural2-B',
    },
    'es': {
      'female': 'es-ES-Neural2-A',
      'male': 'es-ES-Neural2-B',
    },
  };

  /// Gets the female voice ID for a given language code. Defaults to English.
  static String getFemaleVoice(String langCode) {
    return _voicesByLang[langCode]?['female'] ?? _voicesByLang['en']!['female']!;
  }

  /// Gets the male voice ID for a given language code. Defaults to English.
  static String getMaleVoice(String langCode) {
    return _voicesByLang[langCode]?['male'] ?? _voicesByLang['en']!['male']!;
  }
}

class VoiceLessonScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Hands-free Lesson',
      'ru': 'Голосовой урок',
      'uk': 'Голосовий урок',
    },
    'state_loading': {
      'en': 'Loading lesson...',
      'ru': 'Загрузка урока...',
      'uk': 'Завантаження уроку...',
    },
    'state_playing_question': {
      'en': 'Listening to the question...',
      'ru': 'Озвучивается вопрос...',
      'uk': 'Озвучується питання...',
    },
    'state_waiting_speech': {
      'en': 'Speak now...',
      'ru': 'Говорите...',
      'uk': 'Говоріть...',
    },
    'state_recording': {
      'en': 'Recording answer...',
      'ru': 'Запись ответа...',
      'uk': 'Запис відповіді...',
    },
    'state_uploading': {
      'en': 'Uploading...',
      'ru': 'Отправка...',
      'uk': 'Відправлення...',
    },
    'state_grading': {
      'en': 'Checking answer...',
      'ru': 'Проверка ответа...',
      'uk': 'Перевірка відповіді...',
    },
    'state_playing_feedback': {
      'en': 'Playing feedback...',
      'ru': 'Результат...',
      'uk': 'Результат...',
    },
    'feedback_green': {
      'en': 'Good, correct.',
      'ru': 'Отлично, правильно.',
      'uk': 'Добре, правильно.',
    },
    'feedback_yellow': {
      'en': 'Almost.',
      'ru': 'Почти правильно.',
      'uk': 'Майже правильно.',
    },
    'feedback_red': {
      'en': 'Incorrect.',
      'ru': 'Неправильно.',
      'uk': 'Неправильно.',
    },
    'feedback_timeout': {
      'en': 'I didn\'t hear you.',
      'ru': 'Я не расслышал.',
      'uk': 'Я не почув.',
    },
    'state_finished': {
      'en': 'Lesson finished!',
      'ru': 'Урок завершен!',
      'uk': 'Урок завершено!',
    },
    'error_mic_permission': {
      'en': 'Microphone permission denied.',
      'ru': 'Нет доступа к микрофону.',
      'uk': 'Немає доступу до мікрофона.',
    },
    'error_network': {
      'en': 'Network error. Check connection.',
      'ru': 'Ошибка сети. Проверьте подключение.',
      'uk': 'Помилка мережі. Перевірте з\'єднання.',
    },
    'pause_lesson': {
      'en': 'Pause',
      'ru': 'Пауза',
      'uk': 'Пауза',
    },
    'resume_lesson': {
      'en': 'Resume',
      'ru': 'Продолжить',
      'uk': 'Продовжити',
    },
    'close': {
      'en': 'Close',
      'ru': 'Закрыть',
      'uk': 'Закрити',
    },
    'dont_know': {
      'en': 'I don\'t know',
      'ru': 'Не знаю',
      'uk': 'Не знаю',
    },
    'sensitivity_title': {
      'en': 'Microphone Sensitivity',
      'ru': 'Чувствительность микрофона',
      'uk': 'Чутливість мікрофона',
    },
    'sensitivity_desc': {
      'en': 'Adjust if the app triggers too early from background noise, or fails to hear you.',
      'ru': 'Настройте, если приложение срабатывает на фоновый шум или не слышит вас.',
      'uk': 'Налаштуйте, якщо додаток реагує на фоновий шум або не чує вас.',
    },
    'sensitivity_quiet': {
      'en': 'Quiet env',
      'ru': 'В тишине',
      'uk': 'У тиші',
    },
    'sensitivity_noisy': {
      'en': 'Noisy env',
      'ru': 'Вокруг шумно',
      'uk': 'Навколо шумно',
    },
  };

  final String languageCode;

  VoiceLessonScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}

class FirstEnterScreenTranslate {
// var txt = FirstEnterScreenTranslate(context.read<UserModel>().language_code ?? 'en');
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('welcome')  ${txt.tt('welcome')}
    'welcome': {
      'en': 'Welcome!',
      'ru': 'Добро пожаловать!',
      'uk': 'Ласкаво просимо!',
    },

// txt.tt('leitner_method')  ${txt.tt('leitner_method')}
    'leitner_method': {
      'en':
          'The system operates based on the Leitner method, which uses spaced repetition to optimize the memorization process. This method is based on the principle that information is better retained in long-term memory if it is regularly repeated at increasing intervals.',
      'ru':
          'Система работает по методу Лейтнера, который использует интервальные повторения для оптимизации процесса запоминания. Этот метод основан на том, что информация лучше сохраняется в долгосрочной памяти, если регулярно повторять её с увеличивающимися интервалами.',
      'uk':
          'Система працює за методом Лейтнера, який використовує інтервальні повторення для оптимізації процесу запам\'ятовування. Цей метод заснований на тому, що інформація краще зберігається в довгостроковій пам\'яті, якщо регулярно повторювати її з наростаючими інтервалами.',
    },

// txt.tt('deck_instruction')  ${txt.tt('deck_instruction')}
    'deck_instruction': {
      'en':
          'When you enter a deck, you will see a list of questions. To view the answer, swipe the card to the left. If you know the answer for sure, press the green button.',
      'ru':
          'Когда вы заходите в колоду, вы увидите список вопросов. Чтобы увидеть ответ, отодвиньте карточку влево. Если вы точно знаете ответ, нажмите зеленую кнопку.',
      'uk':
          'Коли ви заходите в колоду, ви побачите список питань. Щоб побачити відповідь, посуньте картку вліво. Якщо ви точно знаєте відповідь, натисніть зелену кнопку.',
    },

// txt.tt('green_icon_explanation')  ${txt.tt('green_icon_explanation')}
    'green_icon_explanation': {
      'en':
          'The green icon means you know the answer well. The card will be moved 30 positions down the list and won\'t appear for a long time.',
      'ru':
          'Зеленая иконка означает, что вы хорошо знаете ответ. Карточка будет перемещена вниз списка на 30 позиций и долго не будет появляться.',
      'uk':
          'Зелена іконка означає, що ви добре знаєте відповідь. Картка буде переміщена вниз списку на 30 позицій і довго не з\'являтиметься.',
    },

// txt.tt('yellow_red_buttons')  ${txt.tt('yellow_red_buttons')}
    'yellow_red_buttons': {
      'en': 'If you swipe the card all the way, see the answer, and can choose between two buttons — yellow and red.',
      'ru': 'Если вы отодвинули карточку до конца, увидели ответ и можете выбрать между двумя кнопками — желтой и красной.',
      'uk': 'Якщо ви посунули картку до кінця, побачили відповідь і можете вибрати між двома кнопками — жовтою та червоною.',
    },

// txt.tt('yellow_button_explanation')  ${txt.tt('yellow_button_explanation')}
    'yellow_button_explanation': {
      'en':
          'The yellow card indicates that you are unsure of your answer. The card will move 7 positions down the list and reappear sooner than if you press the green button.',
      'ru':
          'Желтая карточка указывает на то, что вы не уверены в своем ответе. Карточка переместится вниз списка на 7 позиций и снова появится быстрее, чем при нажатии зеленой кнопки.',
      'uk':
          'Жовта картка вказує на те, що ви не впевнені у своїй відповіді. Картка переміститься вниз списку на 7 позицій і з\'явиться швидше, ніж при натисканні зеленої кнопки.',
    },

// txt.tt('red_button_explanation')  ${txt.tt('red_button_explanation')}
    'red_button_explanation': {
      'en':
          'The red button signals that you don\'t know the answer well or don\'t know it at all. The card will move only 1 position down and quickly return to the top of the list.',
      'ru':
          'Красная кнопка сигнализирует о том, что вы плохо знаете ответ или вовсе не знаете его. Карточка переместится только на 1 позицию вниз и быстро вернется в начало списка.',
      'uk':
          'Червона кнопка сигналізує про те, що ви погано знаєте відповідь або взагалі її не знаєте. Картка переміститься лише на 1 позицію вниз і швидко повернеться на початок списку.',
    },

// txt.tt('evaluation_reminder')  ${txt.tt('evaluation_reminder')}
    'evaluation_reminder': {
      'en': 'Remember, you need to assess yourself how well you know the answer and choose the corresponding button:',
      'ru': 'Помните, вам самим нужно оценивать, насколько хорошо вы знаете ответ, и выбирать соответствующую кнопку:',
      'uk': 'Пам\'ятайте, вам самим потрібно оцінювати, наскільки добре ви знаєте відповідь, і вибирати відповідну кнопку:',
    },

// txt.tt('green')  ${txt.tt('green')}
    'green': {
      'en': 'Well-known — Green.',
      'ru': 'Хорошо знаем — Зеленая.',
      'uk': 'Добре знаємо — Зелена.',
    },

// txt.tt('yellow')  ${txt.tt('yellow')}
    'yellow': {
      'en': 'Moderate and uncertain — Yellow.',
      'ru': 'Средне и неуверенно — Желтая.',
      'uk': 'Середньо і невпевнено — Жовта.',
    },

// txt.tt('red')  ${txt.tt('red')}
    'red': {
      'en': 'Poor or unknown — Red.',
      'ru': 'Плохо или не знаем — Красная.',
      'uk': 'Погано або не знаємо — Червона.',
    },

    'title': {
      'en': 'Welcome',
      'ru': 'Добро пожаловать!',
      'uk': 'Ласкаво просимо!',
    },

    'start': {
      'en': 'Start',
      'ru': 'Начать',
      'uk': 'Почати',
    },

    // txt.tt('back')  ${txt.tt('back')}
    'back': {
      'en': 'Back',
      'ru': 'Назад',
      'uk': 'Назад',
    },
  };

  final String languageCode;

  FirstEnterScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}

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
          'The application works according to the Leitner method, which is based on the idea that information is better retained in long-term memory if it is regularly repeated at increasing intervals. The less we know, the more often we need to remind ourselves of this information, and the better we know it, the less often we need to do so. Until it is fully stored in long-term memory.',
      'ru':
          'Приложение работает по методу Лейтнера, который основан на том, что информация лучше сохраняется в долгосрочной памяти, если регулярно повторять её с увеличивающимися интервалами. Чем хуже мы знаем, тем чаще нужно напоминать себе данную информацию, а чем лучше — тем реже. До полного запоминания в долгосрочной памяти.',
      'uk':
          'Додаток працює за методом Лейтнера, який заснований на тому, що інформація краще зберігається в довгостроковій пам\'яті, якщо регулярно повторювати її з наростаючими інтервалами. Чим гірше ми знаємо, тим частіше потрібно нагадувати собі цю інформацію, а чим краще — тим рідше. До повного запам\'ятовування в довгостроковій пам\'яті.',
    },

// txt.tt('deck_instruction')  ${txt.tt('deck_instruction')}
    'deck_instruction': {
      'en': 'Essentially, we have cards with a question on one side and an answer on the other. We always see the top cards in our deck.',
      'ru':
          'По сути, у нас есть карточки с вопросом на одной стороне и ответом на другой. Мы всегда видим самые верхние карточки в нашей колоде.',
      'uk': 'По суті, у нас є картки із питанням на одному боці та відповіддю на іншому. Ми завжди бачимо найверхні картки в нашій колоді.',
    },

    // txt.tt('green_icon_explanation')  ${txt.tt('green_icon_explanation')}
    'green_icon_explanation': {
      'en':
          'Press the green button if you know the answer for sure. The card will be moved to the bottom of the deck and will not appear at the top for a long time.',
      'ru':
          'Нажмите зеленую кнопку, если вы точно знаете ответ. Карточка будет перемещена в нижнюю часть колоды и долго не будет появляться сверху.',
      'uk':
          'Натисніть зелену кнопку, якщо ви точно знаєте відповідь. Картка буде переміщена в нижню частину колоди і довго не з\'являтиметься зверху.',
    },

    // txt.tt('yellow_red_buttons')  ${txt.tt('yellow_red_buttons')}
    'yellow_red_buttons': {
      'en':
          'Press or swipe the card to view the answer. After pressing, you will have time to press the yellow button or click on the card if you almost knew the answer.',
      'ru':
          'Нажмите или отодвиньте карточку, чтобы посмотреть ответ. После нажатия у вас будет время, чтобы нажать желтую кнопку или кликнуть по карточке, если вы почти знали ответ.',
      'uk':
          'Натисніть або посуньте картку, щоб подивитися відповідь. Після натискання у вас буде час, щоб натиснути жовту кнопку або клікнути по картці, якщо ви майже знали відповідь.',
    },

    // txt.tt('yellow_button_explanation')  ${txt.tt('yellow_button_explanation')}
    'yellow_button_explanation': {
      'en':
          'Tap the opened card or press the yellow button if you are unsure of your answer. The card will move to the middle of the deck.',
      'ru':
          'Тапните по открытой карточке или нажмите желтую кнопку, если вы не уверены в своем ответе. Карточка уйдёт в среднюю часть колоды.',
      'uk':
          'Торкніться відкритої картки або натисніть жовту кнопку, якщо ви не впевнені у своїй відповіді. Картка переміститься в середню частину колоди.',
    },


// txt.tt('wait_explanation')  ${txt.tt('wait_explanation')}
    'wait_explanation': {
      'en': 'If you reveal the answer by tapping and then do not press the yellow button, the red button will be triggered automatically.',
      'ru': 'Если открыть ответ нажатием и дальше не нажимать желтую кнопку, то автоматически сработает красная кнопка.',
      'uk': 'Якщо відкрити відповідь натисканням і далі не натискати жовту кнопку, то автоматично спрацює червона кнопка.',
    },

// txt.tt('red_button_explanation')  ${txt.tt('red_button_explanation')}
    'red_button_explanation': {
      'en': 'When you know the answer poorly, press the red button or simply wait. The card will close and move to the end of the first third of the deck.',
      'ru': 'Когда вы плохо знаете ответ, нажимайте красную кнопку или просто подождите. Карточка закроется и переместится в конец первой трети колоды.',
      'uk': 'Коли ви погано знаєте відповідь, натискайте червону кнопку або просто зачекайте. Картка закриється і переміститься в кінець першої третини колоди.',
    },

// txt.tt('evaluation_reminder')  ${txt.tt('evaluation_reminder')}
    'evaluation_reminder': {
      'en': 'The result depends on the frequency of repetitions. If you know poorly, repeat several times a day. For moderate knowledge, review once a day. For good retention in long-term memory, review once a week, and for excellent retention, review once a month.',
      'ru': 'Результат зависит от частоты повторений. Если вы знаете плохо, повторяйте несколько раз в день. Средние знания, напоминайте раз в день. Для хорошего закрепления в долгосрочной памяти нужно повторять раз в неделю, а для отличного — раз в месяц.',
      'uk': 'Результат залежить від частоти повторень. Якщо ви знаєте погано, повторюйте кілька разів на день. Середні знання — нагадуйте раз на день. Для доброго закріплення в довгостроковій пам\'яті потрібно повторювати раз на тиждень, а для відмінного — раз на місяць.',
    },

    // txt.tt('green_snackbar_message')  ${txt.tt('green_snackbar_message')}
    'green_snackbar_message': {
      'en': 'You pressed the green button — when you work with a real deck, this will mean that you are confident in your answer. The card will move to the bottom of the deck and will not appear for a long time.',
      'ru': 'Вы нажали зеленую кнопку — когда вы будете работать с реальной колодой, это будет означать, что вы уверены в своем ответе. Карточка переместится в нижнюю часть колоды и долго не появится на виду.',
      'uk': 'Ви натиснули зелену кнопку — коли ви працюватимете зі справжньою колодою, це означатиме, що ви впевнені у своїй відповіді. Картка переміститься в нижню частину колоди і довго не з\'являтиметься на виду.',
    },

// txt.tt('yellow_snackbar_message')  ${txt.tt('yellow_snackbar_message')}
    'yellow_snackbar_message': {
      'en': 'You pressed the yellow button — when you work with a real deck, this will mean that you are unsure of your answer. The card will move to the middle part of the deck for further review.',
      'ru': 'Вы нажали желтую кнопку — когда вы будете работать с реальной колодой, это будет означать, что вы не уверены в своем ответе. Карточка переместится в среднюю часть колоды для дальнейшего повторения.',
      'uk': 'Ви натиснули жовту кнопку — коли ви працюватимете зі справжньою колодою, це означатиме, що ви не впевнені у своїй відповіді. Картка переміститься в середню частину колоди для подальшого повторення.',
    },

// txt.tt('red_snackbar_message')  ${txt.tt('red_snackbar_message')}
    'red_snackbar_message': {
      'en': 'You pressed the red button — when you work with a real deck, this will mean that you poorly know the answer. The card will move to the end of the first third of the deck for more frequent review.',
      'ru': 'Вы нажали красную кнопку — когда вы будете работать с реальной колодой, это будет означать, что вы плохо знаете ответ. Карточка переместится в конец первой трети колоды для более частого повторения.',
      'uk': 'Ви натиснули червону кнопку — коли ви працюватимете зі справжньою колодою, це означатиме, що ви погано знаєте відповідь. Картка переміститься в кінець першої третини колоди для частішого повторення.',
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
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}

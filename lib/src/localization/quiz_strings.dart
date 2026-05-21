/// Static localization map for in-package UI text.
///
/// Three languages: 'ru' (default), 'uz', 'en'.
/// Missing keys fall back to Russian.
class QuizStrings {
  QuizStrings._(this.lang);

  factory QuizStrings.of(String lang) => QuizStrings._(_normalize(lang));

  final String lang;

  static String _normalize(String lang) {
    switch (lang) {
      case 'ru':
      case 'uz':
      case 'en':
        return lang;
      default:
        return 'ru';
    }
  }

  String get(String key) {
    final byLang = _all[lang] ?? _all['ru']!;
    return byLang[key] ?? _all['ru']![key] ?? key;
  }

  // ─── Verdicts (by correct count out of 10) ─────────────────────────────
  String verdict(int correct) {
    if (correct >= 10) return get('verdict_perfect');
    if (correct >= 8) return get('verdict_stellar');
    if (correct >= 6) return get('verdict_decent');
    if (correct >= 3) return get('verdict_could_be_better');
    return get('verdict_meh');
  }

  // ─── Tap accent for verdict (italic clay word at the end) ──────────────
  String verdictAccent(int correct) {
    if (correct >= 10) return get('verdict_perfect_accent');
    if (correct >= 8) return get('verdict_stellar_accent');
    if (correct >= 6) return get('verdict_decent_accent');
    if (correct >= 3) return get('verdict_could_be_better_accent');
    return get('verdict_meh_accent');
  }

  static const Map<String, Map<String, String>> _all = {
    'ru': {
      // Categories screen
      'hello': 'Привет,',
      'guest': 'Гость',
      'eyebrow_round': 'КВИЗ-РАУНД · 10 ВОПРОСОВ',
      'hero_title_part_1': 'Готов? Выбери',
      'hero_title_part_2': 'тему.',
      'hero_subtitle': 'Десять вопросов, 15 секунд на каждый. Чем быстрее — тем больше очков.',
      'section_categories': 'Категории',

      // Question screen
      'q_top_of_total': 'Вопрос {n} из {total}',
      'tag_choice': 'выбор ответа',
      'tag_true_false': 'правда/ложь',
      'toast_ok_1': 'В точку!',
      'toast_ok_2': 'Молодец!',
      'toast_ok_3': 'Отлично!',
      'toast_ok_4': 'Точно!',
      'toast_bad_timeout': 'Время вышло',
      'toast_bad_wrong': 'Мимо',
      'option_true': 'Правда',
      'option_false': 'Ложь',

      // Result screen
      'eyebrow_round_summary': 'ИТОГ РАУНДА',
      'verdict_perfect': 'Идеально.',
      'verdict_perfect_accent': 'Идеально.',
      'verdict_stellar': 'Звёздно.',
      'verdict_stellar_accent': 'Звёздно.',
      'verdict_decent': 'Неплохо.',
      'verdict_decent_accent': 'Неплохо.',
      'verdict_could_be_better': 'Можно лучше.',
      'verdict_could_be_better_accent': 'лучше.',
      'verdict_meh': 'Ну такое.',
      'verdict_meh_accent': 'такое.',
      'result_subtitle': '{correct} из {total} верно · среднее {sec} сек',
      'label_points': 'ОЧКИ',
      'stat_accuracy': 'точность',
      'stat_speed': 'скорость',
      'stat_sec_unit': 'сек',
      'review_title': 'РАЗБОР',
      'cta_play_again': 'играть ещё раз',
      'cta_leaderboard': 'в таблицу лидеров',
      'cta_home': 'на главную',

      // Leaderboard
      'eyebrow_top_week': 'ТОП НЕДЕЛИ',
      'leaderboard_title_part_1': 'Таблица',
      'leaderboard_title_part_2': 'лидеров',
      'leaderboard_subtitle': 'Кто отвечает быстрее всех',
      'you_badge': 'ВЫ',
      'leaderboard_empty': 'Сегодня здесь пока пусто.',

      // Tabs
      'tab_home': 'Главная',
      'tab_leaderboard': 'Лидеры',

      // Leaderboard breakdown bottom sheet
      'breakdown_total': 'НЕДЕЛЬНЫЙ ТОТАЛ',
      'breakdown_empty': 'Игрок ещё не сыграл ни в одной категории на этой неделе.',
      'meta_categories_short': 'кат.',

      // Config dialog
      'config_title': 'Конфигурация',
      'config_sound': 'Звук',
      'config_vibration': 'Вибрация',

      // Errors
      'error_no_questions': 'В этой категории пока нет вопросов.',
      'error_server': 'Произошла ошибка. Попробуй ещё раз.',
      'error_network': 'Нет соединения с сервером.',
    },
    'uz': {
      'hello': 'Salom,',
      'guest': 'Mehmon',
      'eyebrow_round': 'KVIZ-RAUND · 10 TA SAVOL',
      'hero_title_part_1': 'Tayyormisan? Mavzu',
      'hero_title_part_2': 'tanla.',
      'hero_subtitle': 'O‘nta savol, har biriga 15 soniya. Qancha tez bo‘lsa — shuncha ko‘p ochko.',
      'section_categories': 'Kategoriyalar',

      'q_top_of_total': 'Savol {n} / {total}',
      'tag_choice': 'javob tanlash',
      'tag_true_false': 'rost/yolg‘on',
      'toast_ok_1': 'Aniq!',
      'toast_ok_2': 'Barakalla!',
      'toast_ok_3': 'Zo‘r!',
      'toast_ok_4': 'Topding!',
      'toast_bad_timeout': 'Vaqt tugadi',
      'toast_bad_wrong': 'Yo‘qoldi',
      'option_true': 'Rost',
      'option_false': 'Yolg‘on',

      'eyebrow_round_summary': 'RAUND YAKUNI',
      'verdict_perfect': 'Mukammal.',
      'verdict_perfect_accent': 'Mukammal.',
      'verdict_stellar': 'Yulduzdek.',
      'verdict_stellar_accent': 'Yulduzdek.',
      'verdict_decent': 'Yomon emas.',
      'verdict_decent_accent': 'emas.',
      'verdict_could_be_better': 'Yaxshilash kerak.',
      'verdict_could_be_better_accent': 'kerak.',
      'verdict_meh': 'Shundayroq.',
      'verdict_meh_accent': 'Shundayroq.',
      'result_subtitle': '{total} dan {correct} ta to‘g‘ri · o‘rtacha {sec} soniya',
      'label_points': 'OCHKO',
      'stat_accuracy': 'aniqlik',
      'stat_speed': 'tezlik',
      'stat_sec_unit': 'son',
      'review_title': 'TAHLIL',
      'cta_play_again': 'yana o‘ynash',
      'cta_leaderboard': 'liderlar jadvaliga',
      'cta_home': 'bosh sahifaga',

      'eyebrow_top_week': 'HAFTA TOPI',
      'leaderboard_title_part_1': 'Liderlar',
      'leaderboard_title_part_2': 'jadvali',
      'leaderboard_subtitle': 'Eng tez javob beruvchilar',
      'you_badge': 'SIZ',
      'leaderboard_empty': 'Bugun bu yer hali bo‘sh.',

      'tab_home': 'Bosh',
      'tab_leaderboard': 'Liderlar',

      'breakdown_total': 'HAFTALIK NATIJA',
      'breakdown_empty': 'O‘yinchi bu hafta hech bir kategoriyada o‘ynamagan.',
      'meta_categories_short': 'kat.',

      'config_title': 'Sozlamalar',
      'config_sound': 'Ovoz',
      'config_vibration': 'Tebranish',

      'error_no_questions': 'Bu kategoriyada hali savol yo‘q.',
      'error_server': 'Xatolik yuz berdi. Yana urinib ko‘r.',
      'error_network': 'Server bilan aloqa yo‘q.',
    },
    'en': {
      'hello': 'Hi,',
      'guest': 'Guest',
      'eyebrow_round': 'QUIZ ROUND · 10 QUESTIONS',
      'hero_title_part_1': 'Ready? Pick a',
      'hero_title_part_2': 'topic.',
      'hero_subtitle': 'Ten questions, 15 seconds each. The faster you answer, the more points.',
      'section_categories': 'Categories',

      'q_top_of_total': 'Question {n} of {total}',
      'tag_choice': 'multiple choice',
      'tag_true_false': 'true/false',
      'toast_ok_1': 'Spot on!',
      'toast_ok_2': 'Nice!',
      'toast_ok_3': 'Brilliant!',
      'toast_ok_4': 'Exactly!',
      'toast_bad_timeout': 'Time’s up',
      'toast_bad_wrong': 'Missed it',
      'option_true': 'True',
      'option_false': 'False',

      'eyebrow_round_summary': 'ROUND RESULT',
      'verdict_perfect': 'Perfect.',
      'verdict_perfect_accent': 'Perfect.',
      'verdict_stellar': 'Stellar.',
      'verdict_stellar_accent': 'Stellar.',
      'verdict_decent': 'Decent.',
      'verdict_decent_accent': 'Decent.',
      'verdict_could_be_better': 'Could be better.',
      'verdict_could_be_better_accent': 'better.',
      'verdict_meh': 'Meh.',
      'verdict_meh_accent': 'Meh.',
      'result_subtitle': '{correct} of {total} correct · avg {sec} sec',
      'label_points': 'POINTS',
      'stat_accuracy': 'accuracy',
      'stat_speed': 'speed',
      'stat_sec_unit': 'sec',
      'review_title': 'REVIEW',
      'cta_play_again': 'play again',
      'cta_leaderboard': 'to leaderboard',
      'cta_home': 'home',

      'eyebrow_top_week': 'WEEK TOP',
      'leaderboard_title_part_1': 'Leaders',
      'leaderboard_title_part_2': 'board',
      'leaderboard_subtitle': 'Who answers fastest',
      'you_badge': 'YOU',
      'leaderboard_empty': 'No entries today yet.',

      'tab_home': 'Home',
      'tab_leaderboard': 'Leaders',

      'breakdown_total': 'WEEKLY TOTAL',
      'breakdown_empty': 'This player hasn’t scored in any category this week.',
      'meta_categories_short': 'cat.',

      'config_title': 'Settings',
      'config_sound': 'Sound',
      'config_vibration': 'Vibration',

      'error_no_questions': 'No questions in this category yet.',
      'error_server': 'Something went wrong. Try again.',
      'error_network': 'No connection to the server.',
    },
  };
}
